import UIKit

extension UITableView {
    func registerNib<T: UITableViewCell>(cellType: T.Type) {
        let nib = UINib(nibName: T.reusableIdentifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: T.reusableIdentifier)
    }
    
    func dequeue<T: UITableViewCell>(cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reusableIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with type \(T.self)")
        }
        
        return cell
    }
}