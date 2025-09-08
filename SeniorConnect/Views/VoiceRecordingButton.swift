//
//  VoiceRecordingButton.swift
//  SeniorConnect
//
//  Created by Aadi Juthani on 9/5/25.
//

import SwiftUI

struct VoiceRecordingButton: View {
    @StateObject private var recordingService = VoiceRecordingService()
    
    private var formattedDuration: String {
        let minutes = Int(recordingService.recordingDuration) / 60
        let seconds = Int(recordingService.recordingDuration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Recording Status Display
            if recordingService.isRecording {
                VStack(spacing: 8) {
                    Text("Recording...")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.red)
                    
                    Text(formattedDuration)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
            }
            
            // Main Recording Button
            Button(action: {
                if recordingService.isRecording {
                    recordingService.stopRecording()
                } else {
                    recordingService.startRecording()
                }
            }) {
                ZStack {
                    Circle()
                        .fill(recordingService.isRecording ? Color.red : Color.blue)
                        .frame(width: 100, height: 100)
                        .scaleEffect(recordingService.isRecording ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: recordingService.isRecording)
                    
                    Image(systemName: recordingService.isRecording ? "stop.fill" : "mic.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }
            
            Button(action: {
                recordingService.deleteRecording()
            }) {
                HStack {
                    Image(systemName: "trash.fill")
                        .font(.title3)
                    
                    Text("Delete")
                        .font(.title3)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.red)
                .cornerRadius(25)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(15)
        .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: 2)
        
        // Instruction Text
        Text(recordingService.isRecording ? "Tap to Stop Recording" : "Tap to Start Recording")
            .font(.title3)
            .fontWeight(.medium)
            .multilineTextAlignment(.center)
            .foregroundColor(.secondary)
        
        // Playback Controls (if recording exists)
        if recordingService.hasRecording && !recordingService.isRecording {
            VStack(spacing: 15) {
                Text("Your Voice Message (\(formattedDuration))")
                    .font(.headline)
                    .padding(.top, 10)
                
                HStack(spacing: 20) {
                    Button(action: {
                        if recordingService.isPlaying {
                            recordingService.stopPlaying()
                        } else {
                            recordingService.playRecording()
                        }
                    }) {
                        HStack {
                            Image(systemName: recordingService.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                                .font(.title2)
                            
                            Text(recordingService.isPlaying ? "Stop" : "Play")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.green)
                        .cornerRadius(25)
                    }
                    
                    Button(action: {
                        recordingService.deleteRecording()
                    }) {
                        HStack {
                            Image(systemName: "trash.fill")
                                .font(.title3)
                            
                            Text("Delete")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(Color.red)
                        .cornerRadius(25)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
    }
}
