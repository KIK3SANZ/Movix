import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var favoriteToggleButton: UIBarButtonItem!
    var viewModel: MovieDetailViewModel!
    var movieID: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMovieDetails()
    }
    
    func setupUI(){
        favoriteToggleButton.target = self
        favoriteToggleButton.action = #selector(toggleFavorite)
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        guard let movie = viewModel.movie else { return }
        let isFavorite = CoreDataHelper.shared.isMovieFavorite(id: movie.id)
        favoriteToggleButton.image = isFavorite ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
    }
    
    @objc private func toggleFavorite() {
        guard let movie = viewModel.movie else { return }
        viewModel.toggleFavorite(movie: movie)
        updateFavoriteButton()
    }
    
    private func loadMovieDetails() {
        guard let movieID = movieID else { return }
        viewModel.loadMovieDetails(movieID: movieID) { [weak self] in
            DispatchQueue.main.async {
                if let errorMessage = self?.viewModel.errorMessage {
                    print("ERROR-MESSAGE: ", errorMessage)
                } else {
                    self?.updateFavoriteButton()
                }
            }
        }
    }
    
}
