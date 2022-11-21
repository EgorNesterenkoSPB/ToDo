import UIKit

protocol ColorsViewControllerProtocol {
    func getColor(hexColor:String,project:ProjectCoreData)
}

final class ColorsViewController:BaseViewController {
    let colorTableView = UITableView()
    let project:ProjectCoreData
    var delegate:ColorsViewControllerProtocol?
    
    init(project:ProjectCoreData) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ColorsViewController {
    override func addViews() {
        self.view.addView(colorTableView)
    }
    
    override func configure() {
        colorTableView.delegate = self
        colorTableView.dataSource = self
        colorTableView.register(ColorTableViewCell.self, forCellReuseIdentifier: Resources.Cells.colorCellIdentefier)
        colorTableView.backgroundColor = .clear
        colorTableView.showsVerticalScrollIndicator = false
        colorTableView.tableFooterView = UIView()
        
        if #available(iOS 15.0, *) {
            colorTableView.sectionHeaderTopPadding = 0
        }
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            colorTableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            colorTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            colorTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            colorTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension ColorsViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Resources.colorsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.colorCellIdentefier, for: indexPath) as? ColorTableViewCell else {
            return UITableViewCell()
        }
        cell.title.text = Resources.colorsData[indexPath.row].name
        cell.colorCircleImageView.tintColor = UIColor(hexString: Resources.colorsData[indexPath.row].hex)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ColorTableViewCell else {return}
        self.delegate?.getColor(hexColor: cell.colorCircleImageView.tintColor.toHexString(),project: self.project)
        self.dismiss(animated: true, completion: nil)
    }
    
}

