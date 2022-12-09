import UIKit
import CoreData

func createInfoAlert(messageText:String,titleText:String) -> UIAlertController {
    let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: Resources.Titles.okActionTitle, style: .default, handler: nil))
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
    cell.circleButton.setImage(UIImage(systemName: Resources.Images.checkmarkCircleFill,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
    cell.circleButton.tintColor = .systemOrange
}

func combineDateWithTime(date: Date, time: Date) -> Date? {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var mergedComponents = DateComponents()
        mergedComponents.year = dateComponents.year
        mergedComponents.month = dateComponents.month
        mergedComponents.day = dateComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute
        mergedComponents.second = timeComponents.second
        
        return calendar.date(from: mergedComponents)
    }

func isOverdue(taskDate:Date) -> Bool {
    let today = Date()
    return taskDate < today
}

func createDeleteTaskContextualAction(title:String,viewController:UIViewController,with completionHandler: @escaping () -> Void) -> UIContextualAction{
    let delete = UIContextualAction(style: .destructive, title: nil, handler: { (action,swipeButtonView,completion) in
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: title, style: .destructive, handler: { _ in
            completionHandler()
//            self?.interactor?.deleteProject(project: project)
        }))
        alert.addAction(UIAlertAction(title: Resources.Titles.cancelButton, style: .cancel, handler: nil))
        viewController.present(alert,animated: true)
        completion(true)
    })
    delete.image = UIImage(systemName: Resources.Images.trash,withConfiguration: Resources.Configurations.largeConfiguration)
    delete.image?.withTintColor(.white)
    delete.backgroundColor = .red
    return delete
}
