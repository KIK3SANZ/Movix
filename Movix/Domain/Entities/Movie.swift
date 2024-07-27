import Foundation

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let originalLanguage: String
    let voteCount:Int
    let releaseDate:String
    let popularity: Double

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath
        case originalLanguage
        case voteCount
        case releaseDate
        case popularity
    }
}

