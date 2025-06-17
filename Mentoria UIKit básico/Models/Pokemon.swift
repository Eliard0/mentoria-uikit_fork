import Foundation

struct Pokemon: Identifiable {
    let id: Int
    let name: String
    let number: Int
    let imageUrl: String
    let detailApiUrl: URL?
}
