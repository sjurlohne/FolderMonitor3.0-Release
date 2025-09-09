import SwiftUI
import AppKit

// MARK: - Window Manager
@MainActor
class WindowManager: ObservableObject {
    static let shared = WindowManager()
    
    private var mainWindow: NSWindow?
    private var monitorManager: MonitorManager?
    private var settingsManager: SettingsManager?
    
    private init() {}
    
    func setManagers(monitorManager: MonitorManager, settingsManager: SettingsManager) {
        self.monitorManager = monitorManager
        self.settingsManager = settingsManager
    }
    
    func showMainWindow() {
        if let existingWindow = mainWindow, existingWindow.isVisible {
            // Window exists and is visible, just bring it to front
            existingWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        } else {
            // Create new window
            let window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 800, height: 700),
                styleMask: [.titled, .closable, .miniaturizable, .resizable],
                backing: .buffered,
                defer: false
            )
            
            window.title = "Folder Monitor 3.0"
            window.identifier = NSUserInterfaceItemIdentifier("main")
            window.center()
            window.setFrameAutosaveName("MainWindow")
            
            // Set the content view
            let contentView = ContentView()
                .environmentObject(monitorManager!)
                .environmentObject(settingsManager!)
            
            window.contentView = NSHostingView(rootView: contentView)
            
            // Store reference and show
            mainWindow = window
            window.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    func closeMainWindow() {
        mainWindow?.close()
        mainWindow = nil
    }
}
