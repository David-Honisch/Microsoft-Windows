# LC2 Browser Memory Scanner

A Rust application that scans Internet Explorer and Microsoft Edge process memory to 
search for potential passwords and credentials.

## Download

<a href="https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/lc2ie-memory-scanner/lc2ie-memory-scanner.exe">lc2ie-memory-scanner.exe</a>

## ⚠️ Legal Disclaimer

**IMPORTANT:** This tool is provided for educational purposes and authorized security testing only. 

- Only use this tool on systems you own or have explicit written permission to test
- Unauthorized access to process memory may violate computer fraud and abuse laws
- The authors are not responsible for any misuse of this software
- Always comply with applicable laws and regulations in your jurisdiction

## Features

- **Process Discovery**: Automatically finds all running Internet Explorer and Microsoft Edge instances
- **Memory Scanning**: Reads process memory in chunks to search for credentials
- **Pattern Matching**: Uses regex patterns to identify potential passwords, usernames, and emails
- **Multi-Encoding Support**: Detects credentials in both UTF-8 and UTF-16 (Windows native) encoding
- **Safe Memory Access**: Implements proper error handling and memory safety

## Requirements

- **Operating System**: Windows (uses Windows API)
- **Privileges**: Administrator/elevated privileges required to read process memory
- **Rust**: 1.70 or later
- **Target Process**: Internet Explorer or Microsoft Edge must be running

## Installation

1. Clone or download this repository
2. Navigate to the project directory
3. Build the project:

```bash
cargo build --release
```

The compiled binary will be in `target/release/ie-memory-scanner.exe`

## Usage

### Running the Scanner

**You must run this as Administrator:**

```bash
# Run in debug mode
cargo run

# Or run the release binary
.\target\release\ie-memory-scanner.exe
```

### What It Does

1. **Finds Browser Processes**: Scans for all running `iexplore.exe` and `msedge.exe` processes
2. **Scans Memory**: Reads memory in 4KB chunks from each process
3. **Pattern Detection**: Searches for patterns like:
   - `password: <value>`
   - `passwd: <value>`
   - `pwd: <value>`
   - `username: <value>`
   - `email: <value>`
   - And similar variations

4. **Reports Findings**: Displays memory addresses and potential credentials found

### Example Output

```
=== Browser Memory Scanner ===
WARNING: This tool is for educational and authorized security testing only.
Unauthorized access to process memory may be illegal.

Found 2 IE process(es):
  - PID: 1234, Name: iexplore.exe
  - PID: 5678, Name: iexplore.exe
Found 3 Edge process(es):
  - PID: 9012, Name: msedge.exe
  - PID: 9013, Name: msedge.exe
  - PID: 9014, Name: msedge.exe

Scanning process: iexplore.exe (PID: 1234)
============================================================
Scanning process 1234 memory...
Scanned 10000 chunks total.

Found 3 potential credential(s):
  [0x00450000] username: john.doe@example.com
  [0x00451200] password: MySecretPass123
  [0x00452000] email: user@domain.com (UTF-16)

Scan complete.
```

## How It Works

### 1. Process Enumeration
Uses Windows `CreateToolhelp32Snapshot` API to enumerate all running processes and filter for Internet Explorer and Microsoft Edge.

### 2. Memory Reading
- Opens process with `PROCESS_VM_READ` and `PROCESS_QUERY_INFORMATION` permissions
- Reads memory in 4KB chunks starting from address `0x10000`
- Scans up to `0x7FFFFFFF` (max user-mode address on 32-bit)

### 3. Pattern Matching
- Converts memory chunks to UTF-8 and UTF-16 strings
- Applies regex patterns to find credential-like strings
- Filters duplicates and formats output with memory addresses

### 4. Safety Features
- Proper handle cleanup with `CloseHandle`
- Error handling for failed memory reads
- Bounds checking on memory addresses
- Safe UTF-8/UTF-16 conversion with error handling

## Technical Details

### Dependencies
- `winapi`: Windows API bindings for process and memory operations
- `regex`: Pattern matching for credential detection
- `encoding_rs`: Character encoding support

### Memory Layout
- Chunk size: 4096 bytes (4KB)
- Start address: 0x10000 (after null page)
- Max address: 0x7FFFFFFF (32-bit user space)

### Detected Patterns
The scanner looks for these credential patterns (case-insensitive):
- `password`, `passwd`, `pwd`, `pass` followed by `:`, `=`, or space
- `username`, `user`, `login` followed by `:`, `=`, or space
- `email` followed by `:`, `=`, or space with email format

## Limitations

- **32-bit Address Space**: Currently scans up to 0x7FFFFFFF (can be extended for 64-bit)
- **False Positives**: May detect non-credential data that matches patterns
- **Performance**: Full memory scan can take time depending on process size
- **Encoding**: Only supports UTF-8 and UTF-16 (most common on Windows)
- **Protected Memory**: Cannot read protected or kernel memory regions

## Building from Source

```bash
# Debug build
cargo build

# Release build (optimized)
cargo build --release

# Run tests (if any)
cargo test

# Check code
cargo check
```

## Security Considerations

### For Security Professionals
- Use this tool only in authorized penetration testing scenarios
- Document all usage in your security assessment reports
- Ensure you have proper authorization before scanning any system
- Consider the ethical implications of memory scanning

### For Developers
- This demonstrates why sensitive data should not be stored in plain text
- Use secure memory practices (e.g., `SecureString`, memory zeroing)
- Implement proper encryption for credentials
- Use credential managers instead of storing passwords in memory

## Troubleshooting

### "No Internet Explorer or Microsoft Edge processes found"
- Ensure Internet Explorer or Microsoft Edge is running
- Check that the process names are `iexplore.exe` or `msedge.exe`

### "Failed to create process snapshot"
- Run the application as Administrator
- Check Windows security settings

### "No potential credentials found"
- The browser may not have credentials in memory at scan time
- Try logging into a website first
- Credentials may be encrypted or obfuscated

### Access Denied Errors
- Ensure you're running with Administrator privileges
- Some processes may be protected by Windows security features
- Antivirus software may block memory access

## Contributing

This is an educational project. If you have improvements:
1. Ensure changes maintain security and safety
2. Add appropriate error handling
3. Update documentation
4. Test thoroughly on Windows systems

## License

This project is provided as-is for educational purposes. Use responsibly and legally.

## Acknowledgments

- Windows API documentation
- Rust community for excellent tooling
- Security researchers who study memory forensics

---

**Remember**: With great power comes great responsibility. Use this tool ethically and legally.