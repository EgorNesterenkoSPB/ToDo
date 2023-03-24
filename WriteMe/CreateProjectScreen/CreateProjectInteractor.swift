import Foundation

final class CreateProjectInteractor:PresenterToInteractorCreateProjectProtocol {
    func onCreateProject(name: String, hexColor: String, isFavorite: Bool) {
        do {
            guard name != Resources.incomingProjectName else { // protect from create project with name "Incoming" bc we init project with this name at first when user open main screen
                self.presenter?.failureCreateProject(errorText: Resources.Titles.errorCreateProjectMessage)
                return
            }
            var projects = try DataManager.shared.projects()
            let project = DataManager.shared.project(name: name, hexColor: hexColor, isFavorite: isFavorite)
            projects.append(project)
            try DataManager.shared.save()
            presenter?.successfulyCreateProject()
        } catch let error {
            presenter?.failureCreateProject(errorText: "\(error)")
        }
    }
    
    var presenter: InteractorToPresenterCreateProjectProtocol?
}
