final class CreateCommonTaskInteractor:PresenterToInteractorCreateCommonTaskProtocol {
    
    var presenter: InteractorToPresenterCreateCommonTaskProtocol?

    func onCreateTask(project: ProjectCoreData, name: String, description: String?) {
        let commonTask = DataManager.shared.commonTask(name: name, description: description, priority: nil, time: nil, project: project)
        do {
            var commonTasks = try DataManager.shared.commonTasks(project: project)
            commonTasks.append(commonTask)
            try DataManager.shared.save()
            self.presenter?.successfulyCreateTask()
        } catch let error {
            self.presenter?.failedCreateTask(errorText: "\(error)")
        }

    }
    
}
