import Foundation
import Charts

final class ProductivityPresenter:ViewToPresenterProductivityProtocol {
    var view: PresenterToViewProductivityProtocol?
    var router: PresenterToRouterProductivityProtocol?
    var interactor: PresenterToInteractorProductivityProtocol?
    
    func setDataPieChart(pieChart: PieChartView) {
        interactor?.onSetDataPieChart(pieChart: pieChart)
    }
    
}

extension ProductivityPresenter:InteractorToPresenterProductivityProtocol {
    func failureSetDataPieChart(errorText: String) {
        self.view?.failedGetCoreData(errorText: errorText)
    }
    
    
}
