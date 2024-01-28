import UIKit
import Kingfisher

class MoviesListTableViewCell: UITableViewCell {
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImageView.kf.indicatorType = .activity
        movieImageView.layer.cornerRadius = 10
    }
    
    func configure(movieViewModel: MovieViewModel) {
        movieImageView.kf.setImage(with: movieViewModel.image)
        titleLabel.text = movieViewModel.title
        yearLabel.text = movieViewModel.releaseDate
    }
}
