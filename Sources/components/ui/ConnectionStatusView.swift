import SwiftUI

/// A view that displays the current connection status and allows the user to send a ping
/// to verify the connection. It shows different messages based on the connection status.
struct ConnectionStatusView: View {
    
    @Binding var logs: [Log]
    @Binding var status: Status
    @EnvironmentObject var appwrite: AppwriteSDK
    
    var body: some View {
        VStack(spacing: 8) {
            // Main Status Message
            Group {
                if status == .loading {
                    HStack(alignment: .center, spacing: 16) {
                        ProgressView().scaleEffect(1)
                        Text("Waiting for connection...")
                            .font(.title3)
                    }
                } else if status == .success {
                    Text("Congratulations!").font(.title2)
                } else {
                    Text("Check connection").font(.title2)
                }
            }
            .foregroundColor(Color(hex: "#2D2D31"))
            
            // Substatus Message
            Group {
                if status == .success {
                    Text("You connected your app successfully.")
                } else if status == .idle || status == .error {
                    Text("Send a ping to verify the connection")
                }
            }
            .font(.callout)
            .foregroundColor(Color(hex: "#56565C"))
            
            // Ping Button
            Text("Send a ping")
                .font(.callout)
                .fontWeight(.medium)
                .padding(12)
                .foregroundColor(.white)
                .background(Color(hex: "#FD366E"))
                .cornerRadius(12)
                .padding(.top, 24)
                .contentShape(Rectangle())
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    sendPing()
                }
                .opacity(status == .loading ? 0 : 1)
        }
        .padding(16)
        .animation(.default, value: status)
        .multilineTextAlignment(.center)
    }
    
    func sendPing() {
        status = .loading
        Task {
            let result = await appwrite.ping()
            let statusCode = Int(result.status) ?? 0
            
            // Delay to smooth out the transition
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                logs.append(result)
                status = statusCode >= 200 && statusCode < 400 ? .success : .error
            }
        }
    }
}

enum Status: String {
    case idle, loading, success, error
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var logs: [Log] = []
    @Previewable @State var status: Status = .idle
    let appwrite = AppwriteSDK()
    
    ConnectionStatusView(
        logs: $logs,
        status: $status
    ).environmentObject(appwrite)
}
