# SiroSDK for iOS

SiroSDK allows your users to create Siro recordings without navigating out of your app.

## Overview
Siro SDK allows you to display a recording button. It also exposes an API to control recordings as a byproduct of existing interactions in your app, making the recording experience automatic to the end user.


## Requirements
 - Requires iOS 15+
 - Compatible with UIKit and SwiftUI

## Swift UI Installation

### 1. Add SiroSDK to Cocoapods in your Podfile:

```
pod 'SiroSDK'
```

### 2. Add the following keys to the Info.plist:
- Privacy - Location When In Use Usage Description
- Privacy - Microphone Usage Description
![Screenshot](ios/docs/info-plist.png)

### 3. Ensure background audio recording is enabled
- Signing & Capabilities -> Background Modes -> check Audio, AirPlay, and Picture in Picture

![Screenshot](ios/docs/background_modes.png)

### 4. Call `setup()` and `handleAppWillTerminate()` within app entry point

Example App Entry Point (e.g., SiroKitExampleApp.swift)
```swift
import SiroKit
import SwiftUI

@main
struct SiroKitExampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
        // For staging, use SiroKit.setup(environment: .staging)
        SiroKit.setup()  // <--- Add This
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// Add the App Delegate if it doesn't already exist
class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationWillTerminate(_ application: UIApplication) {
        SiroKit.handleAppWillTerminate() // <--- insert this to stop recordings in progress when the app is about to terminate
    }
}

```

### 5. Insert SiroKit into your root View in a ZStack

Root View (e.g., ContentView.swift)

```swift
import SiroKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
          
          /** Your UI Here */

          /** Initialize the SiroSDKUI. 
            * SiroKitUI parameters allow you to customize appearance of the recording button.
            * buttonRadius: CGFloat - radius of the recording button
            * buttonBottomPadding: CGFloat - space below the recording button
            * buttonTrailingPadding: CGFloat - space to the right of the recording button
          
          */
          SiroKitUI(buttonRadius: CGFloat, buttonBottomPadding: CGFloat, buttonTrailingPadding: CGFloat)
        }
    }
}
```

## UIKit Installation

### 1. Add SiroSDK to Cocoapods in your Podfile:

```
pod 'SiroSDK'
```

### 2. Add the following keys to the Info.plist:
- Privacy - Location When In Use Usage Description
- Privacy - Microphone Usage Description
![Screenshot](ios/docs/info-plist.png)

### 3. Ensure background audio recording is enabled
- Signing & Capabilities -> Background Modes -> check Audio, AirPlay, and Picture in Picture

![Screenshot](ios/docs/background_modes.png)

### 4. Add  `handleAppWillTerminate()` within `ApplicationWillTerminate` in the AppDelegate.swift

```swift
import UIKit
import SiroKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  /** Your AppDelegate code */

  func applicationWillTerminate(_ application: UIApplication) {
      SiroKit.handleAppWillTerminate() // <--- insert this to stop recordings in progress when the app is about to terminate
  }
}
```
### 5. Initialize SiroKit in the root view controller, and add SiroKitUI as a child view, and update protocol to HostingParentController

```swift
import UIKit
import SwiftUI
import SiroKit

class ViewController: HostingParentController { // <-- Change from UIViewController to HostingParentController

    /** Initialize the siroSDKUI. 
        SiroKitUI parameters allow you to customize appearance of the recording button.
        buttonRadius: CGFloat - radius of the recording button
        buttonBottomPadding: CGFloat - space below the recording button
        buttonTrailingPadding: CGFloat - space to the right of the recording button
     */
    let siroSDKUI = UIHostingController(rootView: SiroKitUI(buttonRadius: CGFloat, buttonBottomPadding: CGFloat, buttonTrailingPadding: CGFloat))

    override func viewDidLoad() {
        super.viewDidLoad()
        // For staging, use SiroKit.setup(environment: .staging)
        SiroKit.setup()
        siroSDKUI.view.frame = view.bounds
        siroSDKUI.view.translatesAutoresizingMaskIntoConstraints = false
        siroSDKUI.view.backgroundColor = .clear
        addChild(siroSDKUI)
        view.addSubview(siroSDKUI.view)
        NSLayoutConstraint.activate([
            siroSDKUI.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            siroSDKUI.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            siroSDKUI.view.topAnchor.constraint(equalTo: view.topAnchor),
            siroSDKUI.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        siroSDKUI.didMove(toParent: self)


        /** Your App UI goes here */

        view.bringSubviewToFront(siroSDKUI.view)
    }
}

```

## Usage & Customization

### Change record button position & size



### Trigger recording
```swift
SiroKit.startRecording() // Start recording
SiroKit.stopRecording() // Stop recording
```

### Read recording status
`SiroKit.recordingStatus: SKRecorderState` is an enum with the current recording status. It can be one of the following:
```swift
public enum SKRecorderState {
    case paused
    case stopped
    case recording
    case notStarted
}
```

### Send events
Allows Siro SDK to respond to custom events, making recording automatic to the end user.

Siro SDK must be initialized, otherwise events will be ignored. Check `SiroKit.initialized` for the current initialization status.

```swift
SiroKit.sendEvent(_ eventName: String)
```
