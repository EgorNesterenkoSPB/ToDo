class NoteModel {
    let note:Note
    var photoCellData:[PhotoCellModel]
    
    init(note:Note, photoCellData:[PhotoCellModel]) {
        self.note = note
        self.photoCellData = photoCellData
    }
}
