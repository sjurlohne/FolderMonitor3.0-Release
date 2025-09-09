import SwiftUI

struct ProfilesView: View {
    @EnvironmentObject var monitorManager: MonitorManager
    @State private var showingProfileEditor = false
    @State private var editingProfile: MonitorProfile?
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text("Monitor Profiles")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                Button(action: { showingProfileEditor = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                        Text("New Profile")
                    
}
                
}
                .buttonStyle(.borderedProminent)
            
}
            .padding(.horizontal)
            
            // Profiles List
            if monitorManager.profiles.isEmpty {
                EmptyProfilesView()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(monitorManager.profiles) { profile in
                            ProfileRowView(
                                profile: profile,
                                isActive: monitorManager.activeProfile?.id == profile.id,
                                onEdit: { editingProfile = profile },
                                onDelete: { monitorManager.deleteProfile(profile) },
                                onSetActive: { monitorManager.setActiveProfile(profile) 
}
                            )
                        
}
                    
}
                    .padding(.horizontal)
                
}
            
}
            
            Spacer()
        
}
        .padding(.vertical)
        .sheet(isPresented: $showingProfileEditor) {
            ProfileEditorView(profile: editingProfile)
        
}
        .onChange(of: editingProfile) { newValue in
            showingProfileEditor = newValue != nil
        
}
    
}

}

// MARK: - Empty Profiles View
struct EmptyProfilesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("No Profiles Created")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Create your first profile to start monitoring files")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        
}
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(40)
    
}

}

// MARK: - Profile Row View
struct ProfileRowView: View {
    let profile: MonitorProfile
    let isActive: Bool
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onSetActive: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Active Indicator
            Circle()
                .fill(isActive ? Color.green : Color.clear)
                .frame(width: 12, height: 12)
                .overlay(
                    Circle()
                        .stroke(Color.green, lineWidth: 2)
                )
            
            // Profile Info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(profile.displayName)
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    if isActive {
                        Text("ACTIVE")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .cornerRadius(4)
                    
}
                
}
                
                HStack {
                    Image(systemName: "folder")
                        .foregroundColor(.blue)
                        .font(.caption)
                    Text(profile.watchFolder.lastPathComponent)
                        .font(.caption)
                        .foregroundColor(.secondary)
                
}
                
                HStack {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.green)
                        .font(.caption)
                    Text(profile.destinationFolder.lastPathComponent)
                        .font(.caption)
                        .foregroundColor(.secondary)
                
}
                
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.orange)
                        .font(.caption)
                    Text(profile.fileExtensionsText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                
}
            
}
            
            Spacer()
            
            // Action Buttons
            HStack(spacing: 8) {
                if !isActive {
                    Button("Set Active") {
                        onSetActive()
                    
}
                    .buttonStyle(.bordered)
                    .font(.caption)
                
}
                
                Button("Edit") {
                    onEdit()
                
}
                .buttonStyle(.borderless)
                .font(.caption)
                
                Button("Delete") {
                    onDelete()
                
}
                .buttonStyle(.borderless)
                .font(.caption)
                .foregroundColor(.red)
            
}
        
}
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isActive ? Color.green : Color.clear, lineWidth: 2)
        )
    
}

}

// MARK: - Profile Editor View
struct ProfileEditorView: View {
    @EnvironmentObject var monitorManager: MonitorManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var watchFolder: URL?
    @State private var destinationFolder: URL?
    @State private var fileExtensions: [String] = []
    @State private var newExtension: String = ""
    @FocusState private var isNameFieldFocused: Bool
    @FocusState private var isExtensionFieldFocused: Bool
    
    let profile: MonitorProfile?
    
    init(profile: MonitorProfile? = nil) {
        self.profile = profile
    
}
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text(profile == nil ? "New Profile" : "Edit Profile")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button("Cancel") {
                        dismiss()
                    
}
                    .buttonStyle(.bordered)
                    
