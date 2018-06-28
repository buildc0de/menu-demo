import UIKit

protocol EmptyStatePresenting {
    
    var tableView: UITableView! { get }
    var emptyView: UIView! { get }
    var hasContent: Bool { get }
    
}

extension EmptyStatePresenting {
    
    func updateEmptyView() {
        
        if hasContent {
            tableView.backgroundView = nil
        } else {
            tableView.backgroundView = emptyView
            tableView.separatorStyle = .none
        }
        
    }
    
}
