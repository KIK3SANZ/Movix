import Foundation

protocol MovieListViewModel {
    var popularMovies: [Movie] { get }
    var errorMessage: String? { get }
    func loadPopularMovies(category: MovieCategory,completion: @escaping () -> Void)
    func loadMoreMovies(category: MovieCategory,completion: @escaping () -> Void)
    func sortMovies(by option: Int)
}

class MovieListViewModelImpl: MovieListViewModel {
    private let fetchPopularMovies: FetchPopularMovies
    private(set) var popularMovies: [Movie] = []
    private(set) var errorMessage: String?
    
    private var currentPage = 1
    private var isLoading = false
    private var hasMorePages = true
    
    init(fetchPopularMovies: FetchPopularMovies) {
        self.fetchPopularMovies = fetchPopularMovies
    }
    
    func loadPopularMovies(category: MovieCategory,completion: @escaping () -> Void) {
        currentPage = 1
        hasMorePages = true
        popularMovies.removeAll()
        fetchMovies(category: category, completion: completion)
    }
    
    func loadMoreMovies(category: MovieCategory,completion: @escaping () -> Void) {
        guard !isLoading && hasMorePages else { return }
        currentPage += 1
        fetchMovies(category: category, completion: completion)
    }
    
    private func fetchMovies(category: MovieCategory, completion: @escaping () -> Void) {
        isLoading = true
        fetchPopularMovies.execute(page: currentPage, category: category) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let movies):
                if movies.isEmpty {
                    self.hasMorePages = false
                } else {
                    let moviesMap = movies.map { movie in
                        var updatedMovie = movie
                        updatedMovie.isFavorite = CoreDataHelper.shared.isMovieFavorite(id: movie.id)
                        return updatedMovie
                    }
                    self.popularMovies.append(contentsOf: moviesMap)//movies
                }
                self.errorMessage = nil
            case .failure(let error):
                self.errorMessage = "error_fetch_movies".localized("\(error.localizedDescription)")
            }
            completion()
        }
    }
    
    func sortMovies(by option: Int) {
        switch option {
            case 0:
                popularMovies.sort { $0.title < $1.title }
            case 1:
                popularMovies.sort { $0.releaseDate < $1.releaseDate }
            case 2:
                popularMovies.sort { $0.popularity > $1.popularity }
            default:
                break
        }
    }
}
