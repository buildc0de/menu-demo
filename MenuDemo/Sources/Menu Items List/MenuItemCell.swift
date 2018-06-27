import UIKit

final class MenuItemCell: UITableViewCell, NibReusable {
    
    // MARK: - @IBOutlet
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
}

extension MenuItemCell: Updatable {
    
    typealias ViewData = MenuItemViewData
    
    func update(with viewData: ViewData) {
        
        if
            let imageHeight = viewData.image?.size.height,
            let imageWidth = viewData.image?.size.width,
            imageHeight > 0,
            imageWidth > 0
        {
            
            let aspectRatio = imageHeight / imageWidth
            imageViewHeightConstraint.constant = groupImageView.bounds.width * aspectRatio
            
        } else {
            imageViewHeightConstraint.constant = 0
        }
        
        groupImageView.image = viewData.image
        name.text = viewData.name
        
    }
    
}
