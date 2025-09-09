import Foundation
import Combine

// MARK: - Monitor Manager
@MainActor
class MonitorManager: ObservableObject {
    @Published var profiles: [MonitorProfile] = []
    @Published var activeProfile: MonitorProfile?
    
    private let fileSystemMonitor = FileSystemMonitor()
    private let settingsManager = SettingsManager()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
        loadProfiles()
    }
    
    // MARK: - Profile Management
    func addProfile(_ profile: MonitorProfile) {
        profiles.append(profile)
        saveProfiles()
    }
    
    func updateProfile(_ profile: MonitorProfile) {
        if let index = profiles.firstIndex(where: { $0.id == profile.id }) {
            profiles[index] = profile
            saveProfiles()
        }
    }
    
    func deleteProfile(_ profile: MonitorProfile) {
        profiles.removeAll { $0.id == profile.id }
        if activeProfile?.id == profile.id {
            activeProfile = nil
        }
        saveProfiles()
    }
    
    func setActiveProfile(_ profile: MonitorProfile) {
        activeProfile = profile
        saveProfiles()
    }
    
    // MARK: - Monitoring Control
    func startMonitoring() async {
        print("🔍 MonitorManager: Start monitoring requested")
        print("🔍 Active profile: \(activeProfile?.name ?? "None")")
        
        guard let profile = activeProfile else { 
            print("❌ No active profile set")
            return 
        }
        
        print("🔍 Starting monitoring with profile: \(profile.name)")
        await fileSystemMonitor.startMonitoring(profile: profile)
    }
    
    func stopMonitoring() {
        fileSystemMonitor.stopMonitoring()
    }
    
    // MARK: - Data Access
    var isMonitoring: Bool {
        fileSystemMonitor.isMonitoring
    }
    
    func clearRecentEvents() {
        fileSystemMonitor.clearRecentEvents()
    }
    
    func resetStatistics() {
        fileSystemMonitor.resetStatistics()
    }
    
    var recentEvents: [FileSystemEvent] {
        fileSystemMonitor.recentEvents
    }
    
    var statistics: MonitorStatistics {
        fileSystemMonitor.statistics
    }
    
    var errorMessage: String? {
        fileSystemMonitor.errorMessage
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        // Bind FileSystemMonitor's published properties to trigger UI updates
        fileSystemMonitor.$isMonitoring
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        fileSystemMonitor.$recentEvents
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        fileSystemMonitor.$statistics
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
        
        fileSystemMonitor.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    private func loadProfiles() {
        if let data = UserDefaults.standard.data(forKey: "savedProfiles"),
           let decodedProfiles = try? JSONDecoder().decode([MonitorProfile].self, from: data) {
            profiles = decodedProfiles
        }
        
        // Load active profile
        if let activeProfileId = UserDefaults.standard.string(forKey: "activeProfileId"),
           let profile = profiles.first(where: { $0.id.uuidString == activeProfileId }) {
            activeProfile = profile
        }
    }
    
    private func saveProfiles() {
        if let encoded = try? JSONEncoder().encode(profiles) {
            UserDefaults.standard.set(encoded, forKey: "savedProfiles")
        }
        
        if let activeProfile = activeProfile {
            UserDefaults.standard.set(activeProfile.id.uuidString, forKey: "activeProfileId")
        } else {
            UserDefaults.standard.removeObject(forKey: "activeProfileId")
        }
    }
}
