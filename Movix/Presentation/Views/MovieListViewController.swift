import UIKit

class MovieListViewController: UIViewController {
    var viewModel: MovieListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMovies()
    }
    
    private func loadMovies() {
        viewModel.loadPopularMovies {[weak self] in
            DispatchQueue.main.async {
                if let errorMessage = self?.viewModel.errorMessage{
                    print("ERROR-MESSAGE: ", errorMessage)
                }else{
                    //self.tableView.reloadData()
                    print("Recargar LISTA/GRID: ", self?.viewModel.popularMovies)
                }
            }
        }
    }
    
    @IBAction func openDetail(_ sender: UIButton) {
        let movie = viewModel.popularMovies[0]
        self.performSegue(withIdentifier: "to_detail", sender: movie)
    }

}

extension MovieListViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "to_detail" {
           if let destinationVC = segue.destination as? MovieDetailViewController,
              let selectedMovie = sender as? Movie {
               destinationVC.movieID = selectedMovie.id
               destinationVC.viewModel = DependencyInjector.shared.makeMovieDetailViewModel()
           }
       }
    }
}
