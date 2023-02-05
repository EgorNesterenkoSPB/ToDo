import UIKit

final class NoteInteractor: PresenterToInteractorNoteProtocol {
    var presenter: InteractorToPresenterNoteProtocol?
    
    func onGetImage(indexPath: IndexPath, note: Note) -> UIImage? {
        do {
            let noteImages = try DataManager.shared.noteImages(note: note)
            let image = UIImage(data: noteImages[indexPath.row].image! as Data)
            return image
        } catch let error {
            presenter?.failedCoreData(errorText: "Failed to get image, error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func onAddImage(image: UIImage, note: Note) {
        do {
            var noteImages = try DataManager.shared.noteImages(note: note)
            let noteImage = DataManager.shared.noteImage(image: image, note: note)
            noteImages.insert(noteImage, at: 0)
            try DataManager.shared.save()
        } catch let error {
            presenter?.failedCoreData(errorText: "Failed to save image, error: \(error.localizedDescription)")
        }
    }
    
    func onConfirmButtonTapped() {
        do {
            try DataManager.shared.save()
            presenter?.successfulyEditNote()
        } catch let error {
            presenter?.failedCoreData(errorText: "Failed to change, error:\(error.localizedDescription)")
        }
    }
}
