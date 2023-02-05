import UIKit

final class CreateNotePresenter: ViewToPresenterCreateNoteProtocol {
    var view: PresenterToViewCreateNoteProtocol?
    var router: PresenterToRouterCreateNoteProtocol?
    var interactor: PresenterToInteractorCreateNoteProtocol?
    var images = [UIImage]()
    
    
    public func numberOfSections() -> Int {
        1
    }
    
    public func numberOfItemsInSection() -> Int {
        images.count
    }
    
    public func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.Cells.photoCellIdentefier, for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        cell.cellModel = PhotoCellModel(image: self.images[indexPath.row])
        return cell
    }
    
    public func createNote() {
        interactor?.onCreateNote(images: self.images)
    }
    
    public func setName(text: String?) {
        interactor?.onSetName(text: text)
    }
    
    public func setMainText(text: String) {
        interactor?.onSetMainText(text: text)
    }
    
    func setImage(image: UIImage) {
        self.images.insert(image, at: 0)
    }
    
}

extension CreateNotePresenter: InteractorToPresenterCreateNoteProtocol {
    func successfulyCreateNote() {
        view?.onSuccessfulyCreateNote()
    }
    
    func failedCoreData(errorText: String) {
        view?.onFailedCoreData(errorText: errorText)
    }
    
    func disableDoneButtonHandling() {
        view?.onDisableDoneButtonHandling()
    }
    
    func enableDoneButtonHandling() {
        view?.onEnableDoneButtonHandling()
    }
}
