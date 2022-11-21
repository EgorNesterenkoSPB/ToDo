import UIKit

class CreateTaskBaseController:BottomSheetController {
    private lazy var mainLabel = UILabel()
    lazy var descriptionTextView = UITextView()
    var nameTextField = UITextField()
    var createTaskButton = UIButton()
    let dateTextField = UITextField()
    let timeTextField = UITextField()
    let dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = .current
        return formatter
    }()
    let timeFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    let projectButton = UIButton()
    
    private enum UIConstants {
        static let mainLabelFont = 24.0
        static let descriptionTextViewFont = 15.0
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
        static let projectButtonWidth = 100.0
    }

}

extension CreateTaskBaseController {
    override func addViews() {
        super.addViews()
        containerView.addView(mainLabel)
        containerView.addView(descriptionTextView)
        containerView.addView(nameTextField)
        containerView.addView(createTaskButton)
        containerView.addView(dateTextField)
        containerView.addView(timeTextField)
        containerView.addView(projectButton)
    }
    
    override func configure() {
        super.configure()
        
        mainLabel.text = Resources.Titles.bottomSheetMainLabel
        mainLabel.font = .systemFont(ofSize: UIConstants.mainLabelFont)
        mainLabel.textColor = .systemOrange
        
        descriptionTextView.text = Resources.Placeholders.textViewPlaceholder
        descriptionTextView.textColor = UIColor.placeholderText
        descriptionTextView.font = .systemFont(ofSize: UIConstants.descriptionTextViewFont)
        descriptionTextView.delegate = self

        nameTextField.placeholder = Resources.Placeholders.textFieldPlaceholder
        nameTextField.delegate = self
        
        createTaskButton.setImage(UIImage(systemName: Resources.Images.createTaskButtonImage,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        createTaskButton.tintColor = .gray
        createTaskButton.isEnabled = false
        
        projectButton.setTitle("Project", for: .normal)
        projectButton.setTitleColor(UIColor(named: Resources.Titles.labelAndTintColor), for: .normal)
        projectButton.layer.cornerRadius = 10
        projectButton.layer.borderColor = UIColor.gray.cgColor
        projectButton.layer.borderWidth = 1
        projectButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        projectButton.addTarget(self, action: #selector(projectButtonTapped(_:)), for: .touchUpInside)
        
//        let date = Date()
        dateTextField.text = "Set date"
//        dateTextField.text = dateFormatter.string(from: date)
        dateTextField.textColor = .link
        dateTextField.tintColor = .clear //to remove cursor when tapped
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        
        timeTextField.text = "Set time"
//        timeTextField.text = timeFormatter.string(from: date)
        timeTextField.textColor = .link
        timeTextField.tintColor = .clear
        
        let timePicker = UIDatePicker()
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timeChanged(_:)), for: .valueChanged)
        timeTextField.inputView = timePicker
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
            dateTextField.centerYAnchor.constraint(equalTo: projectButton.centerYAnchor),
            dateTextField.leftAnchor.constraint(equalTo: projectButton.rightAnchor,constant: 20),
            projectButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor,constant: 10),
            projectButton.leftAnchor.constraint(equalTo: descriptionTextView.leftAnchor),
            projectButton.widthAnchor.constraint(equalToConstant: UIConstants.projectButtonWidth),
            timeTextField.centerYAnchor.constraint(equalTo: projectButton.centerYAnchor),
            timeTextField.leftAnchor.constraint(equalTo: dateTextField.rightAnchor,constant: 20)
        ])
    }
}

extension CreateTaskBaseController {
    
    @objc private func projectButtonTapped(_ sender:UIButton) {

    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        self.dateTextField.text = dateFormatter.string(from: sender.date)
    }
    
    @objc private func timeChanged(_ sender: UIDatePicker) {
        self.timeTextField.text = timeFormatter.string(from: sender.date)
    }
}

extension CreateTaskBaseController:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.placeholderText {
            textView.text = nil
            textView.textColor = UIColor(named: Resources.Titles.labelAndTintColor)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = Resources.Placeholders.textViewPlaceholder
            textView.textColor = UIColor.placeholderText
        }
    }
}

extension CreateTaskBaseController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, text.isEmpty != true && text != " " else {return}
            createTaskButton.tintColor = .systemOrange
            createTaskButton.isEnabled = true
    }
}
