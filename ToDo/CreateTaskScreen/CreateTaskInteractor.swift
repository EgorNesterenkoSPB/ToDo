import Foundation

final class CreateTaskInteractor:PresenterToInteractorCreateTaskProtocol {
    var presenter: InteractorToPresenterCreateTaskProtocol?
    
    func onCreateTask(name: String, description: String?, category: CategoryCoreData,settedDate:Date?) {
        //FIXME: - mock priority
        let task = DataManager.shared.task(name: name, description: description, priority: nil, time: settedDate, category: category)
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
