import Foundation
import Charts
import FSCalendar

final class ProductivityPresenter:ViewToPresenterProductivityProtocol {

    var view: PresenterToViewProductivityProtocol?
    var router: PresenterToRouterProductivityProtocol?
    var interactor: PresenterToInteractorProductivityProtocol?
    private var datesRange: [Date]?
    // first date in the range
    private var firstDate: Date?
    // last date in the range
    private var lastDate: Date?
    let dateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = .current
        return formatter
    }()
    
    func viewDidLoad() {
        self.interactor?.getTasks()
    }
    
    func performDateSelection(_ calendar: FSCalendar,date:Date,lineChart: LineChartView) {
        let stringDate = dateFormatter.string(from: date)
        guard let formattedDate = dateFormatter.date(from: stringDate) else {return}
        // nothing selected:
        if firstDate == nil {
            firstDate = formattedDate
            datesRange = [formattedDate]
            return
        }

        // only first date is selected:
        if let firstDate = firstDate, lastDate == nil {
            // handle the case of if the last date is less than the first date:
            if formattedDate <= firstDate {
                calendar.deselect(firstDate)
                self.firstDate = formattedDate
                datesRange = [firstDate]
                return
            }

            let range = datesRange(from: firstDate, to: formattedDate)
            lastDate = range.last

            for d in range {
                calendar.select(d)
            }

            datesRange = range
            self.interactor?.onConfigureDataLineChart(lineChart: lineChart, dates: datesRange ?? [], dateFormatter: dateFormatter)
            return
        }

        // both are selected:
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []
        }
    }
    
    func performDateDeselect(_ calendar: FSCalendar, date: Date,lineChart: LineChartView) {
        if firstDate != nil && lastDate != nil {
            for d in calendar.selectedDates {
                calendar.deselect(d)
            }

            lastDate = nil
            firstDate = nil

            datesRange = []
        }
    }
    
    private func datesRange(from: Date, to: Date) -> [Date] {
        if from > to { return [Date]() }
        var tempDate = from
        var array = [tempDate]
        while tempDate < to {
            tempDate = Calendar.current.date(byAdding: .day, value: 1, to: tempDate)!
            array.append(tempDate)
        }
        return array
    }
    
    func setDataPieChart(pieChart: PieChartView) {
        interactor?.onSetDataPieChart(pieChart: pieChart)
    }
    
    func configureDataLineChart(lineChart: LineChartView, dates: [Date]) {
        self.interactor?.onConfigureDataLineChart(lineChart: lineChart, dates: dates, dateFormatter: dateFormatter)
    }
    
    func editeCalendarHeight(calendar: FSCalendar, showHideButton: UIButton) {
        if calendar.scope == .week {
            calendar.setScope(.month, animated: true)
            showHideButton.setTitle(Resources.Titles.hideCalendar, for: .normal)
        } else {
            calendar.setScope(.week, animated: true)
            showHideButton.setTitle(Resources.Titles.openCalendar, for: .normal)
        }
    }
    
}

extension ProductivityPresenter:InteractorToPresenterProductivityProtocol {
    func failureGetCoreData(errorText: String) {
        self.view?.failedGetCoreData(errorText: errorText)
    }
    
    func successfulyGetTasks() {
        self.view?.onSuccessfulyGetTasks()
    }
    
    func failureSetDataLineChart(errorText: String) {
        self.view?.failedGetCoreData(errorText: errorText)
    }
    
    func failureSetDataPieChart(errorText: String) {
        self.view?.failedGetCoreData(errorText: errorText)
    }
    
    
}
