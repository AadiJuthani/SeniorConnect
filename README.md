# SeniorConnect  
A SwiftUI app that helps seniors request assistance and connect with volunteers through calls, messages, or voice notes.  
**Built solo using SwiftUI.**

---

## Screens & Demo
<div style="display: flex; justify-content: space-between;">
  <img src="SeniorHome View.png" width="30%"/>
  <img src="VolunteerHome View.png" width="30%"/>
</div>

**Quick walkthrough:**  
Open the app → Create a profile as a senior or volunteer → Tap **I Need Help** → Submit a request or start a call → Volunteers see and respond.

---

## Features
- Senior home screen with profile, volunteer availability, and quick help buttons.  
- Submit detailed help requests with text, urgency, screenshots, and voice notes.  
- One-tap emergency help button with haptic feedback.  
- Voice recording and playback for attaching voice messages.  
- Call volunteers directly via CallKit integration.  
- Volunteer dashboard with requests, calls, and impact stats.  
- Edit profile and persistent user data management.

---

## Skills
- Implemented **MVVM architecture** with `ObservableObject` managers for users, volunteers, and calls.  
- Integrated **CallKit** for initiating and managing phone calls inside the app.  
- Built **custom SwiftUI components** (e.g., `LargeAccessibilityButton`, `EmergencyHelpButton`) optimized for seniors.  
- Developed **voice recording and playback** with `AVAudioRecorder` and `AVAudioPlayer`.  
- Added **speech-to-text transcription** with `SFSpeechRecognizer`.  
- Implemented **local notifications** using `UNUserNotificationCenter`.  
- Created **persistence layer** with `UserDefaults` and JSON encoding/decoding.  
- Used **PhotosPicker** for screenshot/image upload.  
- Built **form flows** with validation, segmented pickers, and SwiftUI navigation.  
- Applied **SwiftUI animations and state management** for responsive UI.

---

## Tech Stack
- **Language:** Swift 5.x
- **Frameworks:** SwiftUI, Combine, AVFoundation, CallKit, PhotosUI, UserNotifications, Speech  
- **Xcode:** 15
- **iOS Target:** iOS 16+  
- **Swift Packages:** None (all native frameworks)

---

## Setup (Run in 2 Minutes)
1. Clone the repo:  
   ```bash
   git clone https://github.com/yourusername/SeniorConnect.git
   cd SeniorConnect
   ```
2. Open SeniorConnect.xcodeproj (or .xcworkspace) in Xcode 15+.
3. Select an iOS 16+ simulator or a physical device.
4. Press Run ▶︎.

---

## Future Improvements 
- Add push notifications for real-time alerts.  
- Improve request history and status tracking.  
- Expand accessibility options (voice over prompts, larger UI scaling).  

---

## Credits & Inspiration 
- Apple Developer documentation and SwiftUI tutorials.  
- SF Symbols for icons.

---

## License & Contact
All rights reserved.  

**Author:** Aadi Juthani  
📧 [aadi.juthani@gatech.edu]  
🔗 [LinkedIn Profile](https://www.linkedin.com/in/aadi-juthani)  
