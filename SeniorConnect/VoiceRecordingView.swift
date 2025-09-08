//
//  VoiceRecordingView.swift
//  SeniorConnect
//
//  Created by Aadi Juthani on 9/5/25.
//

import SwiftUI

struct VoiceRecordingView: View {
    @StateObject private var voiceRecorder = VoiceRecorder()

    var body: some View {
        VStack(spacing: 30) {
            Text("Help Request")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)

            Text("Tap the microphone to describe your problem")
                .font(.title2)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)

            // Voice recording button
            Button(action: {
                if voiceRecorder.isRecording {
                    voiceRecorder.stopRecording()
                } else {
                    voiceRecorder.startRecording()
                }
            }) {
                Image(systemName: voiceRecorder.isRecording ? "mic.fill" : "mic")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .frame(width: 120, height: 120)
                    .background(voiceRecorder.isRecording ? Color.red : Color.blue)
                    .clipShape(Circle())
                    .scaleEffect(voiceRecorder.isRecording ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 0.3), value: voiceRecorder.isRecording)
            }

            // Status text
            Text(voiceRecorder.isRecording ? "Recording... Speak now" : "Tap to start recording")
                .font(.headline)
                .foregroundColor(voiceRecorder.isRecording ? .red : .primary)

            // Recognized text display
            if !voiceRecorder.recognizedText.isEmpty {
                ScrollView {
                    Text(voiceRecorder.recognizedText)
                        .font(.body)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                }
                .frame(maxHeight: 200)
            }

            Spacer()
        }
        .padding()
    }
}

