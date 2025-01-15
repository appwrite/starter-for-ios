import SwiftUI

/// The main entry point for the application, initializing the Appwrite SDK
/// and setting up the main view with the environment object.
@main
struct AppwriteApp: App {
    let appwrite = AppwriteSDK()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)  /// Set light mode for the app
                .environmentObject(appwrite)   /// Provide the Appwrite SDK to the environment
        }
    }
}
