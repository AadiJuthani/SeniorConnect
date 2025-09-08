//
//  CallingFeatureView.swift
//  SeniorConnect
//
//  Created by Aadi Juthani on 9/6/25.
//

import Foundation
import CallKit
import AVFoundation
import UIKit

final class CallManager: NSObject, ObservableObject {
    private let callController = CXCallController()
    private let provider: CXProvider

    @Published var isCallActive = false
    @Published var currentCallUUID: UUID?

    static let shared = CallManager()

    override init() {
        let providerConfiguration = CXProviderConfiguration(localizedName: "SeniorConnect")
        providerConfiguration.supportsVideo = false
        providerConfiguration.maximumCallsPerCallGroup = 1
        providerConfiguration.supportedHandleTypes = [.phoneNumber]

        provider = CXProvider(configuration: providerConfiguration)

        super.init()

        provider.setDelegate(self, queue: nil)
        configureAudioSession()
    }

    private func configureAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }

    // Start a call to the given phone number and contact name
    func startCall(to phoneNumber: String, contactName: String) {
        let uuid = UUID()
        let handle = CXHandle(type: .phoneNumber, value: phoneNumber)
        let startCallAction = CXStartCallAction(call: uuid, handle: handle)
        startCallAction.contactIdentifier = contactName

        let transaction = CXTransaction(action: startCallAction)

        // set current call UUID so endCall() can reference it
        self.currentCallUUID = uuid

        callController.request(transaction) { error in
            if let error = error {
                print("Error starting call: \(error.localizedDescription)")
            } else {
                print("Call started successfully to \(phoneNumber)")
            }
        }
    }

    // End the current call (if any)
    func endCall() {
        guard let callUUID = currentCallUUID else {
            print("No active call to end")
            return
        }

        let endCallAction = CXEndCallAction(call: callUUID)
        let transaction = CXTransaction(action: endCallAction)

        callController.request(transaction) { error in
            if let error = error {
                print("Error ending call: \(error.localizedDescription)")
            } else {
                print("Call ended successfully")
            }
        }
    }
}

extension CallManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        print("Provider did reset")
        isCallActive = false
        currentCallUUID = nil
    }

    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        currentCallUUID = action.callUUID
        isCallActive = true

        // report outgoing call connecting/connected
        provider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: Date())
        provider.reportOutgoingCall(with: action.callUUID, connectedAt: Date())

        action.fulfill()
    }

    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        isCallActive = false
        currentCallUUID = nil
        action.fulfill()
    }

    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("Audio session activated")
        // start audio I/O here
    }

    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("Audio session deactivated")
        // stop or pause audio I/O here
    }
}

