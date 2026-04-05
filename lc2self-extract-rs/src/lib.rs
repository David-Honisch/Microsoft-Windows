use flate2::read::GzEncoder;
use flate2::write::GzDecoder;
use flate2::Compression;
use serde::{Deserialize, Serialize};
use std::fs::{self, File};
use std::io::{Read, Write};
use std::path::{Path, PathBuf};
use tar::{Archive, Builder};

#[derive(Serialize, Deserialize)]
pub struct ResourceManifest {
    pub version: String,
    pub created_at: String,
    pub entry_point: String,
    pub files: Vec<ResourceFile>,
}

#[derive(Serialize, Deserialize)]
pub struct ResourceFile {
    pub path: String,
    pub original_size: u64,
    pub compressed_size: u64,
}

pub struct Packer {
    manifest: ResourceManifest,
}

impl Packer {
    pub fn new(entry_point: &str) -> Self {
        Self {
            manifest: ResourceManifest {
                version: "1.0".to_string(),
                created_at: chrono_lite_now(),
                entry_point: entry_point.to_string(),
                files: Vec::new(),
            },
        }
    }

    pub fn add_directory(&mut self, source_dir: &Path) -> std::io::Result<()> {
        let mut entries: Vec<PathBuf> = Vec::new();

        for entry in walkdir::WalkDir::new(source_dir) {
            let entry = entry?;
            if entry.file_type().is_file() {
                entries.push(entry.path().to_path_buf());
            }
        }

        for file_path in entries {
            let relative_path = file_path
                .strip_prefix(source_dir)
                .unwrap_or(&file_path)
                .to_string_lossy()
                .replace('\\', "/");

            let file = File::open(&file_path)?;
            let original_size = file.metadata()?.len();

            self.manifest.files.push(ResourceFile {
                path: relative_path,
                original_size,
                compressed_size: 0,
            });
        }

        Ok(())
    }

    pub fn pack(&self, source_dir: &Path, output_file: &Path) -> std::io::Result<()> {
        let mut tar_data: Vec<u8> = Vec::new();
        {
            let encoder = GzEncoder::new(Vec::new(), Compression::default());
            let mut tar_builder =
                Builder::new(GzEncoder::new(&mut tar_data, Compression::default()));

            for file_path in walkdir::WalkDir::new(source_dir)
                .into_iter()
                .filter_map(|e| e.ok())
                .filter(|e| e.file_type().is_file())
            {
                let full_path = file_path.path();
                let relative_path = full_path
                    .strip_prefix(source_dir)
                    .unwrap_or(full_path)
                    .to_string_lossy()
                    .replace('\\', "/");

                tar_builder.append_path_with_name(full_path, &relative_path)?;
            }

            let encoder = tar_builder.into_inner()?;
            tar_data = encoder.finish().into_inner()?;
        }

        let manifest_json = serde_json::to_string(&self.manifest).unwrap();
        let manifest_bytes = manifest_json.as_bytes();

        let output = File::create(output_file)?;
        let mut writer = std::io::BufWriter::new(output);

        let manifest_len = (manifest_bytes.len() as u32).to_le_bytes();
        writer.write_all(&manifest_len)?;
        writer.write_all(manifest_bytes)?;
        writer.write_all(&tar_data)?;

        println!(
            "Packed {} files into {}",
            self.manifest.files.len(),
            output_file.display()
        );
        println!("Manifest size: {} bytes", manifest_bytes.len());
        println!("Compressed data size: {} bytes", tar_data.len());

        Ok(())
    }
}

pub struct Loader {
    manifest: ResourceManifest,
    data: Vec<u8>,
}

impl Loader {
    pub fn load(resource_file: &Path) -> std::io::Result<Self> {
        let mut file = File::open(resource_file)?;
        let mut buffer = Vec::new();
        file.read_to_end(&mut buffer)?;

        let manifest_len =
            u32::from_le_bytes([buffer[0], buffer[1], buffer[2], buffer[3]]) as usize;

        let manifest_bytes = &buffer[4..4 + manifest_len];
        let manifest: ResourceManifest = serde_json::from_slice(manifest_bytes)
            .map_err(|e| std::io::Error::new(std::io::ErrorKind::InvalidData, e))?;

        let data = buffer[4 + manifest_len..].to_vec();

        Ok(Self { manifest, data })
    }

    pub fn extract_all(&self, target_dir: &Path) -> std::io::Result<()> {
        fs::create_dir_all(target_dir)?;

        let decoder = GzDecoder::new(&self.data[..]);
        let mut archive = Archive::new(decoder);

        archive.unpack(target_dir)?;

        println!(
            "Extracted {} files to {}",
            self.manifest.files.len(),
            target_dir.display()
        );
        Ok(())
    }

    pub fn get_entry_point(&self) -> &str {
        &self.manifest.entry_point
    }

    pub fn extract_and_run(&self, target_dir: &Path) -> std::io::Result<std::process::Child> {
        self.extract_all(target_dir)?;

        let entry_path = target_dir.join(&self.manifest.entry_point);
        let mut cmd = std::process::Command::new(&entry_path);
        cmd.current_dir(target_dir);
        cmd.spawn()
            .map_err(|e| std::io::Error::new(std::io::ErrorKind::Other, e))
    }

    pub fn file_count(&self) -> usize {
        self.manifest.files.len()
    }

    pub fn entry_point(&self) -> &str {
        &self.manifest.entry_point
    }
}

fn chrono_lite_now() -> String {
    use std::time::{SystemTime, UNIX_EPOCH};
    let duration = SystemTime::now().duration_since(UNIX_EPOCH).unwrap();
    format!("{}", duration.as_secs())
}
