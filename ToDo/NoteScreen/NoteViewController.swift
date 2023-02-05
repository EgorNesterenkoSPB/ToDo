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
    }
}

//MARK: - Buttons methods
extension NoteViewController {
    @objc private func doneButtonTapped(_ sender:UIButton) {
        presenter?.confirmButtonTapped()
    }
}


//MARK: - CollectionView methods
extension NoteViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.numberOfItemsInSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        self.presenter?.cellForItemAt(collectionView: collectionView, indexPath: indexPath) ?? UICollectionViewCell()
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
