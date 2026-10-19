#!/bin/bash

# Fehler abfangen
set -e

echo "⏳ Erstelle temporäre Verzeichnisse..."
rm -rf src build
mkdir -p src/com/example
mkdir -p build

# 1. Erstelle die Standard-Hauptklasse
echo "📝 Generiere MainClass.java (Default)..."
cat << 'EOF' > src/com/example/MainClass.java
package com.example;

import java.util.Arrays;

public class MainClass {
    public static void main(String[] args) {
        System.out.println("🚀 [INFO] Hallo aus der Standard-Hauptklasse (MainClass)!");
        if (args.length > 0) {
            System.out.println("📥 Übergebene Argumente: " + Arrays.toString(args));
        } else {
            System.out.println("ℹ️ Keine zusätzlichen Argumente übergeben.");
        }
    }
}
EOF

# 2. Erstelle eine alternative Hauptklasse zum Testen
echo "📝 Generiere CustomClass.java (Spezifisch)..."
cat << 'EOF' > src/com/example/CustomClass.java
package com.example;

import java.util.Arrays;

public class CustomClass {
    public static void main(String[] args) {
        System.out.println("✨ [INFO] Hallo aus der alternativen Klasse (CustomClass)!");
        if (args.length > 0) {
            System.out.println("📥 Übergebene Argumente: " + Arrays.toString(args));
        } else {
            System.out.println("ℹ️ Keine zusätzlichen Argumente übergeben.");
        }
    }
}
EOF

# 3. Kompiliere den Java-Code
echo "⚙️ Kompiliere Java-Dateien..."
javac -d build src/com/example/*.java

# 4. Erstelle die Manifest-Datei für den Standard-Start
echo "📜 Erstelle Manifest..."
echo "Manifest-Version: 1.0" > build/MANIFEST.MF
echo "Main-Class: com.example.MainClass" >> build/MANIFEST.MF
# Wichtig bei Manifest-Dateien: Eine leere Zeile am Ende!
echo "" >> build/MANIFEST.MF

# 5. Verpacke alles in eine JAR-Datei
echo "📦 Verpacke in test-app.jar..."
jar cfm test-app.jar build/MANIFEST.MF -C build com

# Aufräumen
echo "🧹 Räume temporäre Verzeichnisse auf..."
rm -rf src build

echo "✅ Fertig! Die Datei 'test-app.jar' wurde erfolgreich erstellt."
