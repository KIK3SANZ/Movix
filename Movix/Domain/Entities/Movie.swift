import Foundation

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
    }
}

