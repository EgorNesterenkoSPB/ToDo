import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterCreateNoteProtocol {
    var view: PresenterToViewCreateNoteProtocol? {get set}
    var router: PresenterToRouterCreateNoteProtocol? {get set}
    var interactor: PresenterToInteractorCreateNoteProtocol? {get set}
    var imagesData:[PhotoCellModel] {get set}
    func numberOfSections() -> Int
    func numberOfItemsInSection() -> Int
    func cellForItemAt(collectionView:UICollectionView, indexPath:IndexPath) -> UICollectionViewCell
    func createNote()
    func setName(text:String?)
    func setMainText(text:String)
    func setImage(image:UIImage)
    func didSelectItemAt(indexPath:IndexPath)
    func unselectAllPhotos()
    func userTapTrashButton()
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewCreateNoteProtocol {
    func onDisableDoneButtonHandling()
    func onEnableDoneButtonHandling()
    func onFailedCoreData(errorText:String)
    func onSuccessfulyCreateNote()
    func reloadPhotoCollection()
    func onEnableTrashButton()
    func onDisableTrashButton()
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorCreateNoteProtocol {
    var presenter:InteractorToPresenterCreateNoteProtocol? {get set}
    func onCreateNote(images:[UIImage])
    func onSetMainText(text:String)
    func onSetName(text: String?)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterCreateNoteProtocol {
    func successfulyCreateNote()
    func failedCoreData(errorText:String)
    func disableDoneButtonHandling()
    func enableDoneButtonHandling()
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterCreateNoteProtocol {
    static func createModule() -> CreateNoteViewController
}
