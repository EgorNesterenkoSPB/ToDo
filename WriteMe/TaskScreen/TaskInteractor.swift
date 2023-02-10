import CoreData

final class TaskInteractor:PresenterToInteractorTaskProtocol {
    var presenter: InteractorToPresenterTaskProtocol?
    
    func onRenameTask(newName: String, task: NSManagedObject) {
        do {
            task.setValue(newName, forKey: Resources.taskNameKey)
            try DataManager.shared.save()
        } catch let error {
            self.presenter?.failureRenameTask(errorText: error.localizedDescription)
        }
    }
    
    func onEditeDate(task: NSManagedObject, newDate: Date) {
        do {
            task.setValue(newDate, forKey: Resources.taskDateKey)
            try DataManager.shared.save()
            self.presenter?.successfulyChangeDate(date: newDate)
        } catch let error {
            self.presenter?.failureEditeTaskDate(errorText: error.localizedDescription)
        }
    }
    
    func onDeleteDate(task: NSManagedObject) {
        do {
            task.setValue(nil, forKey: Resources.taskDateKey)
            try DataManager.shared.save()
            self.presenter?.successfulyDeleteDate()
        } catch let error {
            self.presenter?.failureDeleteDate(errorText: error.localizedDescription)
        }
    }
    
    func editDescription(text: String, task: NSManagedObject) {
        do {
            task.setValue(text, forKey: Resources.taskDescriptionKey)
            try DataManager.shared.save()
        } catch let error {
            self.presenter?.failureEditDescription(errorText: error.localizedDescription)
        }
    }
    
    func deleteTask(task: NSManagedObject) {
        do {
            if let task = task as? TaskCoreData {
                try DataManager.shared.deleteTask(task: task)
            }
            if let task = task as? CommonTaskCoreData {
                try DataManager.shared.deleteCommonTask(commonTask: task)
            }
            self.presenter?.successfulyDeleteTask()
        } catch let error {
            self.presenter?.failureDeleteTask(errorText: error.localizedDescription)
        }
    }
    
}
