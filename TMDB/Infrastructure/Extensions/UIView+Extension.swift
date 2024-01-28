import UIKit

extension UIView {
    func loadNibView() {
        guard let view = Bundle.main.loadNibNamed(String(describing: Self.self), owner: self)![0] as? UIView else {
            fatalError("Init View error \(self.self)")
        }
        view.frame = self.bounds
        addSubview(view)
    }
}
