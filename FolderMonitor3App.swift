import SwiftUI

@main
struct FolderMonitor3App: App {
    @StateObject private var monitorManager = MonitorManager()
    @StateObject private var settingsManager = SettingsManager()
    @StateObject private var windowManager = WindowManager.shared
    
    var body: some Scene {
        WindowGroup(id: "main") {
            ContentView()
                .environmentObject(monitorManager)
                .environmentObject(settingsManager)
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 800, height: 700)
        
        // Menu Bar Extra with clean folder icon
        MenuBarExtra(isInserted: .constant(true)) {
            MenuBarView()
                .environmentObject(monitorManager)
        } label: {
            Image(systemName: "folder.badge.gearshape")
                .font(.system(size: 16))
                .foregroundColor(.primary)
        }
        .menuBarExtraStyle(.menu)
    }
}