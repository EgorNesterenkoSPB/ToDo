
import UIKit

class OTPView: UIStackView {

    var textFieldArray = [OTPTextField]()
    var numberOfOTPDigit = 4
    var pincode:String = ""
    
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
        guard let symbol = textField.text else {return}
        if symbol == "" {
            for field in textFieldArray {
                field.text?.removeAll()
            }
            self.pincode.removeAll()
        }
        self.pincode += symbol
    }
}
