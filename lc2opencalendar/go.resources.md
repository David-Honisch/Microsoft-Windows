go compile with custom icon

To compile a Go application with a custom icon on Windows, you need to bundle the icon into a .syso resource file in your project's root directory. The go build command automatically detects and embeds .syso files into the compiled .exe binary.

Method 1: Using go-winres (Recommended)

go-winres is a modern, pure-Go tool that generates .syso files directly from .png or .ico files without needing external C compilers.
• Install the tool. Run the following command to install the CLI globally.bash
go install github.com/tc-hib/go-winres@latest
Verwende Code mit Vorsicht.
• Generate the resource file. Run go-winres inside your main package folder pointing to your icon.bash
go-winres simply --icon icon.png
Verwende Code mit Vorsicht.
• Compile your application. Run your normal build command, and Go will automatically embed the generated rsrc_windows_*.syso files.bash
go build -o myapp.exe
Verwende Code mit Vorsicht.
(Note: If you are building a GUI application without a terminal window, add --manifest gui to the go-winres command and -ldflags="-H windowsgui" to go build.)

Method 2: Using rsrc

If you already have a multi-resolution .ico file, akavel/rsrc is a lightweight alternative.
• Install the tool. Install rsrc using go install.bash
go install github.com/akavel/rsrc@latest
Verwende Code mit Vorsicht.
• Generate the .syso file. Specify your target architecture (such as amd64 or arm64) and your .ico file.bash
rsrc -arch amd64 -ico icon.ico -o rsrc.syso
Verwende Code mit Vorsicht.
• Build the binary. Place rsrc.syso alongside main.go and compile.bash
go build -o myapp.exe
Verwende Code mit Vorsicht.

Platform Notes (macOS & Linux)

• macOS: Standalone Mach-O binaries do not hold embedded icons. To display a custom icon in Finder or the Dock, wrap your compiled binary inside an .app bundle directory structure (MyApp.app/Contents/MacOS/myapp) with an Info.plist file and an .icns icon in Contents/Resources/.
• Linux: ELF binaries do not contain embedded icons. Desktop icons are handled externally by creating a .desktop entry file pointing to your executable and a .png or .svg icon path.
If you are targeting macOS or Linux, or need help adding Windows version metadata (company name, copyright, version number) alongside your icon, let me know and I can provide the exact setup!
KI-Antworten können Fehler enthalten. Weitere Informationen
• 
hjr265.me
Adding Icons for Go-built Windows Executable · hjr265.me
September 30, 2023 — Preparation: Convert PNG icons (sizes 16x16, 32x32, 48x48, 256x256) into a multi-sized `.ico` file using tools like ImageMagick (`
• 
Stack Overflow
How do you set the application icon in golang?
September 1, 2014 — 1 Comment Add a comment Jess Jess Over a year ago >1) Install mingw using Chocolatey: choco install mingw This requires 3rd party ...
• 
Reddit·r/golang
I Cant Build With Icon : r/golang
July 1, 2025 — I've tried every possible method I could find: * Used rsrc with the correct architecture: rsrc -ico icon.ico -arch amd64 -o rsrc.s...
Alle anzeigen