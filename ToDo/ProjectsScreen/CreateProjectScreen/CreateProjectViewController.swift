import UIKit

protocol CreateProjectViewControllerProtocol {
    func refreshView()
}

class CreateProjectViewController:BottomSheetController {
    
    let topTitle = UILabel()
    let cancelButton = UIButton()
    let confirmButton = UIButton()
    let nameTextField = UITextField()
    let favoriteSwitcher = UISwitch()
    let colorTableView = UITableView()
    let addToFavoriteLabel = UILabel()
    let favoriteIconImageView = UIImageView()
    let favoriteHorizontallStackView = UIStackView()
    private var colorTableHeightConstraint:NSLayoutConstraint?
    private var colorTableBottomConstraint:NSLayoutConstraint?
    private var favoriteHorizontalStackViewTopConstraint:NSLayoutConstraint?
    private var favoriteHorizontalStackViewBottomConstraint:NSLayoutConstraint?
    var presenter:(ViewToPresenterCreateProjectProtocol & InteractorToPresenterCreateProjectProtocol)?
    var delegate:CreateProjectViewControllerProtocol?
    var sectionColorData = ColorSection(data: Resources.colorsData, expandable: false)
    
    private enum UIConstans {
        static let tableHeight:CGFloat = 60.0
    }
}

extension CreateProjectViewController {
    override func addViews() {
        super.addViews()
        containerView.addView(favoriteHorizontallStackView)
        containerView.addView(topTitle)
        containerView.addView(cancelButton)
        containerView.addView(confirmButton)
        containerView.addView(nameTextField)
        containerView.addView(colorTableView)
        favoriteHorizontallStackView.addArrangedSubview(favoriteIconImageView)
        favoriteHorizontallStackView.addArrangedSubview(addToFavoriteLabel)
        favoriteHorizontallStackView.addArrangedSubview(favoriteSwitcher)
    }
    
    override func configure() {
        super.configure()
        
        favoriteHorizontallStackView.axis = NSLayoutConstraint.Axis.horizontal
        favoriteHorizontallStackView.distribution = UIStackView.Distribution.equalSpacing
        favoriteHorizontallStackView.alignment = UIStackView.Alignment.center
        favoriteHorizontallStackView.spacing = 10
        
        topTitle.text = Resources.Titles.createProjectTitle
        topTitle.textColor = .systemOrange
        topTitle.font = .boldSystemFont(ofSize: 25)
        
        cancelButton.setTitle(Resources.Titles.cancelButton, for: .normal)
        cancelButton.setTitleColor(.systemOrange, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        confirmButton.setTitle(Resources.Titles.confirmButtonTitle, for: .normal)
        confirmButton.setTitleColor(.gray, for: .normal)
        confirmButton.isEnabled = false
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        favoriteIconImageView.image = UIImage(systemName: Resources.Images.heart,withConfiguration: Resources.Configurations.largeConfiguration)
        favoriteIconImageView.tintColor = .black
        
        addToFavoriteLabel.text = Resources.Titles.addToFavorite
        addToFavoriteLabel.font = .boldSystemFont(ofSize: 20)
        
        colorTableView.delegate = self
        colorTableView.dataSource = self
        colorTableView.register(ColorTableViewCell.self, forCellReuseIdentifier: Resources.Cells.colorCellIdentefier)
        colorTableView.backgroundColor = .clear
        colorTableView.showsVerticalScrollIndicator = false
        colorTableView.tableFooterView = UIView()
        
        if #available(iOS 15.0, *) {
            colorTableView.sectionHeaderTopPadding = 0
        }
        
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
            colorTableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor,constant: 10),
            colorTableView.leftAnchor.constraint(equalTo: nameTextField.leftAnchor),
            colorTableView.rightAnchor.constraint(equalTo: nameTextField.rightAnchor),
            favoriteHorizontallStackView.leftAnchor.constraint(equalTo: nameTextField.leftAnchor),
            favoriteHorizontallStackView.rightAnchor.constraint(equalTo: nameTextField.rightAnchor)
        ])
        colorTableHeightConstraint = colorTableView.heightAnchor.constraint(equalToConstant: UIConstans.tableHeight)
        colorTableHeightConstraint?.isActive = true
        favoriteHorizontalStackViewTopConstraint = favoriteHorizontallStackView.topAnchor.constraint(equalTo: colorTableView.bottomAnchor,constant:0)
        favoriteHorizontalStackViewTopConstraint?.isActive = true
    }
}

extension CreateProjectViewController {
    @objc private func cancelButtonTapped(_ sender:UIButton) {
        super.animateDismissView()
    }
    
    @objc private func confirmButtonTapped(_ sender:UIButton) {
        presenter?.createProject(isFavorite: favoriteSwitcher.isOn)
    }
}

//MARK: - TableViewMethods
extension CreateProjectViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRowsInSection(sectionColorData: self.sectionColorData) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.cellForRowAt(tableView: tableView, indexPath: indexPath, sectionColorData: self.sectionColorData) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(tableView: tableView, indexPath: indexPath)
        self.updateExpandable()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return presenter?.viewForHeaderInSection(createProjectViewController: self, sectionColorData: self.sectionColorData)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UIConstans.tableHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        2
    }
    
}

//MARK: - TextFieldMethods
extension CreateProjectViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        presenter?.textFieldDidEndEditing(textField: textField, confirmButton: confirmButton)
    }
}


//MARK: - ColorHeaderViewProtocol
extension CreateProjectViewController:ColorHeaderViewProtocol {
    func updateExpandable() {
        sectionColorData.expandable.toggle()
        if sectionColorData.expandable {
            favoriteHorizontalStackViewTopConstraint?.isActive = false
            favoriteHorizontalStackViewBottomConstraint = favoriteHorizontallStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
            favoriteHorizontalStackViewBottomConstraint?.isActive = true
            self.colorTableHeightConstraint?.isActive = false
            self.colorTableBottomConstraint = colorTableView.bottomAnchor.constraint(equalTo: favoriteHorizontallStackView.topAnchor)
            self.colorTableBottomConstraint?.isActive = true
        }
        else {
            favoriteHorizontalStackViewTopConstraint?.isActive = true
            favoriteHorizontalStackViewBottomConstraint?.isActive = false
            self.colorTableBottomConstraint?.isActive = false
            self.colorTableHeightConstraint?.isActive = true
        }
        view.layoutIfNeeded()
        DispatchQueue.main.async {
            self.colorTableView.reloadData()
        }
    }
}

extension CreateProjectViewController:PresenterToViewCreateProjectProtocol {
    func onFailureCreateProject(errorText: String) {
        present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func onSuccessulyCreateProject() {
        delegate?.refreshView()
        super.animateDismissView()
    }
    
}
