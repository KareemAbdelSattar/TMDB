import UIKit

class MoviesListTableViewCell: UITableViewCell {
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
