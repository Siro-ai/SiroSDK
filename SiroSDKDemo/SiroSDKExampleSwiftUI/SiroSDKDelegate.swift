import Foundation
import SiroSDK

// MARK: - Token Event Notification

extension Notification.Name {
   static let tokenEvent = Notification.Name("tokenEvent")
}

struct TokenEventNotification {
   let type: String
   let message: String
   let details: String
   
   static func validation(error: NetworkError, context: String) -> TokenEventNotification {
       return TokenEventNotification(
           type: "validation",
           message: "Token validation failed: \(error.localizedDescription)",
           details: "Context: \(context)"
       )
   }
   
   static func request(error: NetworkError, endpoint: String, statusCode: Int?) -> TokenEventNotification {
       return TokenEventNotification(
           type: "request",
           message: "Token request failed: \(error.localizedDescription)",
           details: "Endpoint: \(endpoint), Status: \(statusCode ?? -1)"
       )
   }
}

struct UserDelegate: SiroSDKUserDelegate {
   func didLoginUser(user _: SiroUser) {
       print("didLoginUser called")
   }

   func didLogoutUser(user _: SiroUser) {
       print("didLogoutUser called")
   }

   func didFailedToLoginUser() {
       print("didFailedToLoginUser called")
   }
}

class TokenDelegate: SiroSDKTokenDelegate {
   func didFailTokenValidation(error: NetworkError, context: String) {
       print("🔐 Token validation failed: \(error.localizedDescription)")
       print("📍 Context: \(context)")
       
       // Post notification for UI update
       let notification = TokenEventNotification.validation(error: error, context: context)
       NotificationCenter.default.post(
           name: .tokenEvent,
           object: notification
       )
       
       // Handle token validation failure
       // This could trigger a token refresh flow, show an alert, etc.
   }
   
   func didFailTokenRequest(error: NetworkError, endpoint: String, statusCode: Int?) {
       print("🔐 Token request failed: \(error.localizedDescription)")
       print("📍 Endpoint: \(endpoint)")
       print("📍 Status Code: \(statusCode ?? -1)")
       
       // Post notification for UI update
       let notification = TokenEventNotification.request(error: error, endpoint: endpoint, statusCode: statusCode)
       NotificationCenter.default.post(
           name: .tokenEvent,
           object: notification
       )
       
       // Handle token request failure
       // This could trigger a token refresh flow, logout user, etc.
   }
}

struct RecordingDelegate: SiroSDKRecordingDelegate {
   func didStartRecording(localRecordingId _: String) {
       print("didStartRecording called")
   }

   func didStopRecording(localRecordingId _: String) {
       print("didStopRecording called")
   }

   func didPauseRecording(localRecordingId _: String) {
       print("didPauseRecording called")
   }

   func didDeleteRecording(localRecordingId _: String) {
       print("didDeleteRecording called")
   }

   func didSaveRecording(localRecordingId _: String, recordingLink _: URL) {
       print("didSaveRecording called")
   }

   func didUpdateD2DMode(enabled _: Bool) {
       print("didUpdateD2DMode called")
   }
}

struct PermissionDelegate: SiroSDKPermissionDelegate {
   func didUpdateMicrophonePermissions(enabled _: Bool) {
       print("didUpdateMicrophonePermissions called")
   }
}
