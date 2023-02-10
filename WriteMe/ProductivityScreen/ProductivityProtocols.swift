import UIKit
import Charts
import FSCalendar

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterProductivityProtocol {
    var view: PresenterToViewProductivityProtocol? {get set}
    var router: PresenterToRouterProductivityProtocol? {get set}
    var interactor: PresenterToInteractorProductivityProtocol? {get set}
    func setDataPieChart(pieChart:PieChartView)
    func editeCalendarHeight(calendar: FSCalendar, showHideButton: UIButton)
    func performDateSelection(_ calendar: FSCalendar,date:Date,lineChart: LineChartView)
    func performDateDeselect(_ calendar: FSCalendar, date: Date,lineChart: LineChartView)
    func viewDidLoad()
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewProductivityProtocol {
    func failedGetCoreData(errorText:String)
    func onSuccessfulyGetTasks()
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorProductivityProtocol {
    var presenter:InteractorToPresenterProductivityProtocol? {get set}
    func onSetDataPieChart(pieChart:PieChartView)
    func onConfigureDataLineChart(lineChart:LineChartView,dates:[Date],dateFormatter:DateFormatter)
    func getTasks()
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterProductivityProtocol {
    func failureSetDataPieChart(errorText:String)
    func failureSetDataLineChart(errorText:String)
    func failureGetCoreData(errorText:String)
    func successfulyGetTasks()
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterProductivityProtocol {
    static func createModule() -> ProductivityViewController

}
