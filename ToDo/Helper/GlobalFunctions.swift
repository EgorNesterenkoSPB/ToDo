import UIKit

func createErrorAlert(errorText:String) -> UIAlertController {
    let alert = UIAlertController(title: Resources.Titles.errorTitle, message: errorText, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: Resources.Titles.errorActionTitle, style: .default, handler: nil))
    return alert
}

 func getDocumentsDirectory() -> URL {
     let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
     return paths[0]
}

func throughLineCell(cell:TaskTableViewCell,indexPath:IndexPath) {
    guard let text = cell.nameTitle.text else {return}
    let attributeString:NSMutableAttributedString = NSMutableAttributedString(string: text)
    attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
    
    cell.nameTitle.attributedText = attributeString
    cell.nameTitle.textColor = .gray
    cell.circleButton.setImage(UIImage(systemName: Resources.Images.circleFill,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
    cell.circleButton.tintColor = .systemOrange
}
