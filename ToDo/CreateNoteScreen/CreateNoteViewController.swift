import UIKit

protocol CreateNoteViewControllerProtocol {
    func successfulyCreateNote()
}

final class CreateNoteViewController: BaseNoteViewController {
    var delegate:CreateNoteViewControllerProtocol?
    var presenter: (ViewToPresenterCreateNoteProtocol & InteractorToPresenterCreateNoteProtocol)?
}

//MARK: - VC configure
extension CreateNoteViewController {
    
    override func configure() {
        super.configure()
        doneButton.setTitle(Resources.Titles.createNote, for: .normal)
        doneButton.isHidden = false
        doneButton.addTarget(self, action: #selector(doneButtonTapped(_:)), for: .touchUpInside)
        
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
    }
}

//MARK: - Buttons methods
extension CreateNoteViewController {
    @objc private func doneButtonTapped(_ sender:UIButton) {
        presenter?.createNote()
    }
}

//MARK: - Texts methods
extension CreateNoteViewController {
    override func textViewDidEndEditing(_ textView: UITextView) {
        super.textViewDidEndEditing(textView)
        presenter?.setMainText(text: textView.text)
    }
    
    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        presenter?.setName(text: textField.text)
    }
}

//MARK: - ImagePickerDelegate
extension CreateNoteViewController {
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        super.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
        guard let image = info[.editedImage] as? UIImage else {
            self.present(createInfoAlert(messageText: "Failed get image,try again!", titleText:Resources.Titles.errorTitle), animated: true)
            picker.dismiss(animated: true, completion: nil)
            return
        }
        presenter?.setImage(image: image)
        picker.dismiss(animated: true, completion: nil)
        self.reloadPhotosCollectionView()
    }
}

//MARK: - CollectionDelegate
extension CreateNoteViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.numberOfItemsInSection() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        presenter?.cellForItemAt(collectionView: collectionView, indexPath: indexPath) ?? UICollectionViewCell()
    }
}

//MARK: - Private methods
extension CreateNoteViewController {
    private func reloadPhotosCollectionView() {
        DispatchQueue.main.async {
            self.photosCollectionView.reloadData()
        }
    }
}

//MARK: - PresenterToViewMethods
extension CreateNoteViewController:PresenterToViewCreateNoteProtocol {
    func onSuccessfulyCreateNote() {
        self.delegate?.successfulyCreateNote()
        self.dismiss(animated: true)
    }
    
    func onDisableDoneButtonHandling() {
        self.disableDoneButton()
    }
    
    func onEnableDoneButtonHandling() {
        self.enableDoneButton()
    }
    
    func onFailedCoreData(errorText: String) {
        self.present(createInfoAlert(messageText: errorText, titleText: Resources.Titles.errorTitle),animated: true)
    }
}
