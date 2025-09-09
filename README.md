# Folder Monitor 3.0

**Automatically move files from one folder to another as soon as they appear**

Folder Monitor 3.0 is a native macOS application built with SwiftUI that watches a folder and automatically moves files to a destination folder when they appear. Perfect for organizing downloads, processing files, or automating file workflows.

## 🚀 Quick Start

### Download & Install

1. **Download** the latest release: `Folder Monitor 3.0.pkg`
2. **Install** by double-clicking the package
3. **Launch** from Applications folder

### First Use

1. **Open** Folder Monitor 3.0
2. **Create a Profile** - Set up your first monitoring rule
3. **Start Monitoring** - Click the green Start button
4. **Watch** files move automatically!

## ✨ Features

- **Real-time Monitoring** - Files are moved as soon as they appear
- **Multiple Profiles** - Set up different rules for different workflows
- **File Type Filtering** - Monitor only specific file types
- **Menu Bar Integration** - Quick access and status monitoring
- **Statistics & History** - Track what's been moved and when
- **Native Notifications** - Get notified when files are moved
- **Auto-conflict Resolution** - Automatically rename files if conflicts occur

## 📱 System Requirements

- **macOS 13.0** (Ventura) or later
- **Apple Silicon** or **Intel** Mac
- **Administrator privileges** for installation

## 🎯 Use Cases

- **Download Organization** - Automatically sort downloads by type
- **File Processing** - Move files to processing folders for batch operations
- **Backup Automation** - Organize files into backup locations
- **Workflow Automation** - Streamline file handling in daily tasks

## 📖 Documentation

- **[User Guide](README_APP.md)** - Complete user documentation
- **[Developer Guide](DEVELOPMENT.md)** - Build and development instructions

## 🔧 Development

This is a SwiftUI application built with Swift Package Manager.

### Building from Source

```bash
# Clone the repository
git clone https://github.com/yourusername/FolderMonitor3.0.git
cd FolderMonitor3.0

# Build the project
swift build

# Create app bundle
./create_app_bundle.sh
```

### Project Structure

```
FolderMonitor3.0/
├── Models/              # Data models and structures
├── Services/            # Business logic and file monitoring
├── Views/               # SwiftUI user interface
├── FolderMonitor3App.swift  # Main app entry point
├── Package.swift        # Swift Package Manager configuration
└── README_APP.md        # User documentation
```

## 🔒 Privacy & Security

- **Local Processing** - All operations happen on your Mac
- **No Internet Required** - Works completely offline
- **Secure** - Files only move between folders you specify
- **No Data Collection** - App doesn't collect or transmit personal data
- **Apple Notarized** - Verified safe by Apple

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📞 Support

For issues, questions, or feature requests, please open an issue on GitHub.

---

**Folder Monitor 3.0** - Making file organization automatic and effortless.

*Version 3.0.0 | © 2025 ENVO IT AS*