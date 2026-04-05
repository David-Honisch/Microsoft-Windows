use clap::Parser;
use self_extract_rs::{Loader, Packer};

#[derive(Parser, Debug)]
#[command(name = "packer")]
#[command(about = "Pack a directory into a self-extracting executable resource")]
struct Args {
    #[arg(short, long, help = "Source directory to pack")]
    source: String,

    #[arg(short, long, help = "Output resource file")]
    output: String,

    #[arg(short, long, help = "Entry point file (relative to source)")]
    entry_point: String,

    #[arg(
        short,
        long,
        default_value = "false",
        help = "Create self-extracting executable"
    )]
    create_exe: bool,
}

fn main() {
    let args = Args::parse();

    let source = PathBuf::from(&args.source);
    let output = PathBuf::from(&args.output);

    if !source.exists() {
        eprintln!("Error: Source directory '{}' does not exist", args.source);
        std::process::exit(1);
    }

    let mut packer = Packer::new(&args.entry_point);

    if let Err(e) = packer.add_directory(&source) {
        eprintln!("Error scanning directory: {}", e);
        std::process::exit(1);
    }

    if let Err(e) = packer.pack(&source, &output) {
        eprintln!("Error creating resource: {}", e);
        std::process::exit(1);
    }

    if args.create_exe {
        println!("Note: To create a self-extracting .exe, compile the 'app' binary and embed the resource.");
    }
}

use std::path::PathBuf;
