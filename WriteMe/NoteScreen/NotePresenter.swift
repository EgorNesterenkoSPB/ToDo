import UIKit

final class NotePresenter: ViewToPresenterNoteProtocol {
    var view: PresenterToViewNoteProtocol?
    var router: PresenterToRouterNoteProtocol?
    var interactor: PresenterToInteractorNoteProtocol?
    var note:Note
    var selectedIndexImages = [IndexPath]()
    
    init(note:Note) {
        self.note = note
    }
    
    public func numberOfSections() -> Int {
        1
    }
    
    public func numberOfItemsInSection() -> Int {
        note.images?.count ?? 0
    }
    
    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.Cells.photoCellIdentefier, for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        let image = self.getImage(indexPath: indexPath)
        if let image = image {
            let isSelected = self.selectedIndexImages.contains(indexPath)
            cell.cellModel = PhotoCellModel(image: image, isSelected: isSelected)
        }
        return cell
    }
    
    public func getImage(indexPath: IndexPath) -> UIImage? {
        self.interactor?.onGetImage(indexPath: indexPath, note: self.note)
    }
    
    public func changeNameText(text: String?) {
        guard let text = text, !text.trimmingCharacters(in: .whitespaces).isEmpty,text != "Example" else {
            view?.disableDoneButtonHandling()
            return
        }
        self.note.setValue(text, forKey: Resources.noteNameKey)
        view?.enableDoneButtonHandling()
    }
    
    public func changeMainText(text: String) {
        self.note.setValue(text, forKey: Resources.noteTextKey)
        view?.enableDoneButtonHandling()
    }
    
    public func addImage(image: UIImage) {
        self.interactor?.onAddImage(image: image, note: self.note)
    }
    
    public func confirmButtonTapped() {
        self.interactor?.onConfirmButtonTapped()
    }
    
    public func didSelectItemAt(indexPath: IndexPath) {
        if self.selectedIndexImages.contains(indexPath) {
            self.selectedIndexImages.remove(at: indexPath.row)
        } else {
            self.selectedIndexImages.append(indexPath)
        }
            
        self.view?.reloadPhotoCollection()
        if  self.selectedIndexImages.count != 0 {
            self.view?.onEnableTrashButton()
        } else {
            self.view?.onDisableTrashButton()
        }
    }
    
    public func unselectAllPhotos() {
        self.selectedIndexImages.removeAll()
        self.view?.reloadPhotoCollection()
    }
    
    public func userTapTrashButton() {
        self.interactor?.deleteImages(indexes: self.selectedIndexImages, note: self.note)
    }
}

extension NotePresenter: InteractorToPresenterNoteProtocol {
    func successfulyDeleteImages() {
        self.view?.reloadPhotoCollection()
        self.selectedIndexImages.removeAll()
    }
    
    func failedCoreData(errorText: String) {
        view?.onFailedCoreData(errorText: errorText)
    }
    
    func successfulyEditNote() {
        view?.onSuccessfulyEditNote()
    }
}
