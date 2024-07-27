import Foundation

protocol FetchPopularMovies {
    func execute(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void)
}

class FetchPopularMoviesImpl: FetchPopularMovies {
    private let movieRepository: MovieRepositoryProtocol
    
    init(movieRepository: MovieRepositoryProtocol) {
        self.movieRepository = movieRepository
    }
    
    func execute(page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        movieRepository.fetchPopularMovies(page: page, completion: completion)
    }
}
