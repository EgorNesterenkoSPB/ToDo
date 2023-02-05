import UIKit

final class MyBlogPresenter: ViewToPresenterMyBlogProtocol {
    var view: PresenterToViewMyBlogProtocol?
    var router: PresenterToRouterMyBlogProtocol?
    var interactor: PresenterToInteractorMyBlogProtocol?
    var cellsData = [NoteCellModel]()
    
    
    public func numberOfSections() -> Int {
        1
    }
    
    public func numberOfItemsInSection() -> Int {
        self.cellsData.count
    }
    
    public func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Resources.Cells.noteListCellIdentefier, for: indexPath) as? NoteListCollectionViewCell else { return UICollectionViewCell()}
        let cellModel = self.getCellData(at: indexPath)
        cell.cellModel = cellModel
        return cell
    }
    
    public func didSelectItemAt(collectionView: UICollectionView, indexPath: IndexPath,selectButtonTitle:String?,viewController:MyBlogViewController) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? NoteListCollectionViewCell,let selectButtonTitle = selectButtonTitle else {return}
        
        switch selectButtonTitle {
        case Resources.Titles.unselect:
            if self.cellsData[indexPath.row].isSelected {
                cell.backgroundColor = .systemOrange
                self.unselectCell(indexPath: indexPath)
            } else {
                cell.backgroundColor = .blue
                self.cellsData[indexPath.row].isSelected = true
            }
        default:
            let note = self.cellsData[indexPath.row].note
            self.router?.showNoteScreen(viewController: viewController, note: note)
        }
        
        if (self.cellsData.first(where: {$0.isSelected}) != nil) {
            view?.onEnableDeleteButton()
        } else {
            view?.onDisableDeleteButton()
        }
    }
    
    private func getCellData(at indexPath:IndexPath) -> NoteCellModel {
        return cellsData[indexPath.row]
    }
    
    public func unselectAllCells() {
        cellsData.forEach{$0.isSelected = false}
    }
    
    public func unselectCell(indexPath:IndexPath) {
        cellsData[indexPath.row].isSelected = false
    }
    
    public func deleteNotes() {
        for cellData in cellsData {
            if cellData.isSelected {
                self.interactor?.onDeleteNote(note: cellData.note)
            }
        }
        cellsData = cellsData.filter{$0.isSelected == false}
        
        view?.reloadCollectionView()
    }
    
    public func getNotesData(isViewDidLoad:Bool) {
        guard let interactor = interactor else {return}
        let notes = interactor.getNotesData(isViewDidLoad: isViewDidLoad)
        cellsData = notes.map{NoteCellModel(note: $0, isSelected: false)}
        view?.reloadCollectionView()
    }
    
    public func userTapAddNoteButton(viewController: MyBlogViewController) {
        self.router?.showCreateNoteScreen(viewController: viewController)
    }
}

extension MyBlogPresenter: InteractorToPresenterMyBlogProtocol {    
    func failedCoreData(errorText: String) {
        view?.coreDataError(text: errorText)
    }
    
    
}