                    Button("Save") {
                        saveProfile()
                    
}
                    .buttonStyle(.borderedProminent)
                    .disabled(!isValidProfile)
                
}
            
}
            .padding()
            .background(Color(NSColor.controlBackgroundColor))
            
            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Profile Information Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Profile Information")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        TextField("Profile Name", text: $name)
                            .textFieldStyle(.roundedBorder)
                            .frame(height: 32)
                            .focused($isNameFieldFocused)
                    
}
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    
                    // Folders Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Folders")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Watch Folder")
                                    .frame(width: 120, alignment: .leading)
                                Spacer()
                                Button(watchFolder?.lastPathComponent ?? "Select Folder") {
                                    selectWatchFolder()
                                
}
                                .buttonStyle(.bordered)
                            
}
                            
                            HStack {
                                Text("Destination Folder")
                                    .frame(width: 120, alignment: .leading)
                                Spacer()
                                Button(destinationFolder?.lastPathComponent ?? "Select Folder") {
                                    selectDestinationFolder()
                                
}
                                .buttonStyle(.bordered)
                            
}
                        
}
                    
}
                    .padding()
                    .background(Color(NSColor.controlBackgroundColor))
                    .cornerRadius(8)
                    
                    // File Types Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("File Types")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                TextField("Add file extension", text: $newExtension)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(height: 32)
                                    .focused($isExtensionFieldFocused)
                                    .onSubmit {
                                        addFileExtension()
                                    
}
                                
                                Button("Add") {
                                    addFileExtension()
                                
}
                                .buttonStyle(.bordered)
                                .disabled(newExtension.isEmpty)
                            
}
                            
                            if !fileExtensions.isEmpty {
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                                    ForEach(fileExtensions, id: \.self) { fileExtension in
                                        HStack {
                                            Text(".\(fileExtension)")
                                                .font(.caption)
                                            Button("×") {
                                                removeFileExtension(fileExtension)
                                            
}
                                            .buttonStyle(.borderless)
                                            .foregroundColor(.red)
                                        
}
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                    
}
                                
}
                            } else {
                                Text("All file types will be monitored")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            
}
                        
}
                    
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
        .frame(minWidth: 600, maxWidth: .infinity, minHeight: 500, maxHeight: .infinity)
        .onAppear {
            loadProfile()
            // Auto-focus the name field when creating a new profile
            if profile == nil {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isNameFieldFocused = true
                
}
            
}
        
}
    
}
    
    private var isValidProfile: Bool {
        !name.isEmpty && watchFolder != nil && destinationFolder != nil
    
}
    
    private func loadProfile() {
        if let profile = profile {
            name = profile.name
            watchFolder = profile.watchFolder
            destinationFolder = profile.destinationFolder
            fileExtensions = profile.fileExtensions
        
}
    
}
    
    private func selectWatchFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK {
            watchFolder = panel.url
        
}
    
}
    
    private func selectDestinationFolder() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        if panel.runModal() == .OK {
            destinationFolder = panel.url
        
}
    
}
    
    private func addFileExtension() {
        let trimmed = newExtension.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !trimmed.isEmpty && !fileExtensions.contains(trimmed) {
            fileExtensions.append(trimmed)
            newExtension = ""
        
}
    
}
    
    private func removeFileExtension(_ fileExtension: String) {
        fileExtensions.removeAll { $0 == fileExtension 
}
    
}
    
    private func saveProfile() {
        guard let watchFolder = watchFolder,
              let destinationFolder = destinationFolder else { return 
}
        
        let newProfile = MonitorProfile(
            name: name,
            watchFolder: watchFolder,
            destinationFolder: destinationFolder,
            fileExtensions: fileExtensions
        )
        
        if let existingProfile = profile {
            var updatedProfile = newProfile
            updatedProfile = existingProfile // Preserve ID and dates
            updatedProfile.name = name
            updatedProfile.watchFolder = watchFolder
            updatedProfile.destinationFolder = destinationFolder
            updatedProfile.fileExtensions = fileExtensions
            monitorManager.updateProfile(updatedProfile)
        } else {
            monitorManager.addProfile(newProfile)
            // Automatically set new profile as active
            monitorManager.setActiveProfile(newProfile)
        
}
        
        dismiss()
    
}

}

#Preview {
    ProfilesView()

}
