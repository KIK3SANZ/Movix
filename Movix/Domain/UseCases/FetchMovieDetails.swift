import Foundation

protocol FetchMovieDetails {
    func execute(movieID: Int, completion: @escaping (Result<Movie, Error>) -> Void)
}

class FetchMovieDetailsImpl: FetchMovieDetails {
    private let movieRepository: MovieRepository
    
    init(movieRepository: MovieRepository) {
        self.movieRepository = movieRepository
    }
    
    func execute(movieID: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        movieRepository.fetchMovieDetails(movieID: movieID, completion: completion)
    }
}
