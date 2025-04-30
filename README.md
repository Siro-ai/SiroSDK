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
