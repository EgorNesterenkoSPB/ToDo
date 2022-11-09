import UIKit

func createErrorAlert(errorText:String) -> UIAlertController {
    let alert = UIAlertController(title: Resources.Titles.errorTitle, message: errorText, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: Resources.Titles.errorActionTitle, style: .default, handler: nil))
    return alert
}
