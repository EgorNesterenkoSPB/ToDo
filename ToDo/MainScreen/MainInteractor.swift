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
}
