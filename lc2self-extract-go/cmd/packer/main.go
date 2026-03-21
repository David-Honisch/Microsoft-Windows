package main

import (
	"flag"
	"fmt"
	"os"

	// selfextract "lc2self-extract/lc2selfextract"
	selfextract "lc2self-extract/lc2selfextract"
)

func main() {
	source := flag.String("source", "", "Source directory to pack")
	output := flag.String("output", "", "Output resource file")
	entry := flag.String("entry", "", "Entry point file (relative to source)")

	flag.Usage = func() {
		fmt.Println("lc2packer - Pack a directory into a self-extracting executable resource")
		fmt.Println("(c) by David Honisch")
		fmt.Println("")
		fmt.Println("Usage:")
		fmt.Println("lc2packer -source <dir> -output <file> -entry <file>")
		fmt.Println("")
		fmt.Println("Options:")
		flag.PrintDefaults()
	}

	flag.Parse()

	if *source == "" || *output == "" || *entry == "" {
		flag.Usage()
		os.Exit(1)
	}

	if _, err := os.Stat(*source); os.IsNotExist(err) {
		fmt.Fprintf(os.Stderr, "Error: Source directory '%s' does not exist\n", *source)
		os.Exit(1)
	}

	packer := selfextract.NewPacker(*entry)
	if err := packer.AddDirectory(*source); err != nil {
		fmt.Fprintf(os.Stderr, "Error scanning directory: %v\n", err)
		os.Exit(1)
	}

	if err := packer.Pack(*source, *output); err != nil {
		fmt.Fprintf(os.Stderr, "Error creating resource: %v\n", err)
		os.Exit(1)
	}
}
