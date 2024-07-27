import UIKit

class MovieDetailViewController: UIViewController {
    
    var viewModel: MovieDetailViewModel!
    var movieID: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovieDetails()
    }
    
    private func loadMovieDetails() {
        guard let movieID = movieID else { return }
        
        viewModel.loadMovieDetails(movieID: movieID) { [weak self] in
            DispatchQueue.main.async {
                if let errorMessage = self?.viewModel.errorMessage {
                    print("ERROR-MESSAGE: ", errorMessage)
                } else {
                    print("RESULT-MOVIE: ", self?.viewModel.movie)
                }
            }
        }
    }
    
}
