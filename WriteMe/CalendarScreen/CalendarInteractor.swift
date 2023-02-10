import Foundation
import CoreData

final class CalendarInteractor:PresenterToInteractorCalendarProtocol {
    var presenter: InteractorToPresenterCalendarProtocol?
    
    func getNumberOfDateEvents(date: Date) -> Int {
        do {
            let tasks = try self.getTasksAtDate(date: date)
            return tasks.count
        } catch let error {
            self.presenter?.failureGetTasks(errorText: "Failed get tasks at day \(date): \(error.localizedDescription)")
            return 0
        }
    }
    
    func setFinishTask(task: NSManagedObject) {
        task.setValue(true, forKey: Resources.isFinishedTaskKey)
        let currentDate = Date()
        task.setValue(currentDate, forKey: Resources.timeFinishedTaskKey)
        do {
            try DataManager.shared.save()
            presenter?.successfulyFinishedTask()
        } catch let error {
            presenter?.failureCoreData(errorText: error.localizedDescription)
        }
    }
    
    func deleteTask(task: NSManagedObject) {
        do {
            if let commonTask = task as? CommonTaskCoreData {
                try DataManager.shared.deleteCommonTask(commonTask: commonTask)
            } else if let categoryTask = task as? TaskCoreData {
                try DataManager.shared.deleteTask(task: categoryTask)
            }
            self.presenter?.successfulyDeleteTask()
        } catch let error {
            self.presenter?.failureCoreData(errorText: error.localizedDescription)
        }
    }
    
    func onGetTasks(date: Date) {
        do {
            let tasks = try self.getTasksAtDate(date: date)
            self.presenter?.successfulyGetTasks(tasks: tasks)
        } catch let error {
            self.presenter?.failureGetTasks(errorText: error.localizedDescription)
        }
    }
    
    private func getTasksAtDate(date:Date) throws -> [NSManagedObject] {
        var resultTasks = [NSManagedObject]()
        do {
            let projects = try DataManager.shared.projects()
           try projects.forEach({ project in
                let commonTasks = try DataManager.shared.commonTasks(project: project)
               resultTasks += commonTasks.filter{ task in
                   guard let taskTime = task.time, task.isFinished == false else {return false}
                   return isSameDate(firstDate: taskTime, secondDate: date)
               }
               
               let categories = try DataManager.shared.categories(project: project)
               try categories.forEach{ category in
                   let tasks = try DataManager.shared.tasks(category: category)
                   resultTasks += tasks.filter{ task in
                       guard let taskTime = task.time, task.isFinished == false else {return false}
                       return isSameDate(firstDate: taskTime, secondDate: date)
                   }
               }
            })
        } catch let error{
            throw error
        }
        return resultTasks
    }
    
}
