# SiroSDK for iOS

SiroSDK allows your users to create Siro recordings without navigating out of your app.

## Requirements

- Requires iOS 15+
- works with SPM and Cocoapods


## Installation

### Add SiroSDK to SPM or with Cocoapods in your Podfile:

```
dependencies: [
    .package(url: "https://github.com/Siro-ai/SiroSDK.git", from: "2.0.0")
]
```

```
pod 'SiroSDK'
```

### Add the following keys to the Info.plist:

- Privacy - Location When In Use Usage Description
- Privacy - Microphone Usage Description
  ![Screenshot](ios/docs/info-plist.png)

### Ensure background audio recording is enabled

- Signing & Capabilities -> Background Modes -> check Audio, AirPlay, and Picture in Picture

![Screenshot](ios/docs/background_modes.png)

### Call `setup()` and `handleAppWillTerminate()` within app entry point

Example App Entry Point (e.g., SiroSDKExampleApp.swift)

```swift
import SiroSDK
import SwiftUI

@main
struct SiroSDKExampleSwiftUI: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        SiroSDK.setup()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillTerminate(_: UIApplication) {
        // Stop the AVAudioRecorder when the app is about to terminate
        SiroSDK.handleAppWillTerminate()
    }
}

```

## Data Storage

The SiroSDK stores data in two main locations:

1. **Metadata Storage**
   - All metadata is stored in `siro/LocalDataStore.json` in the user's documents directory
   - This includes:
     - User information
     - Conversation types
     - Recording metadata
     - Chunk metadata
     - Last updated timestamp

2. **Audio Chunks**
   - Audio chunks are stored in subdirectories under `siro/` named with their local recording ID
   - Each recording's chunks are organized as:
     ```
     siro/
     ├── LocalDataStore.json
     └── {localRecordingId}/
         ├── {localChunkId1}.{extension}
         ├── {localChunkId2}.{extension}
         └── ...
     ```
   - Chunks are associated with their recording through the `recordingId` field in the metadata

## Roadmap
### Enhancements
- Better integration documenation 
- Finer control over syncing/uploading
- Better error handling and concrete error types
- Userspacing files & not deleting files on logout
- Observable download state for recordings and chunks
- Better telemetry
- Switching local .json file to DB


### Known Bugs
* (In-Progress) Conversation types have a bug right now, preffered conversationtype is automatically used right for now if a user token is set.
* (In-Progess) Server side id's are not being saved correctly on device despite being returned
* Latest recordings sometimes do not upload right away, work around right now is to manually sync or make another recording
* Comlpleted recordings' elapsedDuration being saved as 0
  
