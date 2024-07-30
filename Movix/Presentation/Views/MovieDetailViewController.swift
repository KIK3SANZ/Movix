import UIKit
import SDWebImage

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var favoriteToggleButton: UIBarButtonItem!
    @IBOutlet weak var imvPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    @IBOutlet weak var lblVoteAverage: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblPopularity: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var lblLanguages: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    var viewModel: MovieDetailViewModel!
    var movieID: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadMovieDetails()
    }
    
    func setupUI(){
        title = "view_details".localized
        imvPoster.layer.cornerRadius = 10
        favoriteToggleButton.target = self
        favoriteToggleButton.action = #selector(toggleFavorite)
        updateFavoriteButton()
    }
    
    private func updateFavoriteButton() {
        guard let movie = viewModel.movie else { return }
        let isFavorite = CoreDataHelper.shared.isMovieFavorite(id: movie.id)
        favoriteToggleButton.image = isFavorite ? UIImage(systemName: Constants.heartFill) : UIImage(systemName: Constants.heart)
    }
    
    private func updateDetailUI(){
        guard let movie = viewModel.movie else { return }
        lblTitle.text = movie.title
        lblOverview.text = movie.overview
        lblReleaseDate.text = movie.releaseDate
        let voteAveragePercentage = Int((movie.voteAverage ?? 0.0) * 10)
        lblVoteAverage.text = "\(voteAveragePercentage)%"
        lblStatus.text = movie.status ?? ""
        lblPopularity.text = "\(movie.popularity)"
        lblGenres.text = movie.concatenatedGenreNames
        lblLanguages.text = movie.concatenatedLanguageNames
        lblTime.text = movie.runtime?.formattedRuntime() ?? ""

        if let imageUrl = URL(string: movie.fullPosterURL) {
            imvPoster.sd_setImage(with: imageUrl, completed: nil)
        }else{
            imvPoster.image = nil
        }
    }
    
    @objc private func toggleFavorite() {
        guard let movie = viewModel.movie else { return }
        viewModel.toggleFavorite(movie: movie)
        updateFavoriteButton()
    }
    
    private func loadMovieDetails() {
        guard let movieID = movieID else { return }
        self.showSpinner(true)
        viewModel.loadMovieDetails(movieID: movieID) { [weak self] in
            self?.showSpinner(false)
            DispatchQueue.main.async {
                if let errorMessage = self?.viewModel.errorMessage {
                    self?.showAlert(withMessage: errorMessage)
                } else {
                    self?.updateFavoriteButton()
                    self?.updateDetailUI()
                }
            }
        }
    }
    
}
