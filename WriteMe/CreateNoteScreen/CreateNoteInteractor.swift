import Foundation
import UIKit

final class CreateNoteInteractor: PresenterToInteractorCreateNoteProtocol {
    var presenter: InteractorToPresenterCreateNoteProtocol?
    var name:String?
    var text:String?
    
    func onCreateNote(images:[UIImage]) {
        guard let name = name else {return}
        let note = DataManager.shared.note(name: name, text: text)
        do {
            var notes = try DataManager.shared.notes()
            notes.append(note)
            try DataManager.shared.save()
            
            try self.saveNoteImages(note: note, images: images)
            
            presenter?.successfulyCreateNote()
        } catch let error {
            presenter?.failedCoreData(errorText: "Failed create note, error: \(error.localizedDescription)")
        }
    }
    
    private func saveNoteImages(note:Note,images:[UIImage]) throws {
        var noteImages = try DataManager.shared.noteImages(note: note)
        
        try images.forEach { image in
            let noteImage = DataManager.shared.noteImage(image: image, note: note)
            noteImages.append(noteImage)
            try DataManager.shared.save()
        }
    }
    
    func onSetMainText(text: String) {
        guard !text.isEmpty, !text.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        self.text = text
    }
    
    func onSetName(text: String?) {
        guard let text = text, !text.trimmingCharacters(in: .whitespaces).isEmpty,text != "Example" else {
            presenter?.disableDoneButtonHandling()
            return
        }
        self.name = text
        presenter?.enableDoneButtonHandling()
    }
}
