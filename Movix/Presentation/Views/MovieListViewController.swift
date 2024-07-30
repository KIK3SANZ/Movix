import UIKit

class MovieListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layoutToggleButton: UIBarButtonItem!
    private var isGridView: Bool = true
    private let refreshControl = UIRefreshControl()
    
    private let gridLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        return layout
    }()
    
    private let listLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 150) // Tamaño de celda para lista
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 0
        return layout
    }()

    var viewModel: MovieListViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupRefreshControl()
        loadMovies()
    }
    
    func setupUI(){
        title = "view_movies".localized
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = isGridView ? gridLayout : listLayout
        
        collectionView.register(UINib(nibName: "MovieGridCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieGridCell")
        collectionView.register(UINib(nibName: "MovieListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieListCell")
        
        layoutToggleButton.image = UIImage(systemName: isGridView ? Constants.mode_list : Constants.mode_grid)
        layoutToggleButton.target = self
        layoutToggleButton.action = #selector(toggleLayout)
    }
    
    @IBAction func showSortOptions(_ sender: UIBarButtonItem) {
        let titleAction = UIAlertAction(title: "movie_title".localized, style: .default) { _ in
            self.sortMovies(by: 0)
        }
        let dateAction = UIAlertAction(title: "movie_release".localized, style: .default) { _ in
            self.sortMovies(by: 1)
        }
        let popularityAction = UIAlertAction(title: "movie_popularity".localized, style: .default) { _ in
            self.sortMovies(by: 2)
        }
        let actions = [titleAction, dateAction, popularityAction]
        self.showSheet(withMessage: "filter_sort".localized, actions: actions)
    }
    
    
    @objc private func toggleLayout() {
        isGridView.toggle()
        let newLayout = isGridView ? gridLayout : listLayout
        collectionView.reloadData()
        collectionView.setCollectionViewLayout(newLayout, animated: true) {_ in 
            self.collectionView.layoutIfNeeded()
        }
         
        layoutToggleButton.image = UIImage(systemName: isGridView ? Constants.mode_list : Constants.mode_grid)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshMovies), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func refreshMovies() {
        loadMovies {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func sortMovies(by option: Int) {
        viewModel.sortMovies(by: option)
        collectionView.reloadData()
    }
    
    private func loadMovies(completion: (() -> Void)? = nil){
        self.showSpinner(true)
        viewModel.loadPopularMovies{[weak self] in
            self?.showSpinner(false)
            DispatchQueue.main.async {
                if let errorMessage = self?.viewModel.errorMessage{
                    self?.showAlert(withMessage: errorMessage)
                }else{
                    self?.collectionView.reloadData()
                }
                completion?()
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            viewModel.loadMoreMovies{ [weak self] in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        }
    }

}

extension MovieListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.popularMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCollectionViewCell
            let movie = viewModel.popularMovies[indexPath.row]
            cell.configure(with: movie)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieListCell", for: indexPath) as! MovieListCollectionViewCell
            let movie = viewModel.popularMovies[indexPath.row]
            cell.configure(with: movie)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.popularMovies[indexPath.row]
        performSegue(withIdentifier: "to_detail", sender: movie)
    }
    
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

// MARK: - UICollectionViewDelegateFlowLayout

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView {
            return CGSize(width: self.view.frame.width * 0.3, height: self.view.frame.width * 0.4)
        } else {
            return CGSize(width: UIScreen.main.bounds.width - 20, height: 100)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return isGridView ? 5 : 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return isGridView ? 15 : 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return isGridView ? UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
     
}
