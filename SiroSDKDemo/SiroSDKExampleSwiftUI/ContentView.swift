import SiroSDK
import SwiftUI


struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 36)
            .background(Color.siroYellow)
            .foregroundColor(.white)
            .cornerRadius(.infinity)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct CancelButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .frame(height: 36)
            .background(Color.gray.opacity(0.2))
            .foregroundColor(.primary)
            .cornerRadius(.infinity)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct ContentView: View {
    @State private var fetchResult: String = ""
    @State private var authToken: String = ""
    @State private var showingActionSheet = false
    @State private var showingFileStructure = false
    @State private var showingJsonFile = false
    @State private var recordings: [SiroRecording] = []
    @State private var isLoadingRecordings = false
    @State private var recordingTitle: String = ""
    @State private var isPrivate: Bool = false
    @State private var isAutomaticSplitEnabled: Bool = false
    @State private var isRecording: Bool = false
    @State private var crmObjectId: String = ""
    @State private var crmObjectType: String = ""
    @State private var crmTenantId: String = ""
    @State private var crmPlatform: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {

                    TextField("Initialize Auth Token", text: $authToken)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom)

                    Button(action: {
                        Task {
                            do {
                                try await SiroSDK.initialize(withSiroToken: authToken)
                                DispatchQueue.main.async {
                                    fetchResult = "✅ Successfully initialized!"
                                }
                            } catch {
                                DispatchQueue.main.async {
                                    fetchResult = "❌ Initialization failed: \(error.localizedDescription)"
                                }
                            }
                        }
                    }) {
                        Text("Set Auth Token")
                    }
                    .buttonStyle(ActionButtonStyle())

                    Button(action: {
                        SiroSDK.logout()
                        authToken = ""
                        fetchResult = ""
                    }) {
                        Text("Logout")
                    }
                    .buttonStyle(ActionButtonStyle())

                    Button(action: {
                        Task {
                            await fetchUser()
                        }
                    }) {
                        Text("Fetch User")
                    }
                    .buttonStyle(ActionButtonStyle())

                    Button(action: {
                        Task {
                            await fetchConversationTypes()
                        }
                    }) {
                        Text("Fetch Convo Types")
                    }
                    .buttonStyle(ActionButtonStyle())

                    Button(action: {
                        showingFileStructure = true
                    }) {
                        Text("Show File Structure")
                    }
                    .buttonStyle(ActionButtonStyle())
                    .sheet(isPresented: $showingFileStructure) {
                        FileStructureView()
                    }

                    Button(action: {
                        showingJsonFile = true
                    }) {
                        Text("Show JSON File")
                    }
                    .buttonStyle(ActionButtonStyle())
                    .sheet(isPresented: $showingJsonFile) {
                        JsonFileView()
                    }

                    if !fetchResult.isEmpty {
                        Text(fetchResult)
                            .fixedSize(horizontal: false, vertical: true)
                            .lineLimit(100)
                            .foregroundColor(.black)
                            .padding(.top, 8)
                    }
                    // Recording Metadata Section
                    VStack(alignment: .leading, spacing: 12) {
                        DisclosureGroup("Recording Settings") {
                            VStack(alignment: .leading, spacing: 12) {
                                TextField("Recording Title", text: $recordingTitle)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Toggle("Private Recording", isOn: $isPrivate)
                                
                                Toggle("Automatic Split", isOn: $isAutomaticSplitEnabled)

                                Text("CRM Settings")
                                    .font(.subheadline)
                                    .padding(.top, 8)
                                
                                TextField("CRM Object ID", text: $crmObjectId)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                TextField("CRM Object Type", text: $crmObjectType)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                TextField("CRM Tenant ID", text: $crmTenantId)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                TextField("CRM Platform", text: $crmPlatform)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                
                                Button(action: {
                                    SiroSDK.recordingTitle = recordingTitle
                                    SiroSDK.isPrivateRecording = isPrivate
                                    SiroSDK.automaticSplitEnabled = isAutomaticSplitEnabled
                                    SiroSDK.crmObjectId = crmObjectId.isEmpty ? nil : crmObjectId
                                    SiroSDK.crmObjectType = crmObjectType.isEmpty ? nil : crmObjectType
                                    SiroSDK.crmTenantId = crmTenantId.isEmpty ? nil : crmTenantId
                                    SiroSDK.crmPlatform = crmPlatform.isEmpty ? nil : crmPlatform
                                    SiroSDK.startRecording()
                                }) {
                                    Text("Start Recording with above settings")
                                }
                                .buttonStyle(ActionButtonStyle())
                                .disabled(isRecording)
                            }
                            .padding(.top, 8)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.bottom)
                    .onChange(of: SiroSDK.recordingStatus) { newStatus in
                        isRecording = newStatus == .recording
                    }

                    AudioVisualizerView()

                    // Recordings List Section
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Local Recordings")
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                Task {
                                    await refreshRecordings()
                                }
                            }) {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.siroYellow)
                            }
                            .disabled(isLoadingRecordings)
                        }

                        if isLoadingRecordings {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else if recordings.isEmpty {
                            Text("No recordings found")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            ForEach(recordings, id: \.localId) { recording in
                                RecordingView(recording: recording)
                            }
                        }
                    }
                    .padding(.top)
                }
                .padding()
            }
            .navigationTitle("Siro SDK Demo")
            .task {
                await refreshRecordings()
            }
        }
    }

    private func refreshRecordings() async {
        isLoadingRecordings = true
        do {
            recordings = try await SiroSDK.getLocalRecordings()
        } catch {
            print("Error getting local recrodings")
        }
        isLoadingRecordings = false
    }

    func fetchUser() async {
        do {
            let user = try await SiroSDK.fetchUser()
            print("Fetched user: \(user)")
        } catch {
            print("Error fetching user: \(error)")
        }
    }

    func fetchConversationTypes() async {
        do {
            let types = try await SiroSDK.fetchConversationTypes()
            print("Fetched conversation types: \(types)")
        } catch {
            print("Error fetching conversation types: \(error)")
        }
    }
}

