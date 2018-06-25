import UIKit

final class MenuGroupCell: UITableViewCell, NibReusable {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    
}

extension MenuGroupCell: Updatable {
    
    typealias ViewData = MenuGroupViewData
    
    func update(with viewData: ViewData) {
        
        groupImageView.image = viewData.image
        name.text = viewData.name
        
    }
    
}
