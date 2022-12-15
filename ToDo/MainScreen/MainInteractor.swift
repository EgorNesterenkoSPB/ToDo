import CoreData
import Foundation

final class MainInteractor:PresenterToInteractorMainProtocol {
    var presenter: InteractorToPresenterMainProtocol?
    let defaults = UserDefaults.standard
    
    func onCreateIncomingProject() {
        let isIncoming = defaults.bool(forKey: Resources.isIncomingKey)
        switch isIncoming {
        case true:
            return
        case false:
            self.addIncomgProject()
        }
    }
    
    private func addIncomgProject() {
        
        do {
            var projects = try DataManager.shared.projects()
            let project = DataManager.shared.project(name: Resources.incomingProjectName, hexColor: "171717", isFavorite: false)
            projects.append(project)
            try DataManager.shared.save()
            defaults.setValue(true, forKey: Resources.isIncomingKey)
        } catch let error {
            self.presenter?.failureCreateIncomingProject(errorText: error.localizedDescription)
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
            presenter?.failureFinishedTask(errorText: error.localizedDescription)
        }
    }
    
    func createTask(projectID: NSManagedObjectID) {
        
    }
    
    func deleteTask<T>(task: T) where T : NSManagedObject {
        do {
            switch task {
            case is CommonTaskCoreData:
                guard let task = task as? CommonTaskCoreData else {return}
                try DataManager.shared.deleteCommonTask(commonTask: task)
            case is TaskCoreData:
                guard let task = task as? TaskCoreData else {return}
                try DataManager.shared.deleteTask(task: task)
            default:
                break
            }
            presenter?.successfulyDeleteTask()
        } catch let error {
            presenter?.failureDeleteTask(errorText: error.localizedDescription)
        }
    }
}
