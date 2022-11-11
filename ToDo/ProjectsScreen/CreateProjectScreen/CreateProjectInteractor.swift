import Foundation

final class CreateProjectInteractor:PresenterToInteractorCreateProjectProtocol {
    func onCreateProject(name: String, hexColor: String, isFavorite: Bool) {
        do {
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
