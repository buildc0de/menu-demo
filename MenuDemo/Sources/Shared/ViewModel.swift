import UIKit

protocol TableViewPresentable {
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell
}
