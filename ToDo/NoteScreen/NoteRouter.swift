import UIKit

final class NoteRouter:PresenterToRouterNoteProtocol {
    static func createModule(note:Note) -> NoteViewController {
        let noteViewController = NoteViewController()
        
        let notePresenter: (ViewToPresenterNoteProtocol & InteractorToPresenterNoteProtocol) = NotePresenter(note: note)
        
        noteViewController.presenter = notePresenter
        noteViewController.presenter?.view = noteViewController
        noteViewController.presenter?.interactor = NoteInteractor()
        noteViewController.presenter?.router = NoteRouter()
        noteViewController.presenter?.interactor?.presenter = notePresenter
        return noteViewController
    }
}
