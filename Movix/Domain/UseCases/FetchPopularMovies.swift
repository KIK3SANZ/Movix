import Foundation

protocol FetchPopularMovies {
    func execute(completion: @escaping (Result<[Movie], Error>) -> Void)
}

class FetchPopularMoviesImpl: FetchPopularMovies {
    private let movieRepository: MovieRepositoryProtocol
    
    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }
    
    func execute(completion: @escaping (Result<[Movie], Error>) -> Void) {
        movieRepository.fetchPopularMovies(completion: completion)
    }
}
