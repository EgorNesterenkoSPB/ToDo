import UIKit
import CoreData

final class CreateTaskPresenter:ViewToPresenterCreateTaskProtocol {
    var view: PresenterToViewCreateTaskProtocol?
    var router: PresenterToRouterCreateTaskProtocol?
    var interactor: PresenterToInteractorCreateTaskProtocol?
    var name:String?
    var description:String?
    var time:Date?
    let dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    
    func textViewDidEndEditing(textView: UITextView) {
        guard !textView.text.isEmpty else {return}
        guard textView.text != Resources.Placeholders.textViewPlaceholder, textView.textColor != UIColor.placeholderText else { return}
        self.description = textView.text
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.isEmpty == false {
            name = textField.text
        }
    }
    
    func createTask(category: CategoryCoreData?,date:Date?,time:Date?,projectID:NSManagedObjectID?) {
        guard let name = name,name != "" && name != " " else {return}
        var settedDate:Date?
        if let date = date {
            if let time = time {
                settedDate = combineDateWithTime(date: date, time: time)
            } else {
                let calendar = Calendar.current
                guard let endTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date) else {return}
                settedDate = combineDateWithTime(date: date, time: endTime)
            }
        }
        if let category = category {
            self.interactor?.onCreateTask(name: name, description: description, category: category,settedDate: settedDate)
        }
        if let projectID = projectID {
            self.interactor?.onCreateCommonTask(name: name, description: description, settedData: settedDate, projectID: projectID)
        }
    }
    
}

extension CreateTaskPresenter:InteractorToPresenterCreateTaskProtocol {
    func failedCreateTask(errorText: String) {
        view?.onFailedCreateTask(errorText: errorText)
    }
    
    func successfulyCreateTask() {
        view?.onSuccessfulyCreateTask()
    }
    
    
}
