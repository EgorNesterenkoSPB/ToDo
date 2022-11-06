import UIKit

final class CreateProjectViewController:BottomSheetController {
    
    let topTitle = UILabel()
    let cancelButton = UIButton()
    let confirmButton = UIButton()
    let nameTextField = UITextField()
    let favoriteSwitcher = UISwitch()
    let colorTableView = UITableView()
    let addToFavoriteLabel = UILabel()
    let favoriteIconImageView = UIImageView()
    var sectionColorData = ColorSection(data: Resources.colorsData, expandable: false)
    private var colorTableHeightConstraint:NSLayoutConstraint?
    
    private enum UIConstans {
        static let startingHexColor = "b8b8b8"
        static let tableHeight:CGFloat = 60.0
    }
}

extension CreateProjectViewController {
    override func addViews() {
        super.addViews()
        containerView.addView(topTitle)
        containerView.addView(cancelButton)
        containerView.addView(confirmButton)
        containerView.addView(nameTextField)
        containerView.addView(favoriteSwitcher)
        containerView.addView(colorTableView)
        containerView.addView(addToFavoriteLabel)
        containerView.addView(favoriteIconImageView)
    }
    
    override func configure() {
        super.configure()
        topTitle.text = Resources.Titles.createProjectTitle
        topTitle.textColor = .systemOrange
        topTitle.font = .boldSystemFont(ofSize: 25)
        
        cancelButton.setTitle(Resources.Titles.cancelButton, for: .normal)
        cancelButton.setTitleColor(.systemOrange, for: .normal)
        
        confirmButton.setTitle(Resources.Titles.confirmButtonTitle, for: .normal)
        confirmButton.setTitleColor(.systemOrange, for: .normal)
        
        favoriteIconImageView.image = UIImage(systemName: Resources.Images.heart,withConfiguration: Resources.Configurations.largeConfiguration)
        favoriteIconImageView.tintColor = .black
        
        addToFavoriteLabel.text = Resources.Titles.addToFavorite
        addToFavoriteLabel.font = .boldSystemFont(ofSize: 20)
        
        colorTableView.delegate = self
        colorTableView.dataSource = self
        colorTableView.register(ColorTableViewCell.self, forCellReuseIdentifier: Resources.Cells.colorCellIdentefier)
        colorTableView.backgroundColor = .clear
        colorTableView.showsVerticalScrollIndicator = false
        
        nameTextField.placeholder = Resources.Placeholders.textFieldPlaceholder
        nameTextField.delegate = self
        
    }
    
    override func layoutViews() {
        super.layoutViews()
        NSLayoutConstraint.activate([
            topTitle.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            topTitle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            cancelButton.centerYAnchor.constraint(equalTo: topTitle.centerYAnchor),
            cancelButton.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: 20),
            confirmButton.centerYAnchor.constraint(equalTo: cancelButton.centerYAnchor),
            confirmButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
            nameTextField.topAnchor.constraint(equalTo: topTitle.bottomAnchor,constant: 20),
            nameTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: 10),
            nameTextField.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: -10),
            nameTextField.heightAnchor.constraint(equalToConstant: 30),
            colorTableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,constant: 5),
            colorTableView.leftAnchor.constraint(equalTo: nameTextField.leftAnchor),
            colorTableView.rightAnchor.constraint(equalTo: nameTextField.rightAnchor),
            favoriteIconImageView.topAnchor.constraint(equalTo: colorTableView.bottomAnchor,constant: 5),
            favoriteIconImageView.leftAnchor.constraint(equalTo: nameTextField.leftAnchor),
            addToFavoriteLabel.centerYAnchor.constraint(equalTo: favoriteIconImageView.centerYAnchor),
            addToFavoriteLabel.leftAnchor.constraint(equalTo: favoriteIconImageView.rightAnchor,constant: 20),
            favoriteSwitcher.centerYAnchor.constraint(equalTo: favoriteIconImageView.centerYAnchor),
            favoriteSwitcher.rightAnchor.constraint(equalTo: nameTextField.rightAnchor)
        ])
        colorTableHeightConstraint = colorTableView.heightAnchor.constraint(equalToConstant: UIConstans.tableHeight)
        colorTableHeightConstraint?.isActive = true
    }
}

//MARK: - TableViewMethods
extension CreateProjectViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionColorData.expandable {
            return sectionColorData.data.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.colorCellIdentefier, for: indexPath) as? ColorTableViewCell else {
            return UITableViewCell()
        }
        cell.title.text = sectionColorData.data[indexPath.row].name
        cell.colorCircleImageView.tintColor = UIColor(hexString: sectionColorData.data[indexPath.row].hex)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = ColorHeaderView(hexColor: UIConstans.startingHexColor, expandable: sectionColorData.expandable)
        headerView.delegate = self
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UIConstans.tableHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        2
    }
    
}

extension CreateProjectViewController:UITextFieldDelegate {
    
}

extension CreateProjectViewController:ColorHeaderViewProtocol {
    func updateExpandable() {
        sectionColorData.expandable.toggle()
        if sectionColorData.expandable {
            self.colorTableHeightConstraint?.constant = 150
        }
        else {
            self.colorTableHeightConstraint?.constant = UIConstans.tableHeight
        }
        view.layoutIfNeeded()
        DispatchQueue.main.async {
            self.colorTableView.reloadData()
        }
    }
    
    
}
