import UIKit

final class SignInPopOverViewController: BaseViewController {

    let contentTableView = UITableView()
    var contentTableHeight:NSLayoutConstraint?
    
    private enum UIConstants {
        static let contentTableHeight = 100.0
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.contentTableHeight?.constant = self.contentTableView.contentSize.height
    }
}

extension SignInPopOverViewController {
    override func addViews() {
        self.view.addView(contentTableView)
    }
    
    override func configure() {
        super.configure()
        contentTableView.delegate = self
        contentTableView.dataSource = self
        contentTableView.register(UITableViewCell.self, forCellReuseIdentifier: Resources.Cells.popOverCellIdentegfier)
        contentTableView.backgroundColor = .clear
        contentTableView.tableFooterView = UIView()
        contentTableView.separatorStyle = .none
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            contentTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            contentTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            contentTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
        ])
        contentTableHeight = contentTableView.heightAnchor.constraint(equalToConstant: UIConstants.contentTableHeight)
        contentTableHeight?.isActive = true
    }
    
}

extension SignInPopOverViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.popOverCellIdentegfier, for: indexPath)
        cell.textLabel?.text = Resources.Titles.forgotPassword
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: - show restore password screen
    }
}


