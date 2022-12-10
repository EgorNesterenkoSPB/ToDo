import CoreData

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
    
    func getIncomingProject(projectsViewController:ProjectsViewController) {
        do {
            let projects = try DataManager.shared.projects()
            guard let incomingProject = projects.first(where: {$0.name == Resources.incomingProjectName}) else {
                self.presenter?.failedGetIncomingProject(errorText: "Incoming project isnt found, please write in support!")
                return
            }
            self.presenter?.successfulyGetIncomingProject(project: incomingProject, projectsViewController: projectsViewController)
        } catch let error {
            self.presenter?.failedCoreData(errorText: error.localizedDescription)
        }
    }

}
