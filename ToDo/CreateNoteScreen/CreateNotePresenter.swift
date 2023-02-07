import UIKit

final class CreateNotePresenter: ViewToPresenterCreateNoteProtocol {
    var view: PresenterToViewCreateNoteProtocol?
    var router: PresenterToRouterCreateNoteProtocol?
    var interactor: PresenterToInteractorCreateNoteProtocol?
    var imagesData = [PhotoCellModel]()
    
    public func numberOfSections() -> Int {
        1
    }
    
    public func numberOfItemsInSection() -> Int {
        imagesData.count
    }
    
    public func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.Cells.photoCellIdentefier, for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        cell.cellModel = imagesData[indexPath.row]
        return cell
    }
    
    public func createNote() {
        interactor?.onCreateNote(images: self.imagesData.map{$0.image})
    }
    
    public func setName(text: String?) {
        interactor?.onSetName(text: text)
    }
    
    public func setMainText(text: String) {
        interactor?.onSetMainText(text: text)
    }
    
    public func setImage(image: UIImage) {
        self.imagesData.insert(PhotoCellModel(image: image, isSelected: false), at: 0)
    }
    
    public func didSelectItemAt(indexPath: IndexPath) {
        self.imagesData[indexPath.row].isSelected.toggle()
        self.view?.reloadPhotoCollection()
        if (self.imagesData.first(where: {$0.isSelected == true}) != nil) {
            self.view?.onEnableTrashButton()
        } else {
            self.view?.onDisableTrashButton()
        }
    }
    
    public func unselectAllPhotos() {
        self.imagesData.forEach{$0.isSelected = false}
        self.view?.reloadPhotoCollection()
    }
    
    public func userTapTrashButton() {
        self.imagesData = self.imagesData.filter{$0.isSelected == false}
        self.view?.reloadPhotoCollection()
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
