# Folder Monitor 3.0 - Development Guide

This guide covers everything you need to know to build, modify, and contribute to Folder Monitor 3.0.

## 🛠️ Development Setup

### Prerequisites

- **macOS 13.0** (Ventura) or later
- **Xcode 14.0** or later
- **Swift 5.7** or later
- **Git** for version control

### Getting Started

1. **Clone the repository:**
   ```bash
   git clone https://github.com/sjurlohne/FolderMonitor3.0-Release.git
   cd FolderMonitor3.0-Release
   ```

2. **Build the project:**
   ```bash
   swift build
   ```

3. **Create app bundle:**
   ```bash
   ./build.sh
   ```

4. **Run the app:**
   ```bash
   open "Folder Monitor 3.0.app"
   ```

## 📁 Project Structure

```
FolderMonitor3.0-Release/
├── Models/                          # Data models and structures
│   └── MonitorProfile.swift        # Profile data model and file system events
├── Services/                        # Business logic and core functionality
│   ├── FileSystemMonitor.swift     # File system monitoring implementation
│   ├── MonitorManager.swift        # Profile and monitoring management
│   ├── SettingsManager.swift       # Application settings and preferences
│   └── WindowManager.swift         # Window management and focus handling
├── Views/                          # SwiftUI user interface components
│   ├── ContentView.swift           # Main application interface
│   ├── MenuBarView.swift           # Menu bar dropdown interface
│   ├── ProfilesView.swift          # Profile management interface
│   ├── SettingsView.swift          # Settings and preferences interface
│   └── StatisticsView.swift        # Statistics and activity display
├── FolderMonitor3App.swift         # Main application entry point
├── Package.swift                   # Swift Package Manager configuration
├── build.sh                        # Build script for creating app bundle
├── README.md                       # Main project documentation
├── README_APP.md                   # User documentation
└── Folder Monitor 3.0.pkg          # Distribution package
```

## 🏗️ Architecture Overview

### Core Components

**Models:**
- `MonitorProfile` - Represents a monitoring configuration
- `FileSystemEvent` - Represents a file system event (created, moved, error)
- `MonitorStatistics` - Tracks monitoring statistics and performance

**Services:**
- `FileSystemMonitor` - Core file system monitoring using timer-based polling
- `MonitorManager` - Manages profiles and coordinates monitoring
- `SettingsManager` - Handles application settings and preferences
- `WindowManager` - Manages application windows and focus

**Views:**
- `ContentView` - Main tabbed interface
- `MenuBarView` - Menu bar dropdown with quick controls
- `ProfilesView` - Profile creation and management
- `SettingsView` - Application settings and configuration
- `StatisticsView` - Statistics display and activity history

### Data Flow

1. **User creates profile** → `MonitorManager` stores profile
2. **User starts monitoring** → `MonitorManager` activates `FileSystemMonitor`
3. **File system changes** → `FileSystemMonitor` detects and processes files
4. **UI updates** → `@Published` properties trigger SwiftUI updates
5. **Statistics tracking** → Events and statistics are recorded and displayed

## 🔧 Building and Development

### Swift Package Manager

The project uses Swift Package Manager for dependency management:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/apple/swift-charts", from: "1.0.0")
]
```

### Build Process

1. **Development Build:**
   ```bash
   swift build
   ```

2. **Release Build:**
   ```bash
   swift build --configuration release
   ```

3. **Create App Bundle:**
   ```bash
   ./build.sh
   ```

### Testing

The app includes comprehensive functionality testing:

- **File monitoring** - Test with various file types and sizes
- **Profile management** - Create, edit, and delete profiles
- **Settings persistence** - Verify settings are saved and restored
- **UI responsiveness** - Test real-time updates and statistics
- **Error handling** - Test with invalid paths and permissions

## 🎨 UI/UX Guidelines

### Design Principles

- **Native macOS experience** - Follow Apple's Human Interface Guidelines
- **SwiftUI best practices** - Use proper state management and data flow
- **Accessibility** - Ensure the app is accessible to all users
- **Performance** - Optimize for smooth real-time updates

### Key UI Components

- **Menu Bar Integration** - Native menu bar item with dropdown
- **Tabbed Interface** - Clean organization of features
- **Real-time Updates** - Live statistics and activity tracking
- **Status Indicators** - Clear visual feedback for monitoring state

## 🧪 Testing and Quality Assurance

### Testing Checklist

- [ ] **File Monitoring** - Test with various file types and sizes
- [ ] **Profile Management** - Create, edit, delete profiles
- [ ] **Settings Persistence** - Verify settings are saved
- [ ] **UI Updates** - Test real-time statistics and activity
- [ ] **Error Handling** - Test with invalid paths and permissions
- [ ] **Menu Bar Integration** - Test menu bar functionality
- [ ] **Notifications** - Verify native notifications work
- [ ] **Performance** - Test with large numbers of files
- [ ] **Memory Usage** - Monitor for memory leaks
- [ ] **Code Signing** - Verify app is properly signed

### Performance Considerations

- **File System Monitoring** - Uses efficient timer-based polling
- **Memory Management** - Proper cleanup of resources
- **UI Responsiveness** - Non-blocking file operations
- **Statistics Tracking** - Efficient data structures for performance

## 🐛 Debugging and Troubleshooting

### Common Issues

**Build Errors:**
- Ensure Xcode command line tools are installed
- Check Swift version compatibility
- Verify all dependencies are available

**Runtime Issues:**
- Check file permissions for watch and destination folders
- Verify folder paths are valid and accessible
- Monitor system logs for error messages

**UI Issues:**
- Check SwiftUI state management
- Verify @Published properties are properly bound
- Test on different macOS versions

### Debug Tools

- **Xcode Debugger** - For code-level debugging
- **Console.app** - For system-level logging
- **Activity Monitor** - For performance monitoring
- **Instruments** - For memory and performance profiling

## 📝 Contributing

### Development Workflow

1. **Fork the repository**
2. **Create a feature branch**
3. **Make your changes**
4. **Test thoroughly**
5. **Submit a pull request**

### Code Style

- **Swift Style Guide** - Follow Apple's Swift API Design Guidelines
- **SwiftUI Patterns** - Use proper state management and data flow
- **Documentation** - Comment complex logic and public APIs
- **Error Handling** - Implement proper error handling and user feedback

### Pull Request Guidelines

- **Clear description** - Explain what changes were made and why
- **Testing** - Include test results and verification steps
- **Documentation** - Update documentation if needed
- **Code review** - Ensure code follows project standards

## 🔄 Release Process

### Version Management

- **Semantic Versioning** - Use MAJOR.MINOR.PATCH format
- **Changelog** - Document all changes and improvements
- **Release Notes** - Provide clear upgrade instructions

### Distribution

1. **Build release version**
2. **Code sign and notarize**
3. **Create distribution package**
4. **Test on clean macOS system**
5. **Create GitHub release**
6. **Update documentation**

## 📚 Additional Resources

### Documentation

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [macOS Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/macos)
- [Swift Package Manager](https://swift.org/package-manager/)
- [Code Signing Guide](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)

---

**Happy Coding!** 🚀

For questions or support, please open an issue on GitHub or contact the development team.
