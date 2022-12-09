import CoreData

final class MainInteractor:PresenterToInteractorMainProtocol {

    var presenter: InteractorToPresenterMainProtocol?
    
    func setFinishTask(task: NSManagedObject) {
        task.setValue(true, forKey: Resources.isFinishedTaskKey)
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
