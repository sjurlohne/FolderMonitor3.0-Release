import SwiftUI

// MARK: - Custom Button Style for Menu Bar
struct MenuBarButtonStyle: ButtonStyle {
    @State private var isHovered = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.vertical, 2)
            .padding(.horizontal, 8)
            .background(
                Rectangle()
                    .fill(isHovered ? Color.blue.opacity(0.3) : Color.clear)
            )
            .onHover { hovering in
                withAnimation(.easeInOut(duration: 0.1)) {
                    isHovered = hovering
                }
            }
    }
}

struct MenuBarView: View {
    @EnvironmentObject var monitorManager: MonitorManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Control Actions
            VStack(spacing: 0) {
                Button(action: {
                    Task {
                        if monitorManager.isMonitoring {
                            monitorManager.stopMonitoring()
                        } else {
                            await monitorManager.startMonitoring()
                        }
                    }
                }) {
                    Text(monitorManager.isMonitoring ? "Stop Monitoring" : "Start Monitoring")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(MenuBarButtonStyle())
                .disabled(monitorManager.activeProfile == nil)
                
                Button("Open Main Window") {
                    // Focus existing window or create new one if none exists
                    if let existingWindow = NSApplication.shared.windows.first(where: { $0.identifier?.rawValue == "main" }) {
                        existingWindow.makeKeyAndOrderFront(nil)
                        NSApp.activate(ignoringOtherApps: true)
                    } else {
                        // This will be handled by the WindowGroup
                    }
                }
                .buttonStyle(MenuBarButtonStyle())
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Divider()
            
            // Recent Files
            if !monitorManager.recentEvents.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Recent Files")
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 12)
                    
                    ScrollView {
                        LazyVStack(spacing: 2) {
                            ForEach(monitorManager.recentEvents.prefix(5)) { event in
                                HStack {
                                    Image(systemName: event.eventType.icon)
                                        .foregroundColor(Color(event.eventType.color))
                                        .font(.caption2)
                                        .frame(width: 12)
                                    
                                    Text(event.filePath.lastPathComponent)
                                        .font(.caption2)
                                        .lineLimit(1)
                                    
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color.clear)
                                )
                                .onHover { hovering in
                                    // Simple hover effect for recent files
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 100)
                }
                
                Divider()
            }
            
            // Quit
            Button("Quit Folder Monitor") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(MenuBarButtonStyle())
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.bottom, 8)
        }
        .frame(width: 250)
        .background(Color(NSColor.controlBackgroundColor))
    }
}

#Preview {
    MenuBarView()
}