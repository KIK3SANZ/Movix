import Foundation

class DependencyInjector {
    static let shared = DependencyInjector()

    private init() {}
    
    func makeMovieListViewModel() -> MovieListViewModel {
        let movieAPI = MovieAPI()
        let movieRepository = MovieRepository(movieAPI: movieAPI)
        let fetchPopularMovies = FetchPopularMoviesImpl(movieRepository: movieRepository)
        return MovieListViewModelImpl(fetchPopularMovies: fetchPopularMovies)
    }
    
    func makeMovieDetailViewModel() -> MovieDetailViewModel {
        let movieAPI = MovieAPI()
        let movieRepository = MovieRepository(movieAPI: movieAPI)
        let fetchMovieDetails = FetchMovieDetailsImpl(movieRepository: movieRepository)
        return MovieDetailViewModelImpl(fetchMovieDetails: fetchMovieDetails)
    }
}
