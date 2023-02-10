import UIKit

class BaseViewController:UIViewController {
    
    private enum UIConstants {
        static let textFieldFont = 15.0
        static let textFieldCornerRadius = 6.0
        static let labelFont = 13.0
        static let confirmButtonCornerRadius = 13.0
    }
    
    override func viewDidLoad() {
        self.addViews()
        self.layoutViews()
        self.configure()
    }
}


@objc extension BaseViewController {
    func addViews() {}
    func layoutViews() {}
    func configure() {
        self.view.backgroundColor = .systemBackground
        
    }
    
    func configureTextField(textField:UITextField,placeholderText:String, isSecury:Bool = false) {
        textField.isSecureTextEntry = isSecury
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.placeholderText ]
)
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = UIConstants.textFieldCornerRadius
        textField.font = UIFont.systemFont(ofSize: UIConstants.textFieldFont)
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.backgroundColor = UIColor(named: Resources.textFieldBackColor)
    }
    
    func configureLabel(label:UILabel, text:String) {
        label.text = text
        label.textColor = .systemOrange
        label.font = .boldSystemFont(ofSize: UIConstants.labelFont)
    }
    
    func configureConfirmButton(confirmButton:UIButton) {
        confirmButton.setTitle(Resources.Titles.confirmButtonTitle, for: .normal)
        confirmButton.layer.masksToBounds = true
        confirmButton.isEnabled = false
        confirmButton.layer.cornerRadius = UIConstants.confirmButtonCornerRadius
        confirmButton.backgroundColor = .gray
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
    }
}
