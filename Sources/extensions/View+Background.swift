import SwiftUI

/// A view modifier extension to easily apply a checkered background to any view.
extension View {
    func addCheckeredBackground() -> some View {
        self.modifier(CheckeredModifier())
    }
}
