import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterMyBlogProtocol {
    var view: PresenterToViewMyBlogProtocol? {get set}
    var router: PresenterToRouterMyBlogProtocol? {get set}
    var interactor: PresenterToInteractorMyBlogProtocol? {get set}
    func numberOfSections() -> Int
    func numberOfItemsInSection() -> Int
    func cellForItemAt(collectionView:UICollectionView, indexPath:IndexPath) -> UICollectionViewCell
    func didSelectItemAt(collectionView:UICollectionView, indexPath:IndexPath, selectButtonTitle:String?,viewController:MyBlogViewController)
    func getNotesData(isViewDidLoad: Bool)
    func unselectAllCells()
    func unselectCell(indexPath:IndexPath)
    func deleteNotes()
    func userTapAddNoteButton(viewController: MyBlogViewController)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewMyBlogProtocol {
    func coreDataError(text:String)
    func reloadCollectionView()
    func onEnableDeleteButton()
    func onDisableDeleteButton()
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorMyBlogProtocol {
    var presenter:InteractorToPresenterMyBlogProtocol? {get set}
    func onDeleteNote(note:Note)
    func getNotesData(isViewDidLoad:Bool) -> [Note]
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterMyBlogProtocol {
    func failedCoreData(errorText:String)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterMyBlogProtocol {
    static func createModule() -> MyBlogViewController
    func showCreateNoteScreen(viewController:MyBlogViewController)
    func showNoteScreen(viewController:MyBlogViewController,note:Note)
}
