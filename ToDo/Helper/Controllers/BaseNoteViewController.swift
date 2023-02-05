import UIKit

class BaseNoteViewController: BaseViewController {
    
    let nameTextField = UITextField()
    let mainTextView = UITextView()
    let addPhotoButton = UIButton()
    let photosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let closeButton = UIButton()
    let doneButton = UIButton()
    
    private enum UIConstants {
        static let textViewCornerRadius = 12.0
        static let nameTextFieldHeight = 50.0
        static let textViewHeight = UIScreen.main.bounds.height / 3
        static let photosCollectionTopAnchor = 10.0
        static let leftAndRightTopButtonAnchor = 15.0
        static let nameTextFieldTopAnchor = 20.0
        static let nameTextFieldLeftAndRightAnchor = 10.0
        static let textViewTopAnchor = 15.0
        static let addPhotoTopAnchor = 10.0
    }
}

//MARK: - VC configure
extension BaseNoteViewController {
    override func addViews() {
        self.view.addView(closeButton)
        self.view.addView(doneButton)
        self.view.addView(nameTextField)
        self.view.addView(mainTextView)
        self.view.addView(addPhotoButton)
        self.view.addView(photosCollectionView)
    }
    
    override func configure() {
        super.configure()
        
        closeButton.setTitle(Resources.Titles.close, for: .normal)
        closeButton.setTitleColor(.systemOrange, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
        
        self.disableDoneButton()
        self.doneButton.isHidden = true
        
        self.photosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.photosCollectionView.showsVerticalScrollIndicator = false
        self.photosCollectionView.backgroundColor = .clear
        self.photosCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: Resources.Cells.photoCellIdentefier)
        self.photosCollectionView.collectionViewLayout = createCompositionalLayout()
        
        nameTextField.placeholder = Resources.Titles.name
        nameTextField.borderStyle = UITextField.BorderStyle.roundedRect
        nameTextField.autocorrectionType = UITextAutocorrectionType.no
        nameTextField.keyboardType = .default
        nameTextField.returnKeyType = UIReturnKeyType.done
        nameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        nameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        nameTextField.delegate = self
        
        mainTextView.text = Resources.Placeholders.noteTextViewPlaceholder
        mainTextView.keyboardType = .default
        mainTextView.contentInsetAdjustmentBehavior = .automatic
        mainTextView.adjustsFontForContentSizeCategory = true
        mainTextView.textAlignment = NSTextAlignment.justified
        mainTextView.autocorrectionType = .no
        mainTextView.backgroundColor = .secondarySystemBackground
        mainTextView.layer.cornerRadius = UIConstants.textViewCornerRadius
        mainTextView.textColor = UIColor.placeholderText
        mainTextView.font = .systemFont(ofSize: 15)
        mainTextView.delegate = self
        mainTextView.addDoneButton(title: Resources.Titles.done, target: self, selector: #selector(doneTextViewButtonTapped(_:)))
        
        addPhotoButton.setTitle(Resources.Titles.addPhoto, for: .normal)
        addPhotoButton.setTitleColor(.link, for: .normal)
        addPhotoButton.addTarget(self, action: #selector(addPhotoButtonTapped), for: .touchUpInside)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.leftAndRightTopButtonAnchor),
            closeButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.leftAndRightTopButtonAnchor),
            doneButton.topAnchor.constraint(equalTo: self.closeButton.topAnchor),
            doneButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.leftAndRightTopButtonAnchor),
            nameTextField.topAnchor.constraint(equalTo: self.closeButton.bottomAnchor,constant: UIConstants.nameTextFieldTopAnchor),
            nameTextField.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: UIConstants.nameTextFieldLeftAndRightAnchor),
            nameTextField.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -UIConstants.nameTextFieldLeftAndRightAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: UIConstants.nameTextFieldHeight),
            mainTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: UIConstants.textViewTopAnchor),
            mainTextView.leftAnchor.constraint(equalTo: nameTextField.leftAnchor),
            mainTextView.rightAnchor.constraint(equalTo: nameTextField.rightAnchor),
            mainTextView.heightAnchor.constraint(equalToConstant: UIConstants.textViewHeight),
            addPhotoButton.topAnchor.constraint(equalTo: mainTextView.bottomAnchor,constant: UIConstants.addPhotoTopAnchor),
            addPhotoButton.leftAnchor.constraint(equalTo: mainTextView.leftAnchor),
            photosCollectionView.topAnchor.constraint(equalTo: addPhotoButton.bottomAnchor, constant: UIConstants.photosCollectionTopAnchor),
            photosCollectionView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            photosCollectionView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - Buttons methods
extension BaseNoteViewController {
    @objc func closeButtonTapped(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneTextViewButtonTapped(_ sender:UIButton) {
        self.view.endEditing(true)
    }
    
    @objc func addPhotoButtonTapped(_ sender:UIButton) {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Take photo", style: .default, handler: { (action:UIAlertAction) -> Void in
            // it will be crashed on simulator device, bc commented !!!
//            picker.sourceType = .camera
//            self.present(picker,animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Choose from photo gallery", style: .default, handler: { (action:UIAlertAction) -> Void in
            self.present(picker,animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: Resources.Titles.close, style: .cancel, handler: nil))
        self.present(alert,animated: true)
    }
}

//MARK: - Private functions
extension BaseNoteViewController {
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
                                              heightDimension: .absolute(150))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 15, trailing: 15)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = 15
        return section
    }
    
    public func disableDoneButton() {
        self.doneButton.isEnabled = false
        self.doneButton.setTitleColor(.gray, for: .normal)
    }
    
    public func enableDoneButton() {
        self.doneButton.isEnabled = true
        self.doneButton.setTitleColor(.systemOrange, for: .normal)
    }
}

//MARK: - TextViewDelegate
extension BaseNoteViewController:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor.darkText
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Resources.Placeholders.noteTextViewPlaceholder
            textView.textColor = UIColor.placeholderText
        }
    }
}

//MARK: - TextFieldDelegate
extension BaseNoteViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {}
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - ImagePickerDelegate
extension BaseNoteViewController:UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {}
}
