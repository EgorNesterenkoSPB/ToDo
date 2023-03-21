import UIKit

protocol NoteViewControllerProtocol {
    func successfulyEditNote()
}

final class NoteViewController: BaseNoteViewController {
    var delegate:NoteViewControllerProtocol?
    var presenter:(ViewToPresenterNoteProtocol & InteractorToPresenterNoteProtocol)?
}

//MARK: - VC configure
extension NoteViewController {
    
    override func configure() {
        super.configure()
        
        title = presenter?.note.name
        
        doneButton.setTitle(Resources.Titles.confirmButtonTitle, for: .normal)
        doneButton.isHidden = false
        doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        nameTextField.text = presenter?.note.name
        mainTextView.text = presenter?.note.text
        mainTextView.textColor = .darkText
    }
}

extension NoteViewController {
    private func reloadPhotosCollectionView() {
        DispatchQueue.main.async {
            self.photosCollectionView.reloadData()
        }
        super.selectPhotoButton.isHidden = self.presenter?.note.images?.count == 0 ? true : false
    }
}

//MARK: - Buttons methods
extension NoteViewController {
    @objc private func doneButtonTapped(_ sender:UIButton) {
        presenter?.confirmButtonTapped()
    }
    
    override func selectButtonTapped(sender: UIButton) {
        super.selectButtonTapped(sender: sender)
        switch super.selectPhotoButton.titleLabel?.text {
        case Resources.Titles.select:
            presenter?.unselectAllPhotos()
        default:
            break
        }
    }
    
    override func trashButtonTapped(sender: UIButton) {
        super.trashButtonTapped(sender: sender)
        self.presenter?.userTapTrashButton()
        super.selectPhotoButton.setTitle(Resources.Titles.select, for: .normal)
        super.disableTrashButton()
        super.trashButton.isHidden = true
    }
    
}


//MARK: - CollectionView methods
extension NoteViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
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
        switch super.selectPhotoButton.titleLabel?.text {
        case Resources.Titles.select:
//            super.newScrollView.delegate = self
            super.newImageView.image = presenter?.getImage(indexPath: indexPath)
            super.showPhoto()
        default:
            presenter?.didSelectItemAt(indexPath: indexPath)
        }
    }
}

//MARK: - ImagePickerDelegate
extension NoteViewController {
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        super.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
        guard let image = info[.editedImage] as? UIImage else {
            self.present(createInfoAlert(messageText:"Failed get image,try again!", titleText: Resources.Titles.errorTitle), animated: true)
            picker.dismiss(animated: true, completion: nil)
            return
        }
        presenter?.addImage(image: image)
        picker.dismiss(animated: true, completion: nil)
        self.reloadPhotosCollectionView()
    }
}

//MARK: - Texts methods
extension NoteViewController {
    
    override func textViewDidBeginEditing(_ textView: UITextView) {}
    
    override func textViewDidEndEditing(_ textView: UITextView) {
        super.textViewDidEndEditing(textView)
        presenter?.changeMainText(text: textView.text)
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        presenter?.changeNameText(text: textField.text)
    }
}


//MARK: - PresenterToViewProtocol
extension NoteViewController: PresenterToViewNoteProtocol {
    func reloadPhotoCollection() {
        self.reloadPhotosCollectionView()
    }
    
    func onEnableTrashButton() {
        super.enableTrashButton()
    }
    
    func onDisableTrashButton() {
        super.disableTrashButton()
    }
    
    func onFailedCoreData(errorText: String) {
        self.present(createInfoAlert(messageText: errorText, titleText: Resources.Titles.errorTitle), animated: true)
    }
    
    func disableDoneButtonHandling() {
        self.disableDoneButton()
    }
    
    func enableDoneButtonHandling() {
        self.enableDoneButton()
    }
    
    func onSuccessfulyEditNote() {
        self.delegate?.successfulyEditNote()
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK: - UIScrollViewDelegate
extension NoteViewController {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return super.newImageView
    }
}
