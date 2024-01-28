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

// MARK: Skeleton Loading

extension UITableView {
    func updateSkeletonLoadingState(isLoading: Bool) {
        isLoading ? showSkeletonAnimation() : hideSkeletonAnimation()
    }
    
    private func hideSkeletonAnimation() {
        self.stopSkeletonAnimation()
        self.hideSkeleton()
    }
    
    private func showSkeletonAnimation() {
        self.showAnimatedGradientSkeleton()
    }
}


// MARK: Empty View

extension UITableView {
    func updateTableViewState(isEmpty: Bool) {
        isEmpty ? showEmptyView() : hideEmptyView()
    }
    
    private func showEmptyView() {
        let emptyView = EmptyView(frame: .zero)
        backgroundView = emptyView
    }
    
    private func hideEmptyView() {
        backgroundView = nil
    }
}
