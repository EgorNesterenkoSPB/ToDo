final class ProjectsInteractor:PresenterToInteractorProjectsProtocol {
    var presenter: InteractorToPresenterProjectsProtocol?
    
    func deleteProject(project: ProjectCoreData) {
        do {
            try DataManager.shared.deleteProject(project: project)
            presenter?.successfulyDeleteProject()
        } catch let error {
            presenter?.failedCoreData(errorText: "\(error)")
        }
    }

}
