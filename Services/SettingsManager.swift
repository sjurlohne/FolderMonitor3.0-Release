import Foundation
import Combine

// MARK: - Settings Manager
@MainActor
class SettingsManager: ObservableObject {
    @Published var enableNotifications: Bool = true
    @Published var showInMenuBar: Bool = true
    @Published var autoStartOnLaunch: Bool = false
    @Published var checkInterval: Double = 1.0
    @Published var maxRecentEvents: Int = 50
    @Published var enableFileConflictResolution: Bool = true
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadSettings()
    }
    
    // MARK: - Settings Management
    func updateSetting<T>(_ keyPath: WritableKeyPath<SettingsManager, T>, value: T) {
        // This method is not used in the current implementation
        saveSettings()
    }
    
    func resetToDefaults() {
        enableNotifications = true
        showInMenuBar = true
        autoStartOnLaunch = false
        checkInterval = 1.0
        maxRecentEvents = 50
        enableFileConflictResolution = true
        saveSettings()
    }
    
    // MARK: - Private Methods
    private func loadSettings() {
        enableNotifications = userDefaults.object(forKey: "enableNotifications") as? Bool ?? true
        showInMenuBar = userDefaults.object(forKey: "showInMenuBar") as? Bool ?? true
        autoStartOnLaunch = userDefaults.object(forKey: "autoStartOnLaunch") as? Bool ?? false
        checkInterval = userDefaults.object(forKey: "checkInterval") as? Double ?? 1.0
        maxRecentEvents = userDefaults.object(forKey: "maxRecentEvents") as? Int ?? 50
        enableFileConflictResolution = userDefaults.object(forKey: "enableFileConflictResolution") as? Bool ?? true
    }
    
    private func saveSettings() {
        userDefaults.set(enableNotifications, forKey: "enableNotifications")
        userDefaults.set(showInMenuBar, forKey: "showInMenuBar")
        userDefaults.set(autoStartOnLaunch, forKey: "autoStartOnLaunch")
        userDefaults.set(checkInterval, forKey: "checkInterval")
        userDefaults.set(maxRecentEvents, forKey: "maxRecentEvents")
        userDefaults.set(enableFileConflictResolution, forKey: "enableFileConflictResolution")
    }
}
