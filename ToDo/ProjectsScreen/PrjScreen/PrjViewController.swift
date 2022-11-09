import UIKit

final class PrjViewController:BaseViewController {
    
    let categoriesTableView = UITableView()
    let topTitle = UILabel()
    var presenter:(ViewToPresenterPrjProtocol & InteractorToPresenterPrjProtocol)?
    private var project:ProjectCoreData
    
    init(project:ProjectCoreData) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getCategories(project: self.project)
    }
}

extension PrjViewController {
    override func addViews() {
        self.view.addView(topTitle)
        self.view.addView(categoriesTableView)
    }
    
    override func configure() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: Resources.Titles.projectsSection, style: .plain, target: nil, action: nil)
        title = project.name
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped(_:)))
        navigationItem.rightBarButtonItems = [addButton]
    
        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: Resources.Cells.categoryIdentefier)
        categoriesTableView.separatorStyle = .none
        categoriesTableView.tableFooterView = UIView()
        
        topTitle.font = .boldSystemFont(ofSize: 23)
        topTitle.text = Resources.Titles.categoriesTitle
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            topTitle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            topTitle.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            categoriesTableView.topAnchor.constraint(equalTo: topTitle.bottomAnchor,constant: 10),
            categoriesTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            categoriesTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            categoriesTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor)
        ])
        
    }
}

extension PrjViewController {
    @objc private func addButtonTapped(_ sender:UIButton) {
        guard let alert = presenter?.showCreateCategoryAlert(project: project) else {return}
        self.present(alert,animated: true)
    }
}

//MARK: - PresenterToView
extension PrjViewController:PresenterToViewPrjProtocol {
    func onFailedCreateCategory(errorText: String) {
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func failedGetCoreData(errorText: String) {
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.categoriesTableView.reloadData()
        }
    }
    
    
}

//MARK: - TableViewMethods
extension PrjViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.cellForRowAt(tableView: tableView, indexPath: indexPath) ?? UITableViewCell()
    }
}
