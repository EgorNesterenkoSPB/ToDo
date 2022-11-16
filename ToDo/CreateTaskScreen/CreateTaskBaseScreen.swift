import UIKit

class CreateTaskBaseController:BottomSheetController {
    private lazy var mainLabel = UILabel()
    lazy var descriptionTextView = UITextView()
    var nameTextField = UITextField()
    var createTaskButton = UIButton()
    let calendarButton = UIButton()
    let projectButton = UIButton()
    
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

}

extension CreateTaskBaseController {
    override func addViews() {
        super.addViews()
        containerView.addView(mainLabel)
        containerView.addView(descriptionTextView)
        containerView.addView(nameTextField)
        containerView.addView(createTaskButton)
        containerView.addView(calendarButton)
        containerView.addView(projectButton)
    }
    
    override func configure() {
        super.configure()
        
        mainLabel.text = Resources.Titles.bottomSheetMainLabel
        mainLabel.font = .systemFont(ofSize: UIConstants.mainLabelFont)
        mainLabel.textColor = .systemOrange
        
        descriptionTextView.text = Resources.Placeholders.textViewPlaceholder
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.font = .systemFont(ofSize: UIConstants.descriptionTextViewFont)
        descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        
        nameTextField.placeholder = Resources.Placeholders.textFieldPlaceholder
        
        createTaskButton.setImage(UIImage(systemName: Resources.Images.createTaskButtonImage,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        createTaskButton.tintColor = .gray
        createTaskButton.isEnabled = false
        
        calendarButton.setTitle("Date", for: .normal)
        calendarButton.setTitleColor(UIColor(named: Resources.Titles.labelAndTintColor), for: .normal)
        calendarButton.layer.cornerRadius = 10
        calendarButton.layer.borderColor = UIColor.gray.cgColor
        calendarButton.layer.borderWidth = 1
        calendarButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        projectButton.setTitle("Project", for: .normal)
        projectButton.setTitleColor(UIColor(named: Resources.Titles.labelAndTintColor), for: .normal)
        projectButton.layer.cornerRadius = 10
        projectButton.layer.borderColor = UIColor.gray.cgColor
        projectButton.layer.borderWidth = 1
        projectButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        
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
            createTaskButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor,constant: UIConstants.createTaskButtonTopAnchor),
            calendarButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 10),
            calendarButton.leftAnchor.constraint(equalTo: descriptionTextView.leftAnchor),
            projectButton.centerYAnchor.constraint(equalTo: calendarButton.centerYAnchor),
            projectButton.leftAnchor.constraint(equalTo: calendarButton.rightAnchor, constant: 10),
            projectButton.rightAnchor.constraint(lessThanOrEqualTo: createTaskButton.leftAnchor, constant: -10)
        ])
    }
}
