# lc2Self-Extract

Ein Go-Tool zum Komprimieren eines Verzeichnisses in eine Resource-Datei, die mit einem Loader als .exe ausgeführt werden kann.

## Download

- https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/lc2self-extract-go/bin/lc2loader.exe
- https://github.com/David-Honisch/Microsoft-Windows/raw/refs/heads/master/lc2self-extract-go/bin/lc2packer.exe

### Struktur

```
self-extract/
├── selfextract/     # Kernbibliothek
├── cmd/
│   ├── packer/      # CLI zum Erstellen von Resource-Dateien
│   └── loader/      # CLI zum Extrahieren und Ausführen
└── bin/              # Kompilierte Binaries
```

### Kompilieren

```bash
go build -o bin/lc2packer.exe ./cmd/packer
go build -o bin/lc2loader.exe ./cmd/loader
```

## Verwendung

### Resource erstellen (packer)

```bash
./bin/lc2packer.exe -source <verzeichnis> -output <resource-datei> -entry <einstiegspunkt>
```

Beispiel:
```bash
./bin/packer.exe -source my-app -output app.resource -entry start.bat
```

### Resource extrahieren/ausführen (loader)

```bash
./bin/lc2loader.exe -resource <resource-datei> [optionen]
```

Optionen:
- `-list`         : Dateien auflisten ohne zu extrahieren
- `-extract-only` : Nur extrahieren, nicht ausführen
- `-extract-dir`  : Zielverzeichnis (Standard: Temp)
- `-keep`         : Extrahierte Dateien nach Ausführung behalten

Beispiel:
```bash
# Nur Dateien auflisten
./bin/lc2loader.exe -resource app.resource -list

# Extrahieren und ausführen
./bin/lc2loader.exe -resource app.resource

# Nur extrahieren
./bin/lc2loader.exe -resource app.resource -extract-only -extract-dir ./output
```

## Resource-Format

Die Resource-Datei besteht aus:
1. 4 Bytes: Manifest-Länge (Little-Endian uint32)
2. JSON-Manifest mit Metadaten
3. XZ-komprimiertes TAR-Archiv mit allen Dateien
