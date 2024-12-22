import SwiftUI

/// A view that displays two platform icons with a connection line in between,
/// representing the connection status between the platforms.
struct TopPlatformView: View {
    let status: Status
    
    var body: some View {
        HStack(spacing: 0) {
            PlatformIcon {
                Image(systemName: "apple.logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            ConnectionLine(show: status == .success)
                .frame(maxWidth: .infinity)
            
            PlatformIcon {
                Image("AppwriteIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .padding(8)
        .padding(.horizontal, 16)
    }
}

/// A reusable component that displays a rounded platform icon with customizable content.
struct PlatformIcon<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let outerCardSize = min(geometry.size.width, geometry.size.height)
                
                // Card Content
                ZStack {                    
                    // Outer Card
                    RoundedRectangle(cornerRadius: outerCardSize * 0.25)
                        .foregroundColor(Color(hex: "#FAFAFD"))
                        .shadow(color: Color.black.opacity(0.04), radius: outerCardSize * 0.1, x: 0, y: outerCardSize * 0.1)
                        .overlay(
                            RoundedRectangle(cornerRadius: outerCardSize * 0.25)
                                .stroke(Color(red: 238 / 255, green: 238 / 255, blue: 241 / 255), lineWidth: 1)
                        )

                    // Inner Card
                    RoundedRectangle(cornerRadius: outerCardSize * 0.2)
                        .foregroundColor(Color(hex: "#FFFFFF"))
                        .shadow(color: Color.black.opacity(0.03), radius: outerCardSize * 0.12, x: 0, y: outerCardSize * 0.02)
                        .frame(width: outerCardSize * 0.875, height: outerCardSize * 0.875)

                    // Content
                    content()
                        .frame(
                            width: outerCardSize * 0.525,
                            height: outerCardSize * 0.525
                        )
                }
            }
            .aspectRatio(1, contentMode: .fit)
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
                    status: .constant(.idle)
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
