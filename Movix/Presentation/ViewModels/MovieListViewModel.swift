import Foundation

protocol MovieListViewModel {
    var popularMovies: [Movie] { get }
    var errorMessage: String? { get }
    func loadPopularMovies(completion: @escaping () -> Void)
}

class MovieListViewModelImpl: MovieListViewModel {
    private let fetchPopularMovies: FetchPopularMovies
    private(set) var popularMovies: [Movie] = []
    private(set) var errorMessage: String?
    
    init(fetchPopularMovies: FetchPopularMovies) {
        self.fetchPopularMovies = fetchPopularMovies
    }
    
    func loadPopularMovies(completion: @escaping () -> Void) {
        fetchPopularMovies.execute { [weak self] result in
            switch result {
            case .success(let movies):
                self?.popularMovies = movies
                self?.errorMessage = nil
            case .failure(let error):
                self?.popularMovies = []
                self?.errorMessage = "Error fetching movies: \(error.localizedDescription)"
            }
            completion()
        }
    }
}
