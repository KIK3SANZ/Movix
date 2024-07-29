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
    var isFavorite: Bool = false
    var status: String?
    var voteAverage: Double?
    var genres:[Genre]?
    var spokenLanguages:[Language]?
    var runtime: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath
        case originalLanguage
        case voteCount
        case releaseDate
        case popularity
        case status
        case voteAverage
        case genres
        case spokenLanguages
        case runtime
    }
}

