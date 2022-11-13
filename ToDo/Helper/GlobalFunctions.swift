import UIKit

func createErrorAlert(errorText:String) -> UIAlertController {
    let alert = UIAlertController(title: Resources.Titles.errorTitle, message: errorText, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: Resources.Titles.errorActionTitle, style: .default, handler: nil))
    return alert
}

 func getDocumentsDirectory() -> URL {
     let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
     return paths[0]
}
