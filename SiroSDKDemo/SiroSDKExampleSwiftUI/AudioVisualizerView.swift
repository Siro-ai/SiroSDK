import Combine
import SiroSDK
import SwiftUI

struct AudioVisualizerView: View {
    @StateObject private var viewModel = AudioVisualizerViewModel()

    var body: some View {
        VStack {
            Text("Audio Levels")
                .font(.headline)

            // Audio visualization
            HStack(alignment: .center, spacing: 2) {
                ForEach(Array(viewModel.audioLevels.suffix(15).enumerated()), id: \.offset) { _, level in
                    let scaledHeight = (level - 0.05) * (95 / 0.95) // Scale from 0.05-1.0 to 5-100
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.blue)
                        .frame(width: 5, height: max(5, min(100, CGFloat(scaledHeight))))
                }
                ForEach(Array(viewModel.audioLevels.suffix(15).enumerated().reversed()), id: \.offset) { _, level in
                    let scaledHeight = (level - 0.05) * (95 / 0.95) // Scale from 0.05-1.0 to 5-100
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.blue)
                        .frame(width: 5, height: max(5, min(100, CGFloat(scaledHeight))))
                }
            }
            .frame(height: 100, alignment: .center)
            .animation(.easeOut(duration: 0.1), value: viewModel.audioLevels)

            // Recording controls
            HStack(spacing: 20) {
                Button(action: {
                    SiroSDK.startRecording()
                }) {
                    Image(systemName: "record.circle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                }

                Button(action: {
                    SiroSDK.pauseRecording()
                }) {
                    Image(systemName: "pause.circle")
                        .font(.largeTitle)
                }

                Button(action: {
                    SiroSDK.stopRecording()
                    viewModel.audioLevels.removeAll()
                }) {
                    Image(systemName: "stop.circle")
                        .font(.largeTitle)
                }
            }

            Text("Recording Time: \(formattedTime(SiroSDK.recordingTime))")
                .padding()

            if let recordingId = SiroSDK.getCurrentRecordingLocalId() {
                Text("Local Recording ID: \(recordingId)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom)
            }
        }
        .padding()
    }

    private func formattedTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

class AudioVisualizerViewModel: ObservableObject, SiroSDKAudioLevelDelegate, SiroSDKRecordingDelegate {
    @Published var audioLevels: [Float] = []
    @Published var noiseFloor: Float = 0.05 // Default noise floor
    private var baselineSamples: [Float] = []
    private var isCalibrating = false
    private var maxObservedLevel: Float = 0.1 // Start with a small value
    private var recentLevels: [Float] = [] // Store recent levels for dynamic range

    init() {
        // Register as delegate when initialized
        SiroSDK.audioLevelDelegate = self
        SiroSDK.recordingDelegate = self
        // Calibrate noise floor after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.calibrateNoiseFloor()
        }
    }

    // Calibrate the noise floor by sampling ambient noise
    func calibrateNoiseFloor() {
        isCalibrating = true
        baselineSamples = []

        // Collect samples for 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if !self.baselineSamples.isEmpty {
                // Calculate the average plus a small buffer
                let average = self.baselineSamples.reduce(0, +) / Float(self.baselineSamples.count)
                self.noiseFloor = min(0.3, average + 0.05) // Cap at 0.3 to avoid too high a floor
//                print("Calibrated noise floor: \(self.noiseFloor)")
            }
            self.isCalibrating = false
        }
    }

    // SiroSDKAudioLevelDelegate implementation
    func didStopRecording(recordingId _: String) {
        recentLevels = []
        audioLevels = []
    }

    func didUpdateAudioLevels(_ samples: [Float]) {
        DispatchQueue.main.async {
            if self.isCalibrating {
                // During calibration, collect samples
                self.baselineSamples.append(contentsOf: samples)
            } else {
                // Keep track of recent levels for dynamic range calculation
                self.recentLevels.append(contentsOf: samples)
                if self.recentLevels.count > 100 { // Keep last 100 samples
                    self.recentLevels.removeFirst(self.recentLevels.count - 100)
                }

                // Update max observed level (with decay)
                self.maxObservedLevel *= 0.99 // Slowly decay max level
                if let currentMax = samples.max(), currentMax > self.maxObservedLevel {
                    self.maxObservedLevel = currentMax
                }

                // Calculate dynamic range
                let effectiveMax = max(self.maxObservedLevel, 0.2) // Ensure some minimum range
                let effectiveMin = self.noiseFloor
                let range = effectiveMax - effectiveMin

                // Apply extreme processing to samples
                let processedSamples = samples.map { level in
                    // First subtract noise floor
                    let adjusted = max(0, level - effectiveMin)

                    // Then normalize to dynamic range
                    let normalized = min(1.0, adjusted / range)

                    // Apply exponential curve for more dramatic effect
                    return pow(normalized, 3)
                }

                self.audioLevels = processedSamples
            }
        }
    }

    deinit {
        if SiroSDK.audioLevelDelegate === self {
            SiroSDK.audioLevelDelegate = nil
        }
    }
}
