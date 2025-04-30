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
