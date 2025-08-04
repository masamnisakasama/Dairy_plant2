import Foundation
import SwiftData

@Model
class Thing: Identifiable {
    
    var id: String = UUID().uuidString
    var title: String = ""
    var lastUpdated: Date = Date()
    var isHidden: Bool = false
    var isCompleted: Bool = false
    var createdDate: Date = Date()
    
    init(title: String) {
        self.title = title
    }
}
