import UIKit

final class CreateNoteRouter:PresenterToRouterCreateNoteProtocol {
    static func createModule() -> CreateNoteViewController {
        let createNoteViewController = CreateNoteViewController()
        
        let createNotePresenter: (ViewToPresenterCreateNoteProtocol & InteractorToPresenterCreateNoteProtocol) = CreateNotePresenter()
        
        createNoteViewController.presenter = createNotePresenter
        createNoteViewController.presenter?.view = createNoteViewController
        createNoteViewController.presenter?.interactor = CreateNoteInteractor()
        createNoteViewController.presenter?.router = CreateNoteRouter()
        createNoteViewController.presenter?.interactor?.presenter = createNotePresenter
        return createNoteViewController
    }
}
