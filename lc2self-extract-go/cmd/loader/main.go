package main

import (
	"flag"
	"fmt"
	"os"
	"path/filepath"

	selfextract "lc2self-extract/lc2selfextract"
)

func main() {
	resource := flag.String("resource", "", "Resource file to extract and run")
	extractDir := flag.String("extract-dir", "", "Directory to extract to")
	list := flag.Bool("list", false, "List files in resource without extracting")
	extractOnly := flag.Bool("extract-only", false, "Extract only, don't run")
	keep := flag.Bool("keep", false, "Keep extracted files after execution")

	flag.Usage = func() {
		fmt.Println("app - Self-extracting executable that runs packaged application")
		fmt.Println("")
		fmt.Println("Usage:")
		fmt.Println("  app [options]")
		fmt.Println("")
		fmt.Println("Options:")
		flag.PrintDefaults()
	}

	flag.Parse()

	var resourcePath string

	if *resource != "" {
		resourcePath = *resource
	} else {
		exePath, err := os.Executable()
		if err == nil {
			resourcePath = exePath
		} else {
			fmt.Fprintf(os.Stderr, "Error: No resource file specified and could not determine default\n")
			os.Exit(1)
		}
	}

	loader, err := selfextract.Load(resourcePath)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error loading resource '%s': %v\n", resourcePath, err)
		os.Exit(1)
	}

	if *list {
		loader.List()
		return
	}

	if *extractDir == "" {
		*extractDir = filepath.Join(os.TempDir(), "self-extract-app")
	}

	if *extractOnly {
		if err := loader.ExtractAll(*extractDir); err != nil {
			fmt.Fprintf(os.Stderr, "Error extracting: %v\n", err)
			os.Exit(1)
		}
		return
	}

	proc, err := loader.ExtractAndRun(*extractDir)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error running application: %v\n", err)
		os.Exit(1)
	}

	state, err := proc.Wait()
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error waiting for child process: %v\n", err)
		os.Exit(1)
	}

	if !*keep {
		os.RemoveAll(*extractDir)
	}

	os.Exit(state.ExitCode())
}
