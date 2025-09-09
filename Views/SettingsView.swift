import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Settings")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button("Done") {
                    dismiss()
                
}
                .buttonStyle(.borderedProminent)
            
}
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Notifications Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Notifications")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Toggle("Enable Notifications", isOn: $settingsManager.enableNotifications)
                            .help("Show notifications when files are moved")
                        
                        Toggle("Show in Menu Bar", isOn: $settingsManager.showInMenuBar)
                            .help("Display Folder Monitor in the menu bar")
                    
}
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    
                    // Monitoring Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Monitoring")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Toggle("Auto-start on Launch", isOn: $settingsManager.autoStartOnLaunch)
                            .help("Automatically start monitoring when the app launches")
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Check Interval")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 16) {
                                Slider(value: $settingsManager.checkInterval, in: 0.5...5.0, step: 0.5)
                                    .accentColor(.blue)
                                Text("\(settingsManager.checkInterval, specifier: "%.1f")s")
                                    .font(.body)
                                    .frame(width: 50)
                                    .foregroundColor(.secondary)
                            
}
                        
}
                        .help("How often to check for new files (lower = more responsive, higher = less CPU usage)")
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Max Recent Events")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            HStack(spacing: 16) {
                                Slider(value: Binding(
                                    get: { Double(settingsManager.maxRecentEvents) },
                                    set: { settingsManager.maxRecentEvents = Int($0) 
}
                                ), in: 10...100, step: 10)
                                    .accentColor(.blue)
                                Text("\(settingsManager.maxRecentEvents)")
                                    .font(.body)
                                    .frame(width: 50)
                                    .foregroundColor(.secondary)
                            
}
                        
}
                        .help("Maximum number of recent events to keep in memory")
                    
}
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    
                    // File Handling Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("File Handling")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Toggle("Enable File Conflict Resolution", isOn: $settingsManager.enableFileConflictResolution)
                            .help("Automatically rename files when conflicts occur (e.g., file (1).pdf)")
                    
}
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    
                    // Advanced Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Advanced")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Button("Reset to Defaults") {
                            settingsManager.resetToDefaults()
                        
}
                        .buttonStyle(.bordered)
                        .foregroundColor(.red)
                    
}
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                
}
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
}
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        
}
        .frame(minWidth: 600, maxWidth: .infinity, minHeight: 700, maxHeight: .infinity)
    
}

}

#Preview {
    SettingsView()

}
