import SwiftUI

/// Main content view for the application, responsible for rendering the UI components
/// and managing the state for connection to the Appwrite server, logs and the connection status.
struct ContentView: View {
    /// An array of log entries to store connection logs.
    @State private var logs: [Log] = []
    
    /// The current status of the connection (idle, loading, success, error, etc.).
    @State private var status: Status = .idle
    
    @State private var isSheetOpen: Bool = false
    
    var body: some View {
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
                        logs: $logs,
                        status: $status
                    )
                    
                    /// A list of info. cards
                    GettingStartedCards()
                    
                    /// Spacer to add some space for scrolling
                    Spacer(minLength: (16 * 3))
                }
                /// smoothly moves the getting started cards
                .animation(.default, value: status)
            }
            .padding([.bottom], 16)
            .scrollIndicators(.hidden)
            
            /// Bottom sheet view to show logs with a collapsible behavior.
            VStack {
                CollapsibleBottomSheet(title: "Logs", logs: logs)
            }
        }
    }
}

#Preview {
    ContentView().environmentObject(AppwriteSDK())
}
