package selfextract

import (
	"archive/tar"
	"bytes"
	"crypto/sha256"
	"encoding/binary"
	"encoding/json"
	"fmt"
	"github.com/ulikunitz/xz"
	"io"
	"os"
	"path/filepath"
	"time"
)

type Manifest struct {
	Version    string      `json:"version"`
	CreatedAt  string      `json:"created_at"`
	EntryPoint string      `json:"entry_point"`
	Checksum   string      `json:"checksum"`
	Files      []FileEntry `json:"files"`
}

type FileEntry struct {
	Path           string `json:"path"`
	OriginalSize   int64  `json:"original_size"`
	CompressedSize int64  `json:"compressed_size"`
}

type Packer struct {
	manifest Manifest
}

func NewPacker(entryPoint string) *Packer {
	return &Packer{
		manifest: Manifest{
			Version:    "1.0",
			CreatedAt:  time.Now().UTC().Format(time.RFC3339),
			EntryPoint: entryPoint,
			Files:      make([]FileEntry, 0),
		},
	}
}

func (p *Packer) AddDirectory(sourceDir string) error {
	return filepath.Walk(sourceDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}

		relPath, err := filepath.Rel(sourceDir, path)
		if err != nil {
			return err
		}
		relPath = filepath.ToSlash(relPath)

		p.manifest.Files = append(p.manifest.Files, FileEntry{
			Path:         relPath,
			OriginalSize: info.Size(),
		})
		return nil
	})
}

func (p *Packer) Pack(sourceDir, outputFile string) error {
	var tarData bytes.Buffer
	gzWriter, err := xz.NewWriter(&tarData)
	if err != nil {
		return fmt.Errorf("creating xz writer: %w", err)
	}
	tarWriter := tar.NewWriter(gzWriter)

	err = filepath.Walk(sourceDir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if info.IsDir() {
			return nil
		}

		relPath, err := filepath.Rel(sourceDir, path)
		if err != nil {
			return err
		}
		relPath = filepath.ToSlash(relPath)

		data, err := os.ReadFile(path)
		if err != nil {
			return fmt.Errorf("reading file %s: %w", path, err)
		}

		header := &tar.Header{
			Name:    relPath,
			Size:    info.Size(),
			Mode:    int64(info.Mode()),
			ModTime: info.ModTime(),
		}

		if err := tarWriter.WriteHeader(header); err != nil {
			return fmt.Errorf("writing tar header: %w", err)
		}
		if _, err := tarWriter.Write(data); err != nil {
			return fmt.Errorf("writing tar data: %w", err)
		}

		for i := range p.manifest.Files {
			if p.manifest.Files[i].Path == relPath {
				p.manifest.Files[i].CompressedSize = int64(len(data))
				break
			}
		}

		return nil
	})
	if err != nil {
		return err
	}

	if err := tarWriter.Close(); err != nil {
		return fmt.Errorf("closing tar writer: %w", err)
	}
	if err := gzWriter.Close(); err != nil {
		return fmt.Errorf("closing xz writer: %w", err)
	}

	p.manifest.Checksum = checksum(tarData.Bytes())

	manifestJSON, err := json.MarshalIndent(p.manifest, "", "  ")
	if err != nil {
		return fmt.Errorf("marshaling manifest: %w", err)
	}

	output, err := os.Create(outputFile)
	if err != nil {
		return fmt.Errorf("creating output file: %w", err)
	}
	defer output.Close()

	if err := binary.Write(output, binary.LittleEndian, uint32(len(manifestJSON))); err != nil {
		return fmt.Errorf("writing manifest length: %w", err)
	}
	if _, err := output.Write(manifestJSON); err != nil {
		return fmt.Errorf("writing manifest: %w", err)
	}
	if _, err := output.Write(tarData.Bytes()); err != nil {
		return fmt.Errorf("writing tar data: %w", err)
	}

	fmt.Printf("Packed %d files into %s\n", len(p.manifest.Files), outputFile)
	fmt.Printf("Manifest size: %d bytes\n", len(manifestJSON))
	fmt.Printf("Compressed data size: %d bytes\n", tarData.Len())

	return nil
}

