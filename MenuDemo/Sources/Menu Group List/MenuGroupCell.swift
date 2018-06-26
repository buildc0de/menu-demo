import UIKit

final class MenuGroupCell: UITableViewCell, NibReusable {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
}

extension MenuGroupCell: Updatable {
    
    typealias ViewData = MenuGroupViewData
    
    func update(with viewData: ViewData) {
        
        let aspectRatio = viewData.image.size.height / viewData.image.size.width
        imageViewHeightConstraint.constant = groupImageView.bounds.width * aspectRatio
        groupImageView.image = viewData.image
        name.text = viewData.name
        
    }
    
}
