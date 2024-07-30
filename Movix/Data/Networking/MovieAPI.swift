import Foundation

class MovieAPI{
    public var apiClient: APIClient
    private var baseURL: String
    
    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
        // Obtener la URL base de configuración
        let urlTMDB = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
        self.baseURL = "\(urlTMDB)/3"
    }
    
    // Función para obtener las películas populares
    func fetchPopularMovies(page: Int,completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/discover/movie")!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "include_adult", value: "false"),
          URLQueryItem(name: "include_video", value: "false"),
          URLQueryItem(name: "language", value: "en-US"),
          URLQueryItem(name: "page", value: "\(page)"),
          URLQueryItem(name: "sort_by", value: "popularity.desc"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems
        apiClient.performRequest(url: components.url ?? url) { (result: Result<MovieResponse, Error>) in
            switch result {
                case .success(let response):
                completion(.success(response.results ?? []))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    // Función para obtener el detalle de la pelicula
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/movie/\(movieId)")!
        apiClient.performRequest(url: url) { (result: Result<Movie, Error>) in
            switch result {
                case .success(let response):
                completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    // Estructura para la respuesta de las películas populares
    struct MovieResponse: Codable {
        let results: [Movie]
    }
}
