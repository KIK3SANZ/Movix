import Foundation

class MovieAPI{
    private let apiClient: APIClient
    private var baseURL: String
    
    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
        let urlTMDB = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
        self.baseURL = "\(urlTMDB)/3"
    }
    
    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/movie/popular")!
        apiClient.performRequest(url: url) { (result: Result<MovieResponse, Error>) in
            switch result {
                case .success(let response):
                    completion(.success(response.results))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    
    func fetchMovieDetails(movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/movie/\(movieId)")!
        apiClient.performRequest(url: url) { (result: Result<Movie, Error>) in
            print("FETCH-MOVIE-API: ", result)
            switch result {
                case .success(let response):
                completion(.success(response))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    struct MovieResponse: Codable {
        let results: [Movie]
    }
}
