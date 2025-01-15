import SwiftUI

/// A view that displays two platform icons with a connection line in between,
/// representing the connection status between the platforms.
struct TopPlatformView: View {
    let status: Status
    
    var body: some View {
        HStack(spacing: -2.5) {
            PlatformIcon(isAppwriteIcon: false) {
                Image(systemName: "apple.logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            ConnectionLine(show: status == .success)
                .frame(maxWidth: .infinity)
            
            PlatformIcon(isAppwriteIcon: true) {
                Image("AppwriteIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .padding(8)
        .padding(.horizontal, 40)
    }
}

/// A reusable component that displays a rounded platform icon with customizable content.
struct PlatformIcon<Content: View>: View {
    
    let isAppwriteIcon: Bool
    @ViewBuilder let content: () -> Content
    
    var body: some View {
        ZStack {
            // Card Content
            ZStack {
                // Outer Card
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.32))
                    .frame(width: 100, height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .inset(by: 0.5)
                            .stroke(Color(hex: "#19191C").opacity(0.04), lineWidth: 1)
                    )
                
                
                
                // Inner Card
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: 86.04652, height: 86.04652)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .inset(by: 0.5)
                            .stroke(Color(hex: "#FAFAFB"), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.02), radius: 4, x: 0, y: 6)
                    .shadow(color: .black.opacity(0.02), radius: 6, x: 0, y: 2)
                
                
                // Content
                content()
                    .frame(
                        width: isAppwriteIcon ? 37.86047 : 41.86047,
                        height: isAppwriteIcon ? 37.86047 : 41.86047,
                        alignment: .center
                    )
            }
        }
        .frame(width: 105, height: 105)
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var status: Status = .idle
    
    ZStack {
        EmptyView().addCheckeredBackground()
        
        ScrollView {
            VStack {
                /// Top platform view displaying platform and appwrite logo
                TopPlatformView(
                    status: status
                )
                
                /// Ping appwrite for a connection check
                ConnectionStatusView(
                    logs: .constant([]),
                    status: $status
                )
                
                /// A list of info. cards
                GettingStartedCards()
                
                /// Spacer to add some space for scrolling
                Spacer(minLength: (16 * 3))
            }
        }
        .padding([.bottom], 16)
        .scrollIndicators(.hidden)
        
        /// Bottom sheet view to show logs with a collapsible behavior.
        VStack {
            Spacer()
            CollapsibleBottomSheet(title: "Logs", logs: [])
        }
    }.environmentObject(AppwriteSDK())
}
