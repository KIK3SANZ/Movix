import UIKit
import SDWebImage

class MovieListCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblVotes: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.image = nil
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    func configure(with movie: Movie) {
        title.text = movie.title
        desc.text = movie.overview
        lblVotes.text = "\(movie.voteCount)"
        lblDate.text = movie.releaseDate
        
        if let imageUrl = URL(string: movie.fullPosterURL) {
            imageView.sd_setImage(with: imageUrl, completed: nil)
        }else{
            imageView.image = nil
        }
    }
    
}
