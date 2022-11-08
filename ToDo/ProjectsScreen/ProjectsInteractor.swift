final class ProjectsInteractor:PresenterToInteractorProjectsProtocol {
    var presenter: InteractorToPresenterProjectsProtocol?
    
    func deleteProject(project: ProjectCoreData) {
        do {
            try DataManager.shared.deleteProject(project: project)
            presenter?.successfulyDeleteProject()
        } catch let error {
            presenter?.failedDeleteProject(errorText: "\(error)")
        }
    }
    
    func onCreateProject(name: String, hexColor: String,isFavorite:Bool) {
        do {
            var projects = try DataManager.shared.projects()
            let project = DataManager.shared.project(name: name, hexColor: hexColor, isFavorite: isFavorite)
            projects.append(project)
            try DataManager.shared.save()
            presenter?.successfulyCreateProject(projects: projects)
        } catch let error {
            presenter?.failureCreateProject(errorText: "\(error)")
        }
    }
    
}
