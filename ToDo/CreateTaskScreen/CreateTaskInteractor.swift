import CoreData

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
    
    func onCreateCommonTask(name: String, description: String?, settedData: Date?,projectID:NSManagedObjectID) {
        //FIXME: - mock priority
        do {
            let projects = try DataManager.shared.projects()
            guard let project = projects.first(where: {$0.objectID == projectID}) else {return}
            let commonTask = DataManager.shared.commonTask(name: name, description: description, priority: nil, time: settedData, project: project)
            
            var commonTasks = try DataManager.shared.commonTasks(project: project)
            commonTasks.append(commonTask)
            try DataManager.shared.save()
            self.presenter?.successfulyCreateTask()
        } catch let error {
            presenter?.failedCreateTask(errorText: error.localizedDescription)
        }
        
        
    }
    
}
