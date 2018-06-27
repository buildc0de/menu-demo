import UIKit

struct ViewModel<Cell>: TableViewPresentable
    where Cell: UITableViewCell & NibReusable & Updatable
{

    let cellType: Cell.Type
    let viewData: Cell.ViewData
    
    func cell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        
        let cell: Cell
        
        if let registeredCell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier) as? Cell {
            
            cell = registeredCell
            
        } else {
            
            tableView.register(Cell.nib, forCellReuseIdentifier: Cell.reuseIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: Cell.reuseIdentifier) as! Cell
            
        }
        
        cell.update(with: viewData)
        return cell
        
    }
    
}
