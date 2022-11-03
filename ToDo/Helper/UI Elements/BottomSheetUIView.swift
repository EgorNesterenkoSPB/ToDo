import UIKit

class BottomSheetUIView: UIView {

    private lazy var mainLabel:UILabel = {
       let label = UILabel()
        label.text = Resources.Titles.bottomSheetMainLabel
        label.font = .systemFont(ofSize: UIConstants.mainLabelFont)
        label.textColor = .systemOrange
        return label
    }()
    
    private lazy var descriptionTextView:UITextView = {
       let textView = UITextView()
        textView.text = Resources.Placeholders.textViewPlaceholder
        textView.textColor = UIColor.lightGray
        textView.layer.borderWidth = 1
        textView.font = .systemFont(ofSize: UIConstants.descriptionTextViewFont)
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.delegate = self
        return textView
    }()
    
    private var nameTextField:UITextField = {
       let textField = UITextField()
        textField.placeholder = Resources.Placeholders.textFieldPlaceholder
        return textField
    }()
    
    private var createTaskButton:UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: Resources.Images.createTaskButtonImage,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        button.tintColor = .systemOrange
        return button
    }()
    
    private enum UIConstants {
        static let mainLabelFont = 24.0
        static let descriptionTextViewFont = 18.0
        static let viewCornerRadius = 40.0
        static let mainLabelTopAnchor = 10.0
        static let nameTextFieldTopAnchor = 15.0
        static let nameTextFieldHeight = 30.0
        static let nameTextFieldLeftAnchor = 5.0
        static let nameTextFieldRightAnchor = -5.0
        static let descriptionTextFieldTopAnchor = 10.0
        static let descriptionTextFieldLeftAnchor = 5.0
        static let descriptionTextFieldRightAnchor = -5.0
        static let descriptionHeightAnchor = 100.0
        static let createTaskButtonTopAnchor = 20.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViewHierarchy()
        setupViewAttributes()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewHierarchy() {
        self.addView(mainLabel)
        self.addView(descriptionTextView)
        self.addView(nameTextField)
        self.addView(createTaskButton)
    }
    
    func setupViewAttributes() {
        self.backgroundColor = .white
        self.layer.cornerRadius = UIConstants.viewCornerRadius
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func setupLayout() {
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: UIConstants.mainLabelTopAnchor),
            nameTextField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor,constant: UIConstants.nameTextFieldTopAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: UIConstants.nameTextFieldHeight),
            nameTextField.rightAnchor.constraint(equalTo: self.rightAnchor,constant: UIConstants.nameTextFieldRightAnchor),
            nameTextField.leftAnchor.constraint(equalTo: self.leftAnchor, constant: UIConstants.nameTextFieldLeftAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: UIConstants.descriptionTextFieldTopAnchor),
            descriptionTextView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: UIConstants.descriptionTextFieldRightAnchor),
            descriptionTextView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: UIConstants.descriptionTextFieldLeftAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: UIConstants.descriptionHeightAnchor),
            createTaskButton.rightAnchor.constraint(equalTo: descriptionTextView.rightAnchor),
            createTaskButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor,constant: UIConstants.createTaskButtonTopAnchor)
        ])
    }
}

extension BottomSheetUIView:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Resources.Placeholders.textViewPlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}

