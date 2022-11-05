import UIKit

final class MainViewController:BaseViewController {
    var presenter:(InteractorToPresenterMainProtocol & ViewToPresenterMainProtocol)?
    
    let tableView = UITableView()
    let bottomSheetView = BottomSheetUIView()
    let bottomBackgroundView = CustomizedShapeView()
    let circleButton = UIButton()
    let topTitle = UILabel()
    
    override func viewDidLayoutSubviews() {
        circleButton.clipsToBounds = true
        circleButton.layer.cornerRadius = circleButton.frame.width / 2
    }
}


extension MainViewController {
    override func addViews() {
        self.view.addView(bottomBackgroundView)
        self.view.addView(circleButton)
        self.view.addView(tableView)
        self.view.addView(topTitle)
    }
    
    override func configure() {
        navigationController?.navigationBar.isHidden = true
        self.view.backgroundColor = .white
        
        topTitle.text = "Today"
        topTitle.font = .boldSystemFont(ofSize: 30)
        
        circleButton.backgroundColor = .systemOrange
        circleButton.setImage(UIImage(systemName: Resources.Images.plusImage,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        circleButton.tintColor = .white
        circleButton.addTarget(self, action: #selector(addTaskButtonTapped(_:)), for: .touchUpInside)
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: Resources.Cells.taskCellIdentefier)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlerGesture(gesture: )))
        gestureRecognizer.cancelsTouchesInView = false
        bottomSheetView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            topTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor,constant: 10),
            topTitle.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor,constant: 15),
            bottomBackgroundView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            bottomBackgroundView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            bottomBackgroundView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            bottomBackgroundView.heightAnchor.constraint(equalToConstant: 55),
            tableView.topAnchor.constraint(equalTo: topTitle.bottomAnchor,constant: 10),
            tableView.bottomAnchor.constraint(equalTo: circleButton.topAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            circleButton.centerXAnchor.constraint(equalTo: bottomBackgroundView.centerXAnchor),
            circleButton.bottomAnchor.constraint(equalTo: bottomBackgroundView.bottomAnchor,constant: -20),
            circleButton.widthAnchor.constraint(equalToConstant: 70),
            circleButton.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
}


extension MainViewController {
    
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
    
//    private func configureTopButton(button:UIButton, imageName:String) {
//        button.setImage(UIImage(systemName: imageName,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
//        button.tintColor = .white
//    }
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

