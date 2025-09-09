import SwiftUI
import Charts

struct StatisticsView: View {
    @EnvironmentObject var monitorManager: MonitorManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Session Statistics
                SessionStatsCard()
                
                // File Type Distribution
                FileTypeChart()
                
                // Activity Timeline
                ActivityTimeline()
                
                // Quick Actions
                QuickActionsCard()
            }
            .padding()
        }
    }
}

// MARK: - Session Stats Card
struct SessionStatsCard: View {
    @EnvironmentObject var monitorManager: MonitorManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Session Statistics")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                StatCard(
                    title: "Files Moved",
                    value: "\(monitorManager.statistics.totalFilesMoved)",
                    icon: "arrow.right.circle.fill",
                    color: .green
                )
                
                StatCard(
                    title: "Errors",
                    value: "\(monitorManager.statistics.totalErrors)",
                    icon: "exclamationmark.triangle.fill",
                    color: .red
                )
                
                StatCard(
                    title: "Session Time",
                    value: monitorManager.statistics.formattedSessionDuration,
                    icon: "clock.fill",
                    color: .blue
                )
                
                StatCard(
                    title: "Last Activity",
                    value: monitorManager.statistics.lastFileMoved?.formatted(.relative(presentation: .named)) ?? "Never",
                    icon: "clock.arrow.circlepath",
                    color: .orange
                )
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - File Type Chart
struct FileTypeChart: View {
    @EnvironmentObject var monitorManager: MonitorManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("File Type Distribution")
                .font(.headline)
                .fontWeight(.semibold)
            
            if monitorManager.statistics.fileTypeCounts.isEmpty {
                Text("No file activity yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                    ForEach(Array(monitorManager.statistics.fileTypeCounts.sorted(by: { $0.value > $1.value })), id: \.key) { fileType, count in
                        FileTypeCard(fileType: fileType, count: count)
                    }
                }
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

// MARK: - File Type Card
struct FileTypeCard: View {
    let fileType: String
    let count: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text(fileType.isEmpty ? "No Ext" : ".\(fileType)")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text("\(count)")
                .font(.title3)
                .fontWeight(.bold)
            
            Text("files")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - Activity Timeline
struct ActivityTimeline: View {
    @EnvironmentObject var monitorManager: MonitorManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Recent Activity")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                if !monitorManager.recentEvents.isEmpty {
                    Button("Clear All") {
                        monitorManager.clearRecentEvents()
                    }
                    .buttonStyle(.borderless)
                    .font(.caption)
                }
            }
            
            if monitorManager.recentEvents.isEmpty {
                Text("No recent activity")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(monitorManager.recentEvents.prefix(20)) { event in
                            ActivityRowView(event: event)
                        }
                    }
                }
                .frame(maxHeight: 300)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

// MARK: - Activity Row View
struct ActivityRowView: View {
    let event: FileSystemEvent
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: event.eventType.icon)
                .foregroundColor(Color(event.eventType.color))
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(event.filePath.lastPathComponent)
                    .font(.caption)
                    .fontWeight(.medium)
                
                HStack {
                    Text(event.timestamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    if !event.success {
                        Text("• Error")
                            .font(.caption2)
                            .foregroundColor(.red)
                    }
                }
            }
            
            Spacer()
            
            if !event.success {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
                    .font(.caption)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(8)
    }
}

// MARK: - Quick Actions Card
struct QuickActionsCard: View {
    @EnvironmentObject var monitorManager: MonitorManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Actions")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 12) {
                Button("Reset Statistics") {
                    monitorManager.resetStatistics()
                }
                .buttonStyle(.bordered)
                
                Button("Clear Recent Events") {
                    monitorManager.clearRecentEvents()
                }
                .buttonStyle(.bordered)
                .disabled(monitorManager.recentEvents.isEmpty)
                
                Spacer()
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

#Preview {
    StatisticsView()
        .environmentObject(MonitorManager())
}