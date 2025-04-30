import SiroSDK
import SwiftUI

let interactionData = InteractionData(id: "someId", userId: "someUserID", leadId: "leadId", stage: Stage(id: "stageId", name: "Won", color: "#fff", icon: "https://icon.jpg", won: true, interacted: true), coordinates: nil, address: Address(street: "some street", city: "Some City", state: "NY", zip: "11201"), note: "I got the sale!", metadata: [:], contacts: [], leadDateCreated: Date())

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

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

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

                    Button {
                        showingActionSheet = true
                    } label: {
                        Text("More Actions")
                    }
                    .buttonStyle(ActionButtonStyle())
                    .sheet(isPresented: $showingActionSheet) {
                        MoreActionsView(isPresented: $showingActionSheet)
                    }

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
//                        .padding(.horizontal)

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
//                                .padding(.horizontal)
                            }
//                            .padding(.horizontal)
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
        recordings = await DataManager.shared.fetchRecordings()
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

struct MoreActionsView: View {
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 12) {
            Text("Available Actions")
                .font(.headline)
                .padding(.vertical)

            Button(action: {
                SiroSDK.sendEvent("start", interactionData: interactionData)
            }) {
                Text("Send start event")
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
            }
            .foregroundColor(.white)
            .background(Color.siroYellow)
            .cornerRadius(.infinity)

            Button(action: {
                SiroSDK.sendEvent("stop", interactionData: interactionData)
            }) {
                Text("Send stop event")
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
            }
            .foregroundColor(.white)
            .background(Color.siroYellow)
            .cornerRadius(.infinity)

            Button("Send openPinMenu Event") {
                SiroSDK.sendEvent("openPinMenu", interactionData: interactionData)
            }
            .buttonStyle(ActionButtonStyle())

            Button("Send openLead Event") {
                SiroSDK.sendEvent("openLead", interactionData: nil)
            }
            .buttonStyle(ActionButtonStyle())

            Button("Send openDataGridPanel Event") {
                SiroSDK.sendEvent("openDataGridPanel", interactionData: interactionData)
            }
            .buttonStyle(ActionButtonStyle())

            Button("Send dispositioned Event") {
                SiroSDK.sendEvent("dispositioned", interactionData: nil)
            }
            .buttonStyle(ActionButtonStyle())

            Button("Send pinClosed Event") {
                SiroSDK.sendEvent("pinClosed", interactionData: interactionData)
            }
            .buttonStyle(ActionButtonStyle())

            Button("Send closeDataGridPanel event") {
                SiroSDK.sendEvent("closeDataGridPanel", interactionData: interactionData)
            }
            .buttonStyle(ActionButtonStyle())

            Button("Process D2D mode action") {
                SiroSDK.sendEvent("leadOpened", interactionData: interactionData)
            }
            .buttonStyle(ActionButtonStyle())

            Button(action: {
                Task {
                    do {
                        let success = try await RandomFilesProvider.testUpload()
                    } catch {
                        print("error test uploading random files")
                    }
                }
            }) {
                Text("Test upload")
                    .frame(maxWidth: .infinity)
                    .frame(height: 36)
            }
            .foregroundColor(.white)
            .background(Color.siroYellow)
            .cornerRadius(.infinity)

            Button("Dismiss") {
                isPresented = false
            }
            .buttonStyle(CancelButtonStyle())

            Spacer()
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
