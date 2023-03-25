import UIKit
import FSCalendar

class CalendarViewController: BaseViewController {
    
    var presenter: (ViewToPresenterCalendarProtocol & InteractorToPresenterCalendarProtocol)?
    let tasksTableView = UITableView()
    let noDataLabel = UILabel()
    private var calendar = FSCalendar()
    var calendarHeightConstraint:NSLayoutConstraint!
    let showHideCalendarButton = UIButton()
    
    private enum UIConstants {
        static let calendarHeight = 300.0
        static let noDataLabelFont = 17.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.getTasks(date: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.getCurrentDateTasks()
    }
}

extension CalendarViewController {
    
    override func addViews() {
        self.view.addView(calendar)
        self.view.addView(showHideCalendarButton)
        self.view.addView(tasksTableView)
        self.view.addView(noDataLabel)
    }
    
    override func configure() {
        super.configure()
        title = Resources.Titles.calendar
        
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .week
        calendar.locale = Locale.current
        calendar.appearance.headerTitleColor = UIColor(named: Resources.Titles.labelAndTintColor)
        calendar.appearance.weekdayTextColor = UIColor(named: Resources.Titles.labelAndTintColor)
        calendar.appearance.titleDefaultColor = UIColor(named: Resources.Titles.labelAndTintColor)
        calendar.appearance.selectionColor = .systemOrange
        calendar.appearance.todayColor = .systemOrange
        
        showHideCalendarButton.setTitle(Resources.Titles.openCalendar, for: .normal)
        showHideCalendarButton.setTitleColor(.gray, for: .normal)
        showHideCalendarButton.titleLabel?.font = UIFont(name: Resources.avenirFontName, size: 14)
        showHideCalendarButton.addTarget(self, action: #selector(showHideCalendarButtonTapped(sender:)), for: .touchUpInside)
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(handleCalendarSwipe(gesture:)))
        swipeUp.direction = .up
        calendar.addGestureRecognizer(swipeUp)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleCalendarSwipe(gesture:)))
        swipeDown.direction = .down
        calendar.addGestureRecognizer(swipeDown)
        
        tasksTableView.backgroundColor = .clear
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.register(TaskTableViewCell.self, forCellReuseIdentifier: Resources.Cells.taskCellIdentefier)
        tasksTableView.tableFooterView = UIView()
        tasksTableView.separatorStyle = .none
        
        noDataLabel.font = .systemFont(ofSize: UIConstants.noDataLabelFont)
        noDataLabel.text = Resources.Titles.noTasksForThisDate
        noDataLabel.isHidden = true
    }
    
    override func layoutViews() {
        
        calendarHeightConstraint = NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIConstants.calendarHeight)
        calendar.addConstraint(calendarHeightConstraint)
        
        NSLayoutConstraint.activate([
            calendar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            calendar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            calendar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            showHideCalendarButton.topAnchor.constraint(equalTo: calendar.bottomAnchor, constant: 0),
            showHideCalendarButton.leftAnchor.constraint(equalTo: calendar.leftAnchor, constant: 10),
            tasksTableView.topAnchor.constraint(equalTo: showHideCalendarButton.bottomAnchor),
            tasksTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            tasksTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            noDataLabel.topAnchor.constraint(equalTo: showHideCalendarButton.bottomAnchor, constant: 20),
            noDataLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
}

extension CalendarViewController {
    @objc private func showHideCalendarButtonTapped(sender: UIButton) {
        self.presenter?.editeCalendarHeight(calendar: calendar, showHideButton: showHideCalendarButton)
    }
    
    @objc private func handleCalendarSwipe(gesture:UISwipeGestureRecognizer) {
        self.presenter?.editeCalendarHeight(calendar: calendar, showHideButton: showHideCalendarButton)
    }
}

//MARK: - FSCalender methods

extension CalendarViewController:FSCalendarDataSource,FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar.today != nil {
            calendar.today = nil
        }
        self.presenter?.updateTasksDay(date: date)
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        self.presenter?.numberOfEvents(date: date) ?? 0
    }
}

//MARK: - Table view methods

extension CalendarViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = presenter?.numberOfRowsInSection(section: section) ?? 0
        self.noDataLabel.isHidden = numberOfRows == 0 ? false : true
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.cellForRowAt(tableView: tableView, cellForRowAt: indexPath) ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRowAt(tableView: tableView, indexPath: indexPath, calendarViewController:self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        presenter?.trailingSwipeActionsConfigurationForRowAt(tableView: tableView, indexPath: indexPath, calendarViewController: self)
    }
}


//MARK: - PresenterToView

extension CalendarViewController:PresenterToViewCalendarProtocol {
    func onFailureCoreData(errorText: String) {
        self.present(createInfoAlert(messageText: Resources.Titles.errorTitle, titleText: errorText),animated: true)
    }
    
    func onFailureGetTasks(errorText: String) {
        self.present(createInfoAlert(messageText: Resources.Titles.errorTitle, titleText: errorText),animated: true)
    }
    
    func updateTableView() {
        DispatchQueue.main.async {
            self.tasksTableView.reloadData()
            self.calendar.reloadData()
        }
    }
}

extension CalendarViewController:TaskViewControllerProtocol {
    func refreshView() {
        self.presenter?.getCurrentDateTasks()
    }
}
