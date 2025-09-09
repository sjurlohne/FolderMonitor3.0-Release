// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FolderMonitor3",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "FolderMonitor3",
            targets: ["FolderMonitor3"]
        )
    ],
    dependencies: [
        // No external dependencies for now - using native SwiftUI and Foundation
    ],
    targets: [
        .executableTarget(
            name: "FolderMonitor3",
            dependencies: [],
            path: ".",
            exclude: [
                "build.sh",
                "test_app_functionality.md",
                "BUILD_FIXES.md"
            ],
            sources: [
                "FolderMonitor3App.swift",
                "Models/MonitorProfile.swift",
                "Services/FileSystemMonitor.swift",
                "Services/MonitorManager.swift",
                "Services/SettingsManager.swift",
                "Services/WindowManager.swift",
                "Views/ContentView.swift",
                "Views/ProfilesView.swift",
                "Views/StatisticsView.swift",
                "Views/MenuBarView.swift",
                "Views/SettingsView.swift"
            ],
            resources: [
                .process("README.md")
            ]
        )
    ]
)
