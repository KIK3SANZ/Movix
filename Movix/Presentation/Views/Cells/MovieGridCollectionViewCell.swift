import UIKit
import SDWebImage

class MovieGridCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
        
    func configure(with movie: Movie) {
        if let imageUrl = URL(string: "https://image.tmdb.org/t/p/w500/\(movie.posterPath)") {
            imageView.sd_setImage(with: imageUrl, completed: nil)
        }else{
            imageView.image = nil
        }
    }

}
