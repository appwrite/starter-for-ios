import SwiftUI

/// A view that contains a list of informational cards displayed vertically.
struct GettingStartedCards: View {
    var body: some View {
        VStack(spacing: 16) {
            // First Card: Edit your app
            GeneralInfoCard(
                title: "Edit your app",
                link: nil,
                subtitle: {
                    codeViewContent
                }
            )
            
            // Second Card: Head to Appwrite Cloud
            GeneralInfoCard(
                title: "Head to Appwrite Cloud",
                link: "https://cloud.appwrite.io",
                subtitle: {
                    Text("Start managing your project from the Appwrite console")
                }
            )
            
            // Third Card: Explore docs
            GeneralInfoCard(
                title: "Explore docs",
                link: "https://appwrite.io/docs",
                subtitle: {
                    Text("Discover the full power of Appwrite by diving into our documentation")
                }
            )
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var codeViewContent: some View {
        let baseFont = Font.body
        var attributedString = AttributedString("Edit ")
        attributedString.font = baseFont
        
        var codeSnippet = AttributedString(" ContentView.swift ")
        codeSnippet.font = .subheadline.monospaced()
        codeSnippet.backgroundColor = Color(hex: "#EDEDF0")
        codeSnippet.inlinePresentationIntent = .code
        
        var continuation = AttributedString(" to get started with building your app")
        continuation.font = baseFont
        
        return Text(attributedString + codeSnippet + continuation)
    }
    
}

/// A reusable card component that displays a title and a subtitle with optional link functionality.
/// If a link is provided, the card becomes clickable and opens the destination URL.
struct GeneralInfoCard<Subtitle: View>: View {
    let title: String
    let link: String?
    @ViewBuilder let subtitle: Subtitle
    
    var body: some View {
        Group {
            if let link = link, let url = URL(string: link) {
                Link(destination: url) {
                    cardContent
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                cardContent
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "#EDEDF0"), lineWidth: 1))
    }
    
    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#2D2D31"))
                
                if link != nil {
                    Spacer()
                    Image(systemName: "arrow.right")
                        .foregroundColor(Color(hex: "#D8D8DB"))
                }
            }
            
            subtitle
                .font(.subheadline)
                .foregroundColor(Color(hex: "#56565C"))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ZStack {
        Color.clear.addCheckeredBackground()
        
        VStack {
            Spacer()
            GettingStartedCards()
        }
    }
}
