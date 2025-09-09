#!/bin/bash

# Folder Monitor 3.0 - Build Script
# This script builds the app and creates a distributable bundle

set -e

echo "🔨 Building Folder Monitor 3.0..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf .build
rm -rf "Folder Monitor 3.0.app"

# Build the project
echo "⚙️  Building project..."
swift build --configuration release

# Create app bundle
echo "📦 Creating app bundle..."

# Create bundle structure
mkdir -p "Folder Monitor 3.0.app/Contents/MacOS"
mkdir -p "Folder Monitor 3.0.app/Contents/Resources"

# Copy executable
cp .build/release/FolderMonitor3 "Folder Monitor 3.0.app/Contents/MacOS/"

# Create Info.plist
cat > "Folder Monitor 3.0.app/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>FolderMonitor3</string>
    <key>CFBundleIdentifier</key>
    <string>com.envoit.foldermonitor3</string>
    <key>CFBundleName</key>
    <string>Folder Monitor 3.0</string>
    <key>CFBundleVersion</key>
    <string>3.0.0</string>
    <key>CFBundleShortVersionString</key>
    <string>3.0.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>LSUIElement</key>
    <false/>
</dict>
</plist>
EOF

echo "✅ Build complete!"
echo "📱 App bundle created: Folder Monitor 3.0.app"
echo ""
echo "🚀 To run the app:"
echo "   open 'Folder Monitor 3.0.app'"
echo ""
echo "📦 To create a distributable package, use a tool like:"
echo "   - SD Notary 2 (recommended)"
echo "   - Xcode Archive & Export"
echo "   - Custom signing scripts"
