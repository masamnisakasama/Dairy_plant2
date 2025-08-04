import SwiftUI

struct ToolTipView: View {
    
    var text: String
    
    var body: some View {
        Text(text)
            .foregroundStyle(Color("dark-green"))
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 25)
                    .strokeBorder(Color("off-white2"), lineWidth: 5)
                    .background(
                        RoundedRectangle(cornerRadius: 25).fill( Color("off-white2")))
            }
    }
}

#Preview {
    ToolTipView(text: "This is a test")
}
