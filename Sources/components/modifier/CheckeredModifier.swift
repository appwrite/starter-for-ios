import SwiftUI

/// A custom view modifier that adds a checkered background pattern with a gradient effect
/// and a radial gradient overlay. The checkered pattern consists of gray vertical and horizontal lines
/// drawn over the view's background. The modifier also includes a mask and a radial gradient
/// to create a layered visual effect.
struct CheckeredModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        ZStack {
            Color(hex: "#FAFAFB")
            
            GeometryReader { geometry in
                ZStack {
                    Canvas { context, size in
                        let lineThickness: CGFloat = 0.75
                        let gridSize = min(geometry.size.width * 0.1, 64)
                        
                        // Draw vertical lines
                        for x in stride(from: 0, through: size.width, by: gridSize) {
                            let path = Path(CGRect(x: x, y: 0, width: lineThickness, height: size.height))
                            context.fill(path, with: .color(Color.gray.opacity(0.3)))
                        }
                        
                        // Draw horizontal lines
                        for y in stride(from: 0, through: size.height, by: gridSize) {
                            let path = Path(CGRect(x: 0, y: y, width: size.width, height: lineThickness))
                            context.fill(path, with: .color(Color.gray.opacity(0.3)))
                        }
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .mask(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.black.opacity(0),
                                Color.black.opacity(0.8),
                                Color.black.opacity(0.6),
                                Color.black.opacity(0.4),
                                Color.black.opacity(0.2),
                                Color.black.opacity(0.1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    
                    // Radial Gradient
                    RadialGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.black.opacity(0), location: 0.0),
                            .init(color: Color.black.opacity(0.8), location: 0.2),
                            .init(color: Color.black.opacity(0.4), location: 0.5),
                            .init(color: Color.clear, location: 1.0)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: max(geometry.size.width, geometry.size.height) * 2
                    )
                    .blendMode(.destinationOut)
                    
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.black.opacity(0), location: 0.0),
                            .init(color: Color.black.opacity(0.3), location: 0.7),
                            .init(color: Color.black.opacity(0.6), location: 1.0)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .blendMode(.destinationOut)
                }
                .compositingGroup()
            }
        }.ignoresSafeArea()
        
        content
    }
}

#Preview {
    VStack {
        
    }
    .addCheckeredBackground()
}
