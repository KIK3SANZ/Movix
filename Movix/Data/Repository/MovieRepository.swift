import Foundation

protocol MovieRepositoryProtocol {
    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
    func fetchMovieDetails(movieID: Int, completion: @escaping (Result<Movie, Error>) -> Void)
}

class MovieRepository: MovieRepositoryProtocol {
    private let movieAPI: MovieAPI
    
    init(movieAPI: MovieAPI) {
        self.movieAPI = movieAPI
    }
    
    func fetchPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        movieAPI.fetchPopularMovies { result in
            switch result {
            case .success(let movies):
                completion(.success(movies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieDetails(movieID: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        movieAPI.fetchMovieDetails(movieId: movieID) { result in
            print("FETCH: ", result)
            completion(result)
        }
    }
}
