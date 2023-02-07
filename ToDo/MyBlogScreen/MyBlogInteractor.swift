import Foundation


class MyBlogInteractor:PresenterToInteractorMyBlogProtocol {
    var presenter: InteractorToPresenterMyBlogProtocol?
    let defaults = UserDefaults.standard
    
    func onDeleteNote(note: Note) {
        do {
            let noteName = note.name
            try DataManager.shared.deleteNote(note: note)
            if noteName == Resources.Titles.example { // dont show example note again
                defaults.set(true, forKey: Resources.exampleNoteKey)
            }
        } catch let error {
            self.presenter?.failedCoreData(errorText:"Failed delete note ,error: \(error.localizedDescription) ")
        }
    }
    
    func getNotesData(isViewDidLoad:Bool) -> [Note] {
        var notes = [Note]()
        do {
            notes = try DataManager.shared.notes()
            
            if isViewDidLoad {
                let isExampleNoteDeleted = defaults.bool(forKey: Resources.exampleNoteKey)
                if !isExampleNoteDeleted {
                    if notes.isEmpty {
                        let firstExampleNote = DataManager.shared.note(name: Resources.Titles.example, text: "Test example text")
                        notes.insert(firstExampleNote, at: 0)
                        try DataManager.shared.save()
                    }
                }
            }            
        } catch let error {
            self.presenter?.failedCoreData(errorText:"Failed load data, error: \(error.localizedDescription)")
        }
        return notes
    }
}
