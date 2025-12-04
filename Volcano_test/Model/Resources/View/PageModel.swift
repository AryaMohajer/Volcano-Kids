import Foundation

struct PageModel: Identifiable {
    let id: Int
    let title: String
    var isUnlocked: Bool
    var isCompleted: Bool = false
}
