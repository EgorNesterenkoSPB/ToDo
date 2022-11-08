import UIKit

final class CreateProjectPresenter:ViewToPresenterCreateProjectProtocol{
    var view: PresenterToViewCreateProjectProtocol?
    var router: PresenterToRouterCreateProjectProtocol?
    var interactor: PresenterToInteractorCreateProjectProtocol?
    var headerCircleImageColor = UIColor(hexString: "b8b8b8")
    var projectName:String = "" // to store project name
    
    func numberOfRowsInSection(sectionColorData:ColorSection) -> Int {
        if sectionColorData.expandable {
            return sectionColorData.data.count
        }
        else {
            return 0
        }
    }
    
    func cellForRowAt(tableView: UITableView, indexPath: IndexPath,sectionColorData:ColorSection) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.colorCellIdentefier, for: indexPath) as? ColorTableViewCell else {
            return UITableViewCell()
        }
        cell.title.text = sectionColorData.data[indexPath.row].name
        cell.colorCircleImageView.tintColor = UIColor(hexString: sectionColorData.data[indexPath.row].hex)
        return cell
    }
    
    func didSelectRowAt(tableView:UITableView,indexPath:IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ColorTableViewCell else {return}
        self.headerCircleImageColor = cell.colorCircleImageView.tintColor
    }
    
    func numberOfSections() -> Int {
        1
    }
    
    func viewForHeaderInSection(createProjectViewController:CreateProjectViewController,sectionColorData:ColorSection) -> UIView? {
        let headerView = ColorHeaderView(color: self.headerCircleImageColor, expandable: sectionColorData.expandable)
        headerView.delegate = createProjectViewController
        return headerView
    }
    
    func textFieldDidEndEditing(textField: UITextField, confirmButton: UIButton) {
        guard let text = textField.text, text != "" && text != " " else {return}
        confirmButton.setTitleColor(.systemOrange, for: .normal)
        confirmButton.isEnabled = true
        self.projectName = text
    }
}

extension CreateProjectPresenter:InteractorToPresenterCreateProjectProtocol {
}
