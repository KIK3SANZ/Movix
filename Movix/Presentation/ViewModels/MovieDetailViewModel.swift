import Foundation

protocol MovieDetailViewModel {
    var movie: Movie? { get }
    var errorMessage: String? { get }
    func loadMovieDetails(movieID: Int, completion: @escaping () -> Void)
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
                self?.movie = movie
                self?.errorMessage = nil
            case .failure(let error):
                self?.movie = nil
                self?.errorMessage = error.localizedDescription
            }
            completion()
        }
    }
}
