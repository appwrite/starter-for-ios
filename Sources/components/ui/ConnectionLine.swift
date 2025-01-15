import SwiftUI

/// A view that animates a connection line with a checkmark in the middle. The left and right
/// lines expand and contract based on the `show` state, with a tick appearing after a delay.
struct ConnectionLine: View {
    let show: Bool
    
    @State private var showTick: Bool = false
    @State private var expandLines: Bool = false
    
    var body: some View {
        HStack {
            // Left Line
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#FE9567").opacity(0.15),
                    Color(hex: "#F02E65"),
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: expandLines ? nil : 0, height: 1)
            .animation(.easeInOut(duration: show ? 1.0 : 0).delay(showTick ? 0.2 : 0), value: expandLines)
            
            // Tick
            ZStack {
                // TODO: get the checkmark and circle sizes checked.
                Circle()
                    .strokeBorder(Color(hex: "#F02E65").opacity(0.32), lineWidth: 1.8)
                    .background(Circle().fill(Color(hex: "#F02E65").opacity(0.08)))
                    .frame(width: 30, height: 30)
                
                Image(systemName: "checkmark")
                    .foregroundColor(Color(hex: "#FD366E"))
                    .font(.system(size: 15, weight: .bold))
            }
            .opacity(showTick ? 1 : 0)
            .animation(.easeIn(duration: show ? 0.5 : 0), value: showTick)
            
            // Right Line
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#F02E65"),
                    Color(hex: "#FE9567").opacity(0.15),
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .frame(width: expandLines ? nil : 0, height: 1)
            .animation(.easeInOut(duration: show ? 1.0 : 0).delay(showTick ? 0.2 : 0), value: expandLines)
        }
        .frame(height: 40)
        .onChange(of: show) { newValue in
            if newValue {
                showTick = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    expandLines = true
                }
            } else {
                expandLines = false
                showTick = false
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    @Previewable @State var showConnection = false
    
    ZStack {
        VStack {
            Button("Toggle Connection Line") {
                showConnection.toggle()
            }
            .padding()
            
            ConnectionLine(show: showConnection).padding()
        }
    }
}