struct RecordingView:View{
    var recording:SiroRecording
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()


    var body: some View {
        VStack {
            NavigationLink(destination: ChunksView(recording: recording)) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("ID: \(recording.id ?? "Local Only")")
                            .font(.subheadline)
                        if recording.isCurrentRecording == true {
                            Text("• Recording")
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    Text("Title: \(recording.title ?? "[not set]")")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("ConvoType: \(recording.conversationType ?? "[not set]")")
                        .font(.caption)
                        .foregroundColor(.gray)

                    Text("Private: \(recording.isPrivate ? "Yes" : "No")")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Auto Split: \(recording.isAutomaticSplitEnabled ? "Enabled" : "Disabled")")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    if let crmObjectId = recording.crmObjectId {
                        Text("CRM Object ID: \(crmObjectId)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    if let crmObjectType = recording.crmObjectType {
                        Text("CRM Object Type: \(crmObjectType)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    if let crmTenantId = recording.crmTenantId {
                        Text("CRM Tenant ID: \(crmTenantId)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    if let crmPlatform = recording.crmPlatform {
                        Text("CRM Platform: \(crmPlatform)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Text("Local ID: \(recording.localId)")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("Created: \(dateFormatter.string(from: recording.dateCreated))")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("ElapsedTime:\(recording.elapsedTime)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 4)
                .padding(.horizontal)
                .background(Color(.systemBackground))
                .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())

            if recording.isCurrentRecording == true {
                Button(action: {
                    Task {
                        _ = await SiroSDK.loadResumableRecording(recordingId: recording.id ?? recording.localId)
                    }
                }) {
                    Text("Resume Recording")
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.siroYellow)
                        .cornerRadius(8)
                }
                .padding(.top, 4)
            }
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
