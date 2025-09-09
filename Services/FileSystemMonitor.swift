import Foundation
import Combine
import UserNotifications

// MARK: - Simple File System Monitor

// MARK: - File System Monitor Service
@MainActor
class FileSystemMonitor: ObservableObject {
    @Published var isMonitoring = false
    @Published var currentProfile: MonitorProfile?
    @Published var recentEvents: [FileSystemEvent] = []
    @Published var statistics = MonitorStatistics()
    @Published var errorMessage: String?
    
    private var fileCheckTimer: Timer?
    private var lastCheckedFiles: Set<String> = []
    
    // MARK: - Monitoring Control
    func startMonitoring(profile: MonitorProfile) async {
        print("🔍 FileSystemMonitor: Starting monitoring for profile: \(profile.name)")
        print("🔍 Watch folder: \(profile.watchFolder.path)")
        print("🔍 Destination folder: \(profile.destinationFolder.path)")
        print("🔍 File extensions: \(profile.fileExtensions)")
        
        guard !isMonitoring else { 
            print("⚠️ Already monitoring, ignoring start request")
            return 
        }
        guard profile.isValid else {
            print("❌ Invalid profile configuration")
            errorMessage = "Invalid profile configuration"
            return
        }
        
        currentProfile = profile
        statistics.sessionStartTime = Date()
        errorMessage = nil
        
        // Start a simple timer-based monitoring for now
        startFileCheckTimer()
        
        isMonitoring = true
        print("✅ FileSystemMonitor: Monitoring started successfully")
        
        // Update profile last used date
        var updatedProfile = profile
        updatedProfile.lastUsedDate = Date()
        currentProfile = updatedProfile
    }
    
    func stopMonitoring() {
        fileCheckTimer?.invalidate()
        fileCheckTimer = nil
        isMonitoring = false
        currentProfile = nil
        statistics.sessionStartTime = nil
        errorMessage = nil
        lastCheckedFiles.removeAll()
    }
    
    // MARK: - File Checking
    private func startFileCheckTimer() {
        fileCheckTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.checkForNewFiles()
            }
        }
    }
    
    private func checkForNewFiles() async {
        guard let profile = currentProfile else { return }
        
        do {
            let files = try FileManager.default.contentsOfDirectory(at: profile.watchFolder, includingPropertiesForKeys: [.isRegularFileKey])
            let currentFiles = Set(files.map { $0.path })
            
            // Find new files
            let newFiles = currentFiles.subtracting(lastCheckedFiles)
            
            for filePath in newFiles {
                let fileURL = URL(fileURLWithPath: filePath)
                await processNewFile(fileURL, profile: profile)
            }
            
            lastCheckedFiles = currentFiles
            
        } catch {
            print("Error checking for new files: \(error)")
        }
    }
    
    private func processNewFile(_ fileURL: URL, profile: MonitorProfile) async {
        // Check file extension if specified
        if !profile.fileExtensions.isEmpty {
            let fileExtension = fileURL.pathExtension.lowercased()
            guard profile.fileExtensions.contains(where: { $0.lowercased() == fileExtension }) else { return }
        }
        
        // Move the file
        await moveFile(fileURL, to: profile.destinationFolder)
    }
    
    // MARK: - File Moving
    private func moveFile(_ sourceURL: URL, to destinationFolder: URL) async {
        let fileName = sourceURL.lastPathComponent
        let destinationURL = destinationFolder.appendingPathComponent(fileName)
        
        do {
            // Handle file conflicts
            let finalDestinationURL = await resolveFileConflict(destinationURL)
            
            // Move the file
            try FileManager.default.moveItem(at: sourceURL, to: finalDestinationURL)
            
            // Update statistics
            statistics.totalFilesMoved += 1
            statistics.lastFileMoved = Date()
            
            // Update file type count
            let fileExtension = sourceURL.pathExtension.lowercased()
            statistics.fileTypeCounts[fileExtension, default: 0] += 1
            
            // Add to recent events
            let event = FileSystemEvent(
                filePath: finalDestinationURL,
                eventType: .moved,
                timestamp: Date(),
                success: true,
                errorMessage: nil
            )
            recentEvents.insert(event, at: 0)
            
            // Keep only last 50 events
            if recentEvents.count > 50 {
                recentEvents = Array(recentEvents.prefix(50))
            }
            
            // Send notification
            await sendNotification(title: "File Moved", body: "\(fileName) moved successfully")
            
        } catch {
            // Handle error
            statistics.totalErrors += 1
            
            let event = FileSystemEvent(
                filePath: sourceURL,
                eventType: .error,
                timestamp: Date(),
                success: false,
                errorMessage: error.localizedDescription
            )
            recentEvents.insert(event, at: 0)
            
            errorMessage = "Failed to move \(fileName): \(error.localizedDescription)"
            
            // Send error notification
            await sendNotification(title: "Move Failed", body: "Failed to move \(fileName)")
        }
    }
    
    private func resolveFileConflict(_ url: URL) async -> URL {
        guard FileManager.default.fileExists(atPath: url.path) else { return url }
        
        let baseURL = url.deletingLastPathComponent()
        let fileName = url.deletingPathExtension().lastPathComponent
        let fileExtension = url.pathExtension
        let pathExtension = fileExtension.isEmpty ? "" : ".\(fileExtension)"
        
        var counter = 1
        var newURL: URL
        
        repeat {
            let newFileName = "\(fileName) (\(counter))\(pathExtension)"
            newURL = baseURL.appendingPathComponent(newFileName)
            counter += 1
        } while FileManager.default.fileExists(atPath: newURL.path)
        
        return newURL
    }
    
    private func sendNotification(title: String, body: String) async {
        print("📢 \(title): \(body)")
        
        // Request notification permissions
        let center = UNUserNotificationCenter.current()
        let granted = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
        
        guard granted == true else {
            print("❌ Notification permission denied")
            return
        }
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.categoryIdentifier = "FOLDER_MONITOR"
        
        // Create notification request
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil // Show immediately
        )
        
        // Send notification
        do {
            try await center.add(request)
            print("✅ Notification sent: \(title)")
        } catch {
            print("❌ Failed to send notification: \(error)")
        }
    }
    
    // MARK: - Statistics
    func resetStatistics() {
        statistics = MonitorStatistics()
        recentEvents.removeAll()
    }
    
    func clearRecentEvents() {
        recentEvents.removeAll()
    }
}