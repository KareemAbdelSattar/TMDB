import UIKit

protocol Reusable {
    static var reusableIdentifier: String { get }
}

extension Reusable {
    static var reusableIdentifier: String {
        String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable {}

