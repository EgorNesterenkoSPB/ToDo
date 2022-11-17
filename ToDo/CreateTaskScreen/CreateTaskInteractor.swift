import Foundation

final class CreateTaskInteractor:PresenterToInteractorCreateTaskProtocol {
    var presenter: InteractorToPresenterCreateTaskProtocol?
    
    func onCreateTask(name: String, description: String?, category: CategoryCoreData) {
        //FIXME: - mock data time and priority
        let task = DataManager.shared.task(name: name, description: description, priority: PriorityTask.high, time: Date(), category: category)
        do {
            var tasks = try DataManager.shared.tasks(category: category)
            tasks.append(task)
            try DataManager.shared.save()
            self.presenter?.successfulyCreateTask()
        } catch let error {
            self.presenter?.failedCreateTask(errorText: "\(error)")
        }
    }
    
}
