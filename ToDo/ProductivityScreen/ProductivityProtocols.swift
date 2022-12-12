import UIKit
import Charts

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterProductivityProtocol {
    var view: PresenterToViewProductivityProtocol? {get set}
    var router: PresenterToRouterProductivityProtocol? {get set}
    var interactor: PresenterToInteractorProductivityProtocol? {get set}
    func setDataPieChart(pieChart:PieChartView)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewProductivityProtocol {
    func failedGetCoreData(errorText:String)
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorProductivityProtocol {
    var presenter:InteractorToPresenterProductivityProtocol? {get set}
    func onSetDataPieChart(pieChart:PieChartView)
}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterProductivityProtocol {
    func failureSetDataPieChart(errorText:String)
}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterProductivityProtocol {
    static func createModule() -> ProductivityViewController

}
