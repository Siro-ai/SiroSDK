import SiroSDK
import SwiftUI

@main
struct SiroSDKExampleSwiftUI: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    init() {
        SiroSDK.setup()
        SiroSDK.tokenDelegate = TokenDelegate()
        // Set up log delegate to receive SDK logs (using shared instance)
        SiroSDK.logDelegate = LogDelegate.shared

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
