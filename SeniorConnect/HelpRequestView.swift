//
//  HelpRequestView.swift
//  SeniorConnect
//
//  Created by Aadi Juthani on 9/3/25.
//

import SwiftUI

struct HelpRequestView: View {
    @State private var problemDescription = ""
    @State private var urgencyLevel = "Low"
    @State private var contactMethod = "Message"
    @State private var voiceMessageURL: URL? = nil
    
    var body: some View {
        NavigationView{
            Form{
                Text("Request Help")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom)
                
                Section("What problem are you having?") {
                    TextEditor(text: $problemDescription)
                        .font(.title2)
                        .frame(minHeight: 120)
                        .padding(8)
                        .cornerRadius(8)
                        .background(Color.gray.opacity(0.1))
                }
                .font(.title3)
                    Section("How urgent is this?"){
                        Picker("Urgency", selection: $urgencyLevel) {
                            Text("Low - I can wait")
                                .font(.title2)
                                .tag("Low")
                            Text("Medium - Soon please")
                                .font(.title2)
                                .tag("Medium")
                            Text("High - Need help now!")
                                .font(.title2)
                                .tag("High")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .font(.title2)
                    }
                    .font(.title3)
                
                Section("Or record a voice message"){
                    VoiceRecordingButton()
                        .font(.title2).padding(.vertical)
                }
                .font(.title3)
                
                Section("How should we contact you?"){
                    Picker("Contact Method", selection: $contactMethod){
                        Label("Send me messages", systemImage: "message.fill")
                            .font(.title2)
                            .tag("Message")
                        Label("Call me directly", systemImage: "phone.fill")
                            .font(.title2)
                            .tag("Call")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .font(.title2)
                }
                .font(.title3)
                
                // TODO: Submit the help request
                Section {
                    Button(action: {
                        print("Help request submitted:")
                        print("Problem: \(problemDescription)")
                        print("Urgency: \(urgencyLevel)")
                        print("Contact: \(contactMethod)")
                        
                        if let voiceURL = voiceMessageURL{
                            print("Voice message: \(voiceURL.lastPathComponent)")
                        } else{
                            print("No voice message attached")
                        }
                    }){
                        Text("Send Help Request")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
            }
            .navigationTitle("Get Help")
        }
    }
}

