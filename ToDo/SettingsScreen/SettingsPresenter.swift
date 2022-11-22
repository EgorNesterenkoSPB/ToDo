import UIKit
import MessageUI

final class SettingsPresenter:ViewToPresenterSettingsProtocol {

    var view: PresenterToViewSettingsProtocol?
    var router: PresenterToRouterSettingsProtocol?
    var interactor: PresenterToInteractorSettingsProtocol?
    lazy var defaults = UserDefaults.standard
    
    func viewDidLoad(themeSwitcher: UISwitch) {
        let isDark = defaults.bool(forKey: Resources.isDarkKeyTheme)
        if isDark {
            themeSwitcher.isOn = true
        }
        else {
            themeSwitcher.isOn = false
        }
    }
    
    func switchTheme(isOn: Bool) {
        interactor?.onSwitchTheme(isOn: isOn)
    }
    
    func userTapProfileView(navigationController: UINavigationController?) {
        router?.showProfileScreen(navigationController: navigationController)
    }
    
    func cellForRowAt(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let model = Resources.settingsContent[indexPath.section].options[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.commonTableCellIdentefier, for: indexPath) as? CommonTableViewCell else {return UITableViewCell()}
        cell.setup(with: model)
        return cell
    }
    
    func didSelectRowAt(indexPath: IndexPath,settingsViewController:SettingsViewController) {
        var model = Resources.settingsContent[indexPath.section].options[indexPath.row]
        
        switch model.title {
        case Resources.Titles.account:
            model.handler = { [weak self] in
                self?.userTapProfileView(navigationController:settingsViewController.navigationController)
            }
        case Resources.Titles.writeInSupport:
            model.handler = {
                guard MFMailComposeViewController.canSendMail() else {
                    settingsViewController.present(createInfoAlert(messageText: Resources.Titles.mailServiceError, titleText: Resources.Titles.errorTitle),animated: true)
                    return
                }
                let composer = self.createMailComposer(targetDelegate: settingsViewController)
                settingsViewController.present(composer,animated: true)
            }
        default:
            break
        }
        model.handler()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            controller.present(createInfoAlert(messageText: error.localizedDescription, titleText: Resources.Titles.errorTitle),animated: true)
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        switch result {
        case .cancelled:
            break
        case .saved:
            controller.present(createInfoAlert(messageText: Resources.Titles.successSavedLetter, titleText: Resources.Titles.errorTitle),animated: true)
        case .sent:
            controller.present(createInfoAlert(messageText: Resources.Titles.successSendLetter, titleText: Resources.Titles.errorTitle),animated: true)
        case .failed:
            controller.present(createInfoAlert(messageText: Resources.Titles.failedSendLetter, titleText: Resources.Titles.errorTitle),animated: true)
            return
        @unknown default:
            controller.present(createInfoAlert(messageText: Resources.Titles.unknownError, titleText: Resources.Titles.errorTitle),animated: true)
        }
        controller.dismiss(animated: true, completion: nil)
    }
    
}

extension SettingsPresenter {
    private func createMailComposer(targetDelegate:SettingsViewController) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = targetDelegate
        composer.setToRecipients([Resources.supportMail])
        composer.setSubject(Resources.mailSubject)
        composer.setMessageBody("", isHTML: false)
        return composer
    }
}

extension SettingsPresenter:InteractorToPresenterSettingsProtocol {
    
}
