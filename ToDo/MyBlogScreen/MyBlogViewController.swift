import UIKit

class MyBlogViewController: BaseViewController {
    
    var presenter: (ViewToPresenterMyBlogProtocol & InteractorToPresenterMyBlogProtocol)?
    let notesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var selectButton = UIBarButtonItem()
    var deleteButton = UIBarButtonItem()
    
    private enum UIConstants {
        static let collectionTopAnchor = 10.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.getNotesData(isViewDidLoad: true)
    }
}


extension MyBlogViewController {
    
    override func addViews() {
        view.addView(notesCollectionView)
    }
    
    override func configure() {
        super.configure()
        title = Resources.Titles.myBlogTitle
        
        let createNoteButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNoteButtonTapped(_:)))
        self.selectButton = UIBarButtonItem(title: Resources.Titles.select, style: .plain, target: self, action: #selector(selectButtonTapped(_:)))
        self.deleteButton = UIBarButtonItem(image: UIImage(systemName: Resources.Images.trash), style: .plain, target: self, action: #selector(deleteButtonTapped(_:)))
        
        self.disableDeleteButton()
        
        self.navigationItem.rightBarButtonItems = [createNoteButton,selectButton]
        
        self.notesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.notesCollectionView.showsVerticalScrollIndicator = false
        self.notesCollectionView.backgroundColor = .clear
        self.notesCollectionView.dataSource = self
        self.notesCollectionView.delegate = self
        self.notesCollectionView.register(NoteListCollectionViewCell.self, forCellWithReuseIdentifier: Resources.Cells.noteListCellIdentefier)
        self.notesCollectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            self.notesCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: UIConstants.collectionTopAnchor),
            self.notesCollectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            self.notesCollectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.notesCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - Private methods
extension MyBlogViewController {
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
            
            switch sectionNumber {
            case 0:
                return self.notesLayoutSection()
            default:
                return nil
            }
        }
    }
    
    private func notesLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
     heightDimension: .absolute(100))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
     item.contentInsets = .init(top: 0, leading: 0, bottom: 15, trailing: 15)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
     heightDimension: .estimated(500))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
      section.contentInsets.leading = 15
         return section
    }
    
    private func enableDeleteButton() {
        deleteButton.tintColor = .red
        deleteButton.isEnabled = true
    }
    
    private func disableDeleteButton() {
        deleteButton.tintColor = .gray
        deleteButton.isEnabled = false
    }
    
    private func reloadNotes() {
        DispatchQueue.main.async {
            self.notesCollectionView.reloadData()
        }
    }
}

//MARK: - Buttons methods
extension MyBlogViewController {
    
    @objc private func addNoteButtonTapped(_ sender:UIButton) {
        presenter?.userTapAddNoteButton(viewController: self)
    }
    
    @objc private func selectButtonTapped(_ sender:UIButton) {
        selectButton.title = selectButton.title == Resources.Titles.select ? Resources.Titles.unselect : Resources.Titles.select
        
        if (selectButton.title == Resources.Titles.unselect) {
            self.navigationItem.rightBarButtonItems?.append(deleteButton)
        } else {
            self.navigationItem.rightBarButtonItems?.removeLast()
            self.disableDeleteButton()
            self.presenter?.unselectAllCells()
            self.reloadNotes()
        }
    }
    
    @objc private func deleteButtonTapped(_ sender:UIButton) {
        self.presenter?.deleteNotes()
        selectButton.title = Resources.Titles.select
        self.navigationItem.rightBarButtonItems?.removeLast()
        self.disableDeleteButton()
    }
}

//MARK: - PresenterToViewProtocol
extension MyBlogViewController: PresenterToViewMyBlogProtocol {
    func onEnableDeleteButton() {
        self.enableDeleteButton()
    }
    
    func onDisableDeleteButton() {
        self.disableDeleteButton()
    }
    
    func coreDataError(text: String) {
        self.present(createInfoAlert(messageText: text, titleText: Resources.Titles.errorTitle),animated: true)
    }
    
    func reloadCollectionView() {
        self.reloadNotes()
    }
}


//MARK: - UICollectionViewDelegate
extension MyBlogViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.presenter?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.presenter?.numberOfItemsInSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.presenter?.cellForItemAt(collectionView: collectionView, indexPath: indexPath) ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.presenter?.didSelectItemAt(collectionView: collectionView, indexPath: indexPath, selectButtonTitle: selectButton.title, viewController: self)
    }
    
}


//MARK: - CreateNoteViewControllerProtocol
extension MyBlogViewController: CreateNoteViewControllerProtocol {
    func successfulyCreateNote() {
        presenter?.getNotesData(isViewDidLoad: false)
    }
}


//MARK: - NoteViewControllerProtocol
extension MyBlogViewController: NoteViewControllerProtocol {
    func successfulyEditNote() {
        presenter?.getNotesData(isViewDidLoad: false)
    }
}
