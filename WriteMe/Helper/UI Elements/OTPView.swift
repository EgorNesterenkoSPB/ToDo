import UIKit

protocol OTPViewProtocol {
    func showMainViewController()
    func showErrorAlert(errorText:String)
}

class OTPView: UIStackView {

    var textFieldArray = [OTPTextField]()
    var numberOfOTPDigit = Resources.numberOfPincodeDigit
    var pincode:String = ""
    var delegate:OTPViewProtocol?
    lazy var defaults = UserDefaults.standard
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupStackView()
        self.setTextFields()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setupStackView()
        self.setTextFields()
    }
    
    private func setupStackView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = .center
        self.distribution = .fillEqually
        self.spacing = 5
    }
    
    private func setTextFields() {
        for i in 0..<numberOfOTPDigit {
            let field = OTPTextField()
            textFieldArray.append(field)
            
            addArrangedSubview(field)
            
            field.delegate = self
            field.backgroundColor = .lightGray
            field.layer.opacity = 0.5
            field.textAlignment = .center
            field.layer.shadowColor = UIColor.black.cgColor
            field.layer.shadowOpacity = 0.1
            field.keyboardType = .asciiCapableNumberPad
            field.isSecureTextEntry = true
            
            i != 0 ? (field.previousTextField = textFieldArray[i-1]) : ()
            i != 0 ? (textFieldArray[i-1].nextTextFiled = textFieldArray[i]) : ()
        }
    }
}

extension OTPView:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let field = textField as? OTPTextField else {return true}
        
        if !string.isEmpty {
            field.text = string
            field.resignFirstResponder()
            field.nextTextFiled?.becomeFirstResponder()
            return true
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let symbol = textField.text, symbol != "" else {return}
        self.pincode += symbol
        if self.pincode.count == Resources.numberOfPincodeDigit {
            let savedPincode = defaults.string(forKey: Resources.pincodeKey)
            if savedPincode == pincode {
                self.delegate?.showMainViewController()
            }
            else {
                self.removeAllData()
                self.delegate?.showErrorAlert(errorText: "The pincode is wrong!")
            }
        }
    }
}

extension OTPView {
    private func removeAllData() {
        for field in textFieldArray {
            field.text?.removeAll()
        }
        textFieldArray[0].resignFirstResponder()
        self.pincode.removeAll()
    }
}
