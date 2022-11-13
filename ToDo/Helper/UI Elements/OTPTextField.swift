import UIKit

class OTPTextField: UITextField {
    var previousTextField: UITextField?
    var nextTextFiled: UITextField?
    
    override func deleteBackward() {
        text = ""
        previousTextField?.becomeFirstResponder()
    }
}
