import SwiftUI

struct EmergencyHelpButton: View {
    let action: () -> Void
    @State private var isPressed = false
    @State private var helpRequested = false
    @State private var isLoading = false

    var body: some View {
        Button(action: {
            if !helpRequested {
                // Add haptic feedback for seniors
                let impact = UIImpactFeedbackGenerator(style: .heavy)
                impact.impactOccurred()

                isLoading = true

                // Simulate request processing
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isLoading = false
                    helpRequested = true
                }
            }
            action()
        }) {
            VStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                } else {
                    Image(systemName: helpRequested ? "checkmark.circle.fill" : "phone.circle.fill")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                }

                Text(helpRequested ? "HELP ON THE WAY" : (isLoading ? "REQUESTING HELP..." : "GET HELP NOW"))
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                if !helpRequested && !isLoading {
                    Text("Tap for immediate assistance")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                } else if helpRequested {
                    Text("A volunteer will contact you soon")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.vertical, 40)
            .padding(.horizontal, 30)
            .frame(maxWidth: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: helpRequested ? [Color.green, Color.green.opacity(0.8)] : [Color.red, Color.red.opacity(0.8)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .cornerRadius(20)
            .shadow(
                color: (helpRequested ? Color.green : Color.red).opacity(0.4),
                radius: isPressed ? 5 : 10,
                x: 0,
                y: isPressed ? 2 : 5
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.3), value: helpRequested)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity) { pressing in
            if !helpRequested {
                isPressed = pressing
            }
        } perform: {}
        .disabled(helpRequested)
        .accessibilityLabel(helpRequested ? "Help requested" : "Emergency help button")
        .accessibilityHint(helpRequested ? "Help is on the way" : "Tap to request immediate help from a volunteer")
    }
}
