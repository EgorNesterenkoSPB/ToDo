import UIKit

class PhotoCellModel {
    var image:UIImage
    var isSelected:Bool
    
    init(image:UIImage,isSelected:Bool) {
        self.image = image
        self.isSelected = isSelected
    }
}
