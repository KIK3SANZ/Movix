extension Movie {
    var fullPosterURL: String{
        return APIConstants.imageBaseURL + posterPath
    }
    
    var concatenatedGenreNames: String {
        return genres?.map { $0.name }.joined(separator: ", ") ?? ""
    }
    
    var concatenatedLanguageNames: String {
        return spokenLanguages?.map { $0.name }.joined(separator: ", ") ?? ""
    }
}
