import UIKit

final class MainViewController:BaseViewController {
    var presenter:(InteractorToPresenterMainProtocol & ViewToPresenterMainProtocol)?
    
    let tableView = UITableView()
    let bottomSheetView = BottomSheetUIView()
    let addTaskButton = UIButton()
    let profileButton = UIButton()
    let settingsButton = UIButton()
    let topBackgroundView = UIView()
}


extension MainViewController {
    override func addViews() {
        self.view.addView(tableView)
        self.view.addView(topBackgroundView)
        topBackgroundView.addView(profileButton)
        topBackgroundView.addView(addTaskButton)
        topBackgroundView.addView(settingsButton)
    }
    
    override func configure() {
        navigationController?.navigationBar.isHidden = true
        
        topBackgroundView.backgroundColor = .systemOrange
        
        self.configureTopButton(button: profileButton, imageName: Resources.Images.profileImage)
        self.configureTopButton(button: addTaskButton, imageName: Resources.Images.plusImage)
        self.configureTopButton(button: settingsButton, imageName: Resources.Images.settingsImage)
        addTaskButton.addTarget(self, action: #selector(addTaskButtonTapped(_:)), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Resources.Cells.mainCell)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlerGesture(gesture: )))
        gestureRecognizer.cancelsTouchesInView = false
        bottomSheetView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            topBackgroundView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            topBackgroundView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            topBackgroundView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            topBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            profileButton.centerYAnchor.constraint(equalTo: topBackgroundView.centerYAnchor),
            profileButton.rightAnchor.constraint(equalTo: topBackgroundView.rightAnchor, constant: -10),
            addTaskButton.centerYAnchor.constraint(equalTo: profileButton.centerYAnchor),
            addTaskButton.rightAnchor.constraint(equalTo: profileButton.leftAnchor, constant: -10),
            settingsButton.centerYAnchor.constraint(equalTo: profileButton.centerYAnchor),
            settingsButton.leftAnchor.constraint(equalTo: topBackgroundView.leftAnchor, constant: 10),
            tableView.topAnchor.constraint(equalTo: topBackgroundView.bottomAnchor,constant: 10),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
        ])
    }
}


extension MainViewController {
    @objc private func profileButtonTapped(_ sender:UIButton) {
        
    }
    
    @objc private func addTaskButtonTapped(_ sender:UIButton) {
        self.activateBottomSheet()
    }
    
    @objc private func handlerGesture(gesture:UIPanGestureRecognizer) {
        presenter?.handleBottomSheetGesture(gesture: gesture, view: self.view, bottomSheetView: bottomSheetView)
    }
}

extension MainViewController {
    private func activateBottomSheet() {
        self.view.addView(bottomSheetView)
        NSLayoutConstraint.activate([
            bottomSheetView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            bottomSheetView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 2),
            bottomSheetView.heightAnchor.constraint(equalToConstant: 400),
            bottomSheetView.topAnchor.constraint(equalTo: self.view.bottomAnchor,constant: -400)
        ])
    }
    
    private func configureTopButton(button:UIButton, imageName:String) {
        button.setImage(UIImage(systemName: imageName,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        button.tintColor = .white
    }
}

extension MainViewController:PresenterToViewMainProtocol {
    func updateTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - TableViewMethods
extension MainViewController:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfRowsInSection(section: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.cellForRowAt(tableView: tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        presenter?.viewForHeaderInSection(tableView: tableView, section: section) ?? UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        presenter?.heightForHeaderInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        presenter?.heightForFooterInSection() ?? 0
    }
    
}

