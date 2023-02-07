import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterNoteProtocol {
    var view: PresenterToViewNoteProtocol? {get set}
    var router: PresenterToRouterNoteProtocol? {get set}
    var interactor: PresenterToInteractorNoteProtocol? {get set}
    var note:Note {get set}
    func numberOfSections() -> Int
    func numberOfItemsInSection() -> Int
    func getImage(indexPath:IndexPath) -> UIImage?
    func changeNameText(text:String?)
    func changeMainText(text:String)
    func addImage(image:UIImage)
    func confirmButtonTapped()
    func cellForItemAt(collectionView:UICollectionView, indexPath:IndexPath) -> UICollectionViewCell
    func didSelectItemAt(indexPath:IndexPath)
    func unselectAllPhotos()
    func userTapTrashButton()
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewNoteProtocol {
    func onFailedCoreData(errorText:String)
    func disableDoneButtonHandling()
    func enableDoneButtonHandling()
    func onSuccessfulyEditNote()
    func reloadPhotoCollection()
    func onEnableTrashButton()
    func onDisableTrashButton()
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorNoteProtocol {
    var presenter:InteractorToPresenterNoteProtocol? {get set}
    func onGetImage(indexPath: IndexPath,note:Note) -> UIImage?
    func onAddImage(image: UIImage,note:Note)
    func onConfirmButtonTapped()
    func deleteImages(indexes:[IndexPath],note:Note)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterNoteProtocol {
    func failedCoreData(errorText:String)
    func successfulyEditNote()
    func successfulyDeleteImages()
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterNoteProtocol {
    static func createModule(note:Note) -> NoteViewController
}
