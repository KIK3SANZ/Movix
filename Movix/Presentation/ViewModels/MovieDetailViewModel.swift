import Foundation

protocol MovieDetailViewModel {
    var movie: Movie? { get }
    var errorMessage: String? { get }
    func loadMovieDetails(movieID: Int, completion: @escaping () -> Void)
    func toggleFavorite(movie: Movie)
}

class MovieDetailViewModelImpl: MovieDetailViewModel {
    private let fetchMovieDetails: FetchMovieDetails
    private(set) var movie: Movie?
    private(set) var errorMessage: String?
    
    init(fetchMovieDetails: FetchMovieDetails) {
        self.fetchMovieDetails = fetchMovieDetails
    }
    
    func loadMovieDetails(movieID: Int, completion: @escaping () -> Void) {
        fetchMovieDetails.execute(movieID: movieID) { [weak self] result in
            switch result {
            case .success(let movie):
                var fetchedMovie = movie
                fetchedMovie.isFavorite = CoreDataHelper.shared.isMovieFavorite(id: movie.id)
                self?.movie = fetchedMovie
                self?.errorMessage = nil
            case .failure(let error):
                self?.movie = nil
                self?.errorMessage = error.localizedDescription
            }
            completion()
        }
    }
    
    func toggleFavorite(movie: Movie) {
        var updatedMovie = movie
        if updatedMovie.isFavorite {
            CoreDataHelper.shared.deleteFavoriteMovie(by: updatedMovie.id)
        } else {
            CoreDataHelper.shared.saveFavoriteMovie(updatedMovie)
        }
        updatedMovie.isFavorite.toggle()
        self.movie = updatedMovie
    }
}