type Loader struct {
	manifest Manifest
	data     []byte
}

func Load(resourceFile string) (*Loader, error) {
	data, err := os.ReadFile(resourceFile)
	if err != nil {
		return nil, fmt.Errorf("reading file: %w", err)
	}

	if len(data) < 4 {
		return nil, fmt.Errorf("file too small")
	}

	var manifestLen uint32
	if err := binary.Read(bytes.NewReader(data[:4]), binary.LittleEndian, &manifestLen); err != nil {
		return nil, fmt.Errorf("reading manifest length: %w", err)
	}

	if int(manifestLen)+4 > len(data) {
		return nil, fmt.Errorf("invalid manifest length")
	}

	manifestJSON := data[4 : 4+manifestLen]
	var manifest Manifest
	if err := json.Unmarshal(manifestJSON, &manifest); err != nil {
		return nil, fmt.Errorf("unmarshaling manifest: %w", err)
	}

	tarData := data[4+manifestLen:]

	calculatedChecksum := checksum(tarData)
	if manifest.Checksum != "" && manifest.Checksum != calculatedChecksum {
		return nil, fmt.Errorf("checksum mismatch: expected %s, got %s", manifest.Checksum, calculatedChecksum)
	}

	return &Loader{
		manifest: manifest,
		data:     tarData,
	}, nil
}

func (l *Loader) List() {
	fmt.Printf("Resource contents:\n")
	fmt.Printf("  Entry point: %s\n", l.manifest.EntryPoint)
	fmt.Printf("  Files: %d\n", len(l.manifest.Files))
	for _, f := range l.manifest.Files {
		fmt.Printf("    %s (%d bytes)\n", f.Path, f.OriginalSize)
	}
}

func (l *Loader) ExtractAll(targetDir string) error {
	if err := os.MkdirAll(targetDir, 0755); err != nil {
		return fmt.Errorf("creating target directory: %w", err)
	}

	gzReader, err := xz.NewReader(bytes.NewReader(l.data))
	if err != nil {
		return fmt.Errorf("creating xz reader: %w", err)
	}
	tarReader := tar.NewReader(gzReader)

	for {
		header, err := tarReader.Next()
		if err == io.EOF {
			break
		}
		if err != nil {
			return fmt.Errorf("reading tar: %w", err)
		}

		targetPath := filepath.Join(targetDir, header.Name)

		if header.FileInfo().IsDir() {
			if err := os.MkdirAll(targetPath, 0755); err != nil {
				return fmt.Errorf("creating directory %s: %w", targetPath, err)
			}
			continue
		}

		if err := os.MkdirAll(filepath.Dir(targetPath), 0755); err != nil {
			return fmt.Errorf("creating directory %s: %w", filepath.Dir(targetPath), err)
		}

		outFile, err := os.OpenFile(targetPath, os.O_CREATE|os.O_WRONLY|os.O_TRUNC, os.FileMode(header.Mode))
		if err != nil {
			return fmt.Errorf("creating file %s: %w", targetPath, err)
		}

		if _, err := io.Copy(outFile, tarReader); err != nil {
			outFile.Close()
			return fmt.Errorf("writing file %s: %w", targetPath, err)
		}
		outFile.Close()
	}

	fmt.Printf("Extracted %d files to %s\n", len(l.manifest.Files), targetDir)
	return nil
}

func (l *Loader) GetEntryPoint() string {
	return l.manifest.EntryPoint
}

func (l *Loader) ExtractAndRun(targetDir string) (*os.Process, error) {
	if err := l.ExtractAll(targetDir); err != nil {
		return nil, err
	}

	entryPath := filepath.Join(targetDir, l.manifest.EntryPoint)

	proc, err := os.StartProcess(entryPath, []string{entryPath}, &os.ProcAttr{
		Dir:   targetDir,
		Files: []*os.File{os.Stdin, os.Stdout, os.Stderr},
	})
	if err != nil {
		return nil, fmt.Errorf("starting process: %w", err)
	}

	return proc, nil
}

func checksum(data []byte) string {
	h := sha256.New()
	h.Write(data)
	return fmt.Sprintf("%x", h.Sum(nil))
}
