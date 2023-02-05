import UIKit

final class NotePresenter: ViewToPresenterNoteProtocol {
    var view: PresenterToViewNoteProtocol?
    var router: PresenterToRouterNoteProtocol?
    var interactor: PresenterToInteractorNoteProtocol?
    var note:Note
    
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
            cell.cellModel = PhotoCellModel(image: image)
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
        note.setValue(text, forKey: Resources.noteNameKey)
        view?.enableDoneButtonHandling()
    }
    
    public func changeMainText(text: String) {
        note.setValue(text, forKey: Resources.noteTextKey)
        view?.enableDoneButtonHandling()
    }
    
    public func addImage(image: UIImage) {
        self.interactor?.onAddImage(image: image, note: note)
    }
    
    public func confirmButtonTapped() {
        self.interactor?.onConfirmButtonTapped()
    }
}

extension NotePresenter: InteractorToPresenterNoteProtocol {
    func failedCoreData(errorText: String) {
        view?.onFailedCoreData(errorText: errorText)
    }
    
    func successfulyEditNote() {
        view?.onSuccessfulyEditNote()
    }
}
