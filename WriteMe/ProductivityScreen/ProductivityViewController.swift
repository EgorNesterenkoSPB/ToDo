import UIKit
import Charts
import FSCalendar

class ProductivityViewController: BaseViewController {

    var presenter: (ViewToPresenterProductivityProtocol & InteractorToPresenterProductivityProtocol)?
    let pieChart = PieChartView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var contentHeightConstraint:NSLayoutConstraint?
    let calendar = FSCalendar()
    var calendarHeightConstraint:NSLayoutConstraint!
    let showHideCalendarButton = UIButton()
    let lineChartView = LineChartView()
    
    private enum UIConstants {
        static let chartsHeight = UIScreen.main.bounds.height / 2
        static let calendarMonthHeight = 300.0
        static let calendarWeekHeight = 122.5
        static let pieChartTopAnchor = 10.0
        static let lineChartTopAnchor = 10.0
        static let showHideHeightButton = 40.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.viewDidLoad()
    }
}

extension ProductivityViewController {
    override func addViews() {
        self.view.addView(scrollView)
        scrollView.addSubview(contentView)
        contentView.addView(pieChart)
        contentView.addView(calendar)
        contentView.addView(showHideCalendarButton)
        contentView.addView(lineChartView)
    }
    
    override func configure() {
        super.configure()
        title = Resources.Titles.productivity
        
        scrollView.showsVerticalScrollIndicator = false
        
        pieChart.noDataText = Resources.Titles.pieChartNoData
        pieChart.centerText = Resources.Titles.pieChartCenterText
        pieChart.holeColor = .systemBackground
        
        let pieChartLegend = pieChart.legend
        pieChartLegend.horizontalAlignment = .right
        pieChartLegend.verticalAlignment = .top
        pieChartLegend.orientation = .vertical
        pieChartLegend.xEntrySpace = 7
        pieChartLegend.yEntrySpace = 0
        pieChartLegend.yOffset = 0
        
        pieChart.entryLabelColor = .white
        pieChart.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
                
        calendar.delegate = self
        calendar.dataSource = self
        calendar.scope = .week
        calendar.locale = Locale.current
        calendar.allowsMultipleSelection = true
        calendar.appearance.eventOffset = CGPoint(x: 0, y: -7)
        calendar.appearance.headerTitleColor = UIColor(named: Resources.Titles.labelAndTintColor)
        calendar.appearance.weekdayTextColor = UIColor(named: Resources.Titles.labelAndTintColor)
        calendar.appearance.titleDefaultColor = UIColor(named: Resources.Titles.labelAndTintColor)
        calendar.today = nil // Hide the today circle
        calendar.appearance.selectionColor = .systemOrange
        
        showHideCalendarButton.setTitle(Resources.Titles.openCalendar, for: .normal)
        showHideCalendarButton.setTitleColor(.gray, for: .normal)
        showHideCalendarButton.titleLabel?.font = UIFont(name: Resources.avenirFontName, size: 14)
        showHideCalendarButton.addTarget(self, action: #selector(showHideCalendarButtonTapped(sender:)), for: .touchUpInside)
        
        lineChartView.legend.enabled = false
        lineChartView.noDataText = "No data for this dates"
        let lineChartXAxis = lineChartView.xAxis
        lineChartXAxis.labelPosition = .bottom
        lineChartXAxis.drawGridLinesEnabled = false
    }
    
    override func layoutViews() {
        
        calendarHeightConstraint = NSLayoutConstraint(item: calendar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant:UIConstants.calendarMonthHeight)
        calendar.addConstraint(calendarHeightConstraint)
        
        contentHeightConstraint = contentView.heightAnchor.constraint(equalToConstant:UIConstants.chartsHeight + calendarHeightConstraint.constant + UIConstants.showHideHeightButton +  UIConstants.pieChartTopAnchor + UIConstants.lineChartTopAnchor + UIConstants.chartsHeight)
        contentHeightConstraint?.isActive = true
        
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            calendar.topAnchor.constraint(equalTo: contentView.topAnchor),
            calendar.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            calendar.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            showHideCalendarButton.topAnchor.constraint(equalTo: calendar.bottomAnchor),
            showHideCalendarButton.leftAnchor.constraint(equalTo: calendar.leftAnchor, constant: 10),
            showHideCalendarButton.heightAnchor.constraint(equalToConstant: UIConstants.showHideHeightButton),
            lineChartView.topAnchor.constraint(equalTo:showHideCalendarButton.bottomAnchor,constant:UIConstants.lineChartTopAnchor),
            lineChartView.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 10),
            lineChartView.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10),
            lineChartView.heightAnchor.constraint(equalToConstant: UIConstants.chartsHeight),
            pieChart.topAnchor.constraint(equalTo: lineChartView.bottomAnchor,constant: UIConstants.pieChartTopAnchor),
            pieChart.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            pieChart.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            pieChart.heightAnchor.constraint(equalToConstant: UIConstants.chartsHeight),
            pieChart.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])

    }
    
}

extension ProductivityViewController {
    private func setInitialDates() {
        
        let gregorian = Calendar(identifier: .gregorian)
        
        let dates = [
            gregorian.date(byAdding: .day, value: -1, to: Date()),
            Date(),
        ]
        dates.forEach { (date) in
            if let date = date {
                self.presenter?.performDateSelection(calendar, date: date, lineChart: lineChartView)
            }
        }
    }
}

extension ProductivityViewController {
    @objc private func showHideCalendarButtonTapped(sender: UIButton) {
        self.presenter?.editeCalendarHeight(calendar: calendar, showHideButton: showHideCalendarButton)
    }
}

//MARK: - PresenterToView

extension ProductivityViewController:PresenterToViewProductivityProtocol {
    func onSuccessfulyGetTasks() {
        self.presenter?.setDataPieChart(pieChart: pieChart)
        self.setInitialDates()
    }
    
    func failedGetCoreData(errorText: String) {
        self.present(createInfoAlert(messageText: errorText, titleText: Resources.Titles.errorTitle), animated: true)
    }
}

//MARK: - Calendar Methods

extension ProductivityViewController:FSCalendarDataSource,FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.presenter?.performDateSelection(calendar, date: date, lineChart: lineChartView)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.presenter?.performDateDeselect(calendar, date: date, lineChart: lineChartView)
    }
    
}
