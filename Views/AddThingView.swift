

import SwiftUI
import SwiftData

struct AddThingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @State private var thingTitle = ""
    
    var body: some View {
        
        VStack (alignment: .leading, spacing: 10) {
            TextField("何を成し遂げたい？", text: $thingTitle)
                .textFieldStyle(.roundedBorder)
                .font(.largeTitle)
            
            Button("追加") {
                // swiftDataに追加する
                addThing()
                thingTitle = ""
                
                dismiss()
            }
            .font(.largeTitle)
            .frame(maxWidth: .infinity, alignment: .center)
            .buttonStyle(.borderedProminent)
            .disabled(thingTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
        
    }
    
    func addThing() {
        
        // テキストを消去
        let cleanedTitle = thingTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // データベースに加える
        context.insert(Thing(title: cleanedTitle))
        
        try? context.save()
    }
}

#Preview {
    AddThingView()
}
