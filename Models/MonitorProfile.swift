import Foundation

// MARK: - Monitor Profile Model
struct MonitorProfile: Codable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    var watchFolder: URL
    var destinationFolder: URL
    var fileExtensions: [String]
    var isActive: Bool
    var createdDate: Date
    var lastUsedDate: Date
    
    init(name: String, watchFolder: URL, destinationFolder: URL, fileExtensions: [String] = [], isActive: Bool = false) {
        self.name = name
        self.watchFolder = watchFolder
        self.destinationFolder = destinationFolder
        self.fileExtensions = fileExtensions
        self.isActive = isActive
        self.createdDate = Date()
        self.lastUsedDate = Date()
    }
    
    // MARK: - Computed Properties
    var displayName: String {
        return name.isEmpty ? "Untitled Profile" : name
    }
    
    var fileExtensionsText: String {
        if fileExtensions.isEmpty {
            return "All files"
        }
        return fileExtensions.map { ".\($0)" }.joined(separator: ", ")
    }
    
    var isValid: Bool {
        return !name.isEmpty && 
               FileManager.default.fileExists(atPath: watchFolder.path) &&
               FileManager.default.fileExists(atPath: destinationFolder.path)
    }
}

// MARK: - File System Event
struct FileSystemEvent: Identifiable {
    let id = UUID()
    let filePath: URL
    let eventType: FileSystemEventType
    let timestamp: Date
    let success: Bool
    let errorMessage: String?
    
    enum FileSystemEventType {
        case created
        case moved
        case error
        
        var icon: String {
            switch self {
            case .created: return "plus.circle.fill"
            case .moved: return "arrow.right.circle.fill"
            case .error: return "exclamationmark.triangle.fill"
            }
        }
        
        var color: String {
            switch self {
            case .created: return "blue"
            case .moved: return "green"
            case .error: return "red"
            }
        }
        
        var description: String {
            switch self {
            case .created: return "Created"
            case .moved: return "Moved"
            case .error: return "Error"
            }
        }
    }
}

// MARK: - Monitor Statistics
struct MonitorStatistics: Codable {
    var totalFilesMoved: Int = 0
    var totalErrors: Int = 0
    var sessionStartTime: Date?
    var lastFileMoved: Date?
    var fileTypeCounts: [String: Int] = [:]
    
    var sessionDuration: TimeInterval {
        guard let startTime = sessionStartTime else { return 0 }
        return Date().timeIntervalSince(startTime)
    }
    
    var formattedSessionDuration: String {
        let duration = sessionDuration
        let hours = Int(duration) / 3600
        let minutes = Int(duration) % 3600 / 60
        let seconds = Int(duration) % 60
        
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%d:%02d", minutes, seconds)
        }
    }
}
