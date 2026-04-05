use clap::Parser;
use self_extract_rs::Loader;
use std::path::PathBuf;

#[derive(Parser, Debug)]
#[command(name = "app")]
#[command(about = "Self-extracting executable that runs packaged application")]
struct Args {
    #[arg(short, long, help = "Resource file to extract and run")]
    resource: Option<String>,

    #[arg(short, long, help = "Directory to extract to")]
    extract_dir: Option<String>,

    #[arg(
        short,
        long,
        default_value = "false",
        help = "List files in resource without extracting"
    )]
    list: bool,

    #[arg(short, long, default_value = "false", help = "Extract only, don't run")]
    extract_only: bool,

    #[arg(
        short,
        long,
        default_value = "false",
        help = "Keep extracted files after execution"
    )]
    keep: bool,
}

fn main() {
    let args = Args::parse();

    let resource_file = args
        .resource
        .map(PathBuf::from)
        .or_else(|| std::env::current_exe().ok())
        .or_else(|| {
            let exe_path = std::env::current_exe().unwrap_or_default();
            exe_path.with_extension("resource")
        });

    let resource_path = match resource_file {
        Some(p) => p,
        None => {
            eprintln!("Error: No resource file specified and could not determine default");
            std::process::exit(1);
        }
    };

    let loader = match Loader::load(&resource_path) {
        Ok(l) => l,
        Err(e) => {
            eprintln!(
                "Error loading resource '{}': {}",
                resource_path.display(),
                e
            );
            std::process::exit(1);
        }
    };

    if args.list {
        println!("Resource contents:");
        println!("  Entry point: {}", loader.entry_point());
        println!("  Files: {}", loader.file_count());
        return;
    }

    let default_extract = std::env::temp_dir().join("self-extract-app");
    let extract_dir = PathBuf::from(
        args.extract_dir
            .unwrap_or_else(|| default_extract.to_string_lossy().to_string()),
    );

    if args.extract_only {
        if let Err(e) = loader.extract_all(&extract_dir) {
            eprintln!("Error extracting: {}", e);
            std::process::exit(1);
        }
        return;
    }

    let child = match loader.extract_and_run(&extract_dir) {
        Ok(c) => c,
        Err(e) => {
            eprintln!("Error running application: {}", e);
            std::process::exit(1);
        }
    };

    let status = match child.wait_with_output() {
        Ok(s) => s,
        Err(e) => {
            eprintln!("Error waiting for child process: {}", e);
            std::process::exit(1);
        }
    };

    if !args.keep {
        let _ = std::fs::remove_dir_all(&extract_dir);
    }

    std::process::exit(status.status.code().unwrap_or(1));
}
