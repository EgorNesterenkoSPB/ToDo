final class ProjectsInteractor:PresenterToInteractorProjectsProtocol {
    var presenter: InteractorToPresenterProjectsProtocol?
    
    func onCreateProject(name: String, hexColor: String,isFavorite:Bool) {
        do {
            var projects = try DataManager.shared.projects()
            let project = DataManager.shared.project(name: name, hexColor: hexColor, isFavorite: isFavorite)
            project.categories = nil
            projects.append(project)
            try DataManager.shared.save()
            presenter?.successfulyCreateProject(projects: projects)
        } catch let error {
            presenter?.failureCreateProject(errorText: "\(error)")
        }
    }
    
}
