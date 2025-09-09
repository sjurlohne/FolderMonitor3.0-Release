import SwiftUI

struct ContentView: View {
    @EnvironmentObject var monitorManager: MonitorManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selectedTab = 0
    @State private var showingProfileEditor = false
    @State private var showingSettings = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HeaderView()
            
            // Tab Content
            TabView(selection: $selectedTab) {
                // Monitor Tab
                MonitorView(showingProfileEditor: $showingProfileEditor)
                    .tabItem {
                        Image(systemName: "folder")
                        Text("Monitor")
                    }
                    .tag(0)
                
                // Profiles Tab
                ProfilesView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Profiles")
                    }
                    .tag(1)
                
                // Statistics Tab
                StatisticsView()
                    .tabItem {
                        Image(systemName: "chart.bar")
                        Text("Statistics")
                    }
                    .tag(2)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            // Ensure the window can receive focus
            NSApp.activate(ignoringOtherApps: true)
        }
        .sheet(isPresented: $showingProfileEditor) {
            ProfileEditorView()
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

// MARK: - Header View
struct HeaderView: View {
    @EnvironmentObject var monitorManager: MonitorManager
    @State private var showingSettings = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Folder Monitor 3.0")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack {
                    Circle()
                        .fill(monitorManager.isMonitoring ? Color.green : Color.red)
                        .frame(width: 8, height: 8)
                    
                    Text(monitorManager.isMonitoring ? "Running" : "Stopped")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Start/Stop Button
            Button(action: {
                Task {
                    if monitorManager.isMonitoring {
                        monitorManager.stopMonitoring()
                    } else {
                        await monitorManager.startMonitoring()
                    }
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: monitorManager.isMonitoring ? "stop.circle.fill" : "play.circle.fill")
                    Text(monitorManager.isMonitoring ? "Stop" : "Start")
                }
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(monitorManager.isMonitoring ? Color.red : Color.green)
                .cornerRadius(6)
            }
            .buttonStyle(PlainButtonStyle())
            
            // Settings Button
            Button(action: {
                showingSettings = true
            }) {
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }
}

// MARK: - Monitor View
struct MonitorView: View {
    @EnvironmentObject var monitorManager: MonitorManager
    @EnvironmentObject var settingsManager: SettingsManager
    @Binding var showingProfileEditor: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            // Current Profile Card
            if let activeProfile = monitorManager.activeProfile {
                ProfileCardView(profile: activeProfile, showingProfileEditor: $showingProfileEditor)
            } else {
                NoProfileView(showingProfileEditor: $showingProfileEditor)
            }
            
            // Recent Events
            RecentEventsView()
            
            Spacer()
        }
        .padding()
    }
}

// MARK: - Profile Card View
struct ProfileCardView: View {
    let profile: MonitorProfile
    @EnvironmentObject var monitorManager: MonitorManager
    @Binding var showingProfileEditor: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Active Profile")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Edit") {
                    showingProfileEditor = true
                }
                .buttonStyle(.borderless)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "folder")
                        .foregroundColor(.blue)
                    Text("Watch: \(profile.watchFolder.lastPathComponent)")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.green)
                    Text("Destination: \(profile.destinationFolder.lastPathComponent)")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.orange)
                    Text("Files: \(profile.fileExtensionsText)")
                        .font(.caption)
                }
            }
            
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

// MARK: - No Profile View
struct NoProfileView: View {
    @EnvironmentObject var monitorManager: MonitorManager
    @Binding var showingProfileEditor: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No Active Profile")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Create a profile to start monitoring files")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Create Profile") {
                showingProfileEditor = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(40)
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

// MARK: - Recent Events View
struct RecentEventsView: View {
    @EnvironmentObject var monitorManager: MonitorManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Activity")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Clear") {
                    monitorManager.clearRecentEvents()
                }
                .buttonStyle(.borderless)
                .font(.caption)
            }
            
            if monitorManager.recentEvents.isEmpty {
                Text("No recent activity")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 4) {
                        ForEach(monitorManager.recentEvents.prefix(10)) { event in
                            EventRowView(event: event)
                        }
                    }
                }
                .frame(maxHeight: 200)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
}

// MARK: - Event Row View
struct EventRowView: View {
    let event: FileSystemEvent
    
    var body: some View {
        HStack {
            Image(systemName: event.eventType.icon)
                .foregroundColor(Color(event.eventType.color))
                .font(.caption)
                .frame(width: 16)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(event.filePath.lastPathComponent)
                    .font(.caption)
                    .lineLimit(1)
                
                Text(event.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(event.eventType.description)
                .font(.caption2)
                .foregroundColor(.red)
                .font(.caption)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(8)
    }
}

#Preview {
    ContentView()
}