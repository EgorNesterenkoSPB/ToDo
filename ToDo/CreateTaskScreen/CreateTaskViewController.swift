import UIKit

protocol CreateTaskViewControllerProtocol {
    func refreshView(category:CategoryCoreData,section:Int)
}

final class CreateTaskViewController:BottomSheetController {
    private lazy var mainLabel = UILabel()
    private lazy var descriptionTextView = UITextView()
    private var nameTextField = UITextField()
    private var createTaskButton = UIButton()
    var presenter:(InteractorToPresenterCreateTaskProtocol & ViewToPresenterCreateTaskProtocol)?
    let category:CategoryCoreData
    var delegate:CreateTaskViewControllerProtocol?
    let section:Int
    
    private enum UIConstants {
        static let mainLabelFont = 24.0
        static let descriptionTextViewFont = 18.0
        static let viewCornerRadius = 40.0
        static let mainLabelTopAnchor = 10.0
        static let nameTextFieldTopAnchor = 15.0
        static let nameTextFieldHeight = 35.0
        static let nameTextFieldLeftAnchor = 5.0
        static let nameTextFieldRightAnchor = -5.0
        static let descriptionTextFieldTopAnchor = 10.0
        static let descriptionTextFieldLeftAnchor = 5.0
        static let descriptionTextFieldRightAnchor = -5.0
        static let descriptionHeightAnchor = 100.0
        static let createTaskButtonTopAnchor = 20.0
    }
    
    init(section:Int,category:CategoryCoreData) {
        self.category = category
        self.section = section
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateTaskViewController {
    override func addViews() {
        super.addViews()
        containerView.addView(mainLabel)
        containerView.addView(descriptionTextView)
        containerView.addView(nameTextField)
        containerView.addView(createTaskButton)
    }
    
    override func configure() {
        super.configure()

        nameTextField.delegate = self
        
        mainLabel.text = Resources.Titles.bottomSheetMainLabel
        mainLabel.font = .systemFont(ofSize: UIConstants.mainLabelFont)
        mainLabel.textColor = .systemOrange
        
        descriptionTextView.text = Resources.Placeholders.textViewPlaceholder
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.font = .systemFont(ofSize: UIConstants.descriptionTextViewFont)
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        descriptionTextView.delegate = self
        
        nameTextField.placeholder = Resources.Placeholders.textFieldPlaceholder
        
        createTaskButton.setImage(UIImage(systemName: Resources.Images.createTaskButtonImage,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        createTaskButton.tintColor = .gray
        createTaskButton.isEnabled = false
        createTaskButton.addTarget(self, action: #selector(createTaskButtonTapped), for: .touchUpInside)
    }
    
    override func layoutViews() {
        super.layoutViews()
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: UIConstants.mainLabelTopAnchor),
            nameTextField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor,constant: UIConstants.nameTextFieldTopAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: UIConstants.nameTextFieldHeight),
            nameTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: UIConstants.nameTextFieldRightAnchor),
            nameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: UIConstants.nameTextFieldLeftAnchor),
            descriptionTextView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: UIConstants.descriptionTextFieldTopAnchor),
            descriptionTextView.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: UIConstants.descriptionTextFieldRightAnchor),
            descriptionTextView.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: UIConstants.descriptionTextFieldLeftAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: UIConstants.descriptionHeightAnchor),
            createTaskButton.rightAnchor.constraint(equalTo: descriptionTextView.rightAnchor),
            createTaskButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor,constant: UIConstants.createTaskButtonTopAnchor)
        ])
    }
}

extension CreateTaskViewController {
    @objc private func createTaskButtonTapped(_ sender: UIButton) {
        presenter?.createTask(category: self.category)
    }
}

extension CreateTaskViewController:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        presenter?.textViewDidBeginEditing(textView: textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        presenter?.textViewDidEndEditing(textView: textView)
    }
}

extension CreateTaskViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter?.textFieldDidEndEditing(textField: textField, createTaskButton: createTaskButton)
    }
}

extension CreateTaskViewController:PresenterToViewCreateTaskProtocol {
    func onFailedCreateTask(errorText: String) {
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func onSuccessfulyCreateTask() {
        self.delegate?.refreshView(category: self.category, section: self.section)
        super.animateDismissView()
    }
}
