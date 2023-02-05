import UIKit

final class MyBlogRouter:PresenterToRouterMyBlogProtocol {
    func showNoteScreen(viewController: MyBlogViewController, note: Note) {
        let noteViewController = NoteRouter.createModule(note: note)
        noteViewController.delegate = viewController
        viewController.present(noteViewController, animated: true)
    }
    
    func showCreateNoteScreen(viewController: MyBlogViewController) {
        let createNoteViewController = CreateNoteRouter.createModule()
        createNoteViewController.delegate = viewController
        viewController.present(createNoteViewController, animated: true, completion: nil)
    }
    
    static func createModule() -> MyBlogViewController {
        let myBlogViewController = MyBlogViewController()
        
        let myBlogPresenter: (ViewToPresenterMyBlogProtocol & InteractorToPresenterMyBlogProtocol) = MyBlogPresenter()
        
        myBlogViewController.presenter = myBlogPresenter
        myBlogViewController.presenter?.view = myBlogViewController
        myBlogViewController.presenter?.interactor = MyBlogInteractor()
        myBlogViewController.presenter?.router = MyBlogRouter()
        myBlogViewController.presenter?.interactor?.presenter = myBlogPresenter
        return myBlogViewController
    }
}
