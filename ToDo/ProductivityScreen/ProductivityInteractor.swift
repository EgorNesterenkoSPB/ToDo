import Foundation
import Charts
import CoreData

final class ProductivityInteractor:PresenterToInteractorProductivityProtocol {
    
    var presenter: InteractorToPresenterProductivityProtocol?
    var commonTasks:[CommonTaskCoreData]?
    var categoryTasks:[TaskCoreData]?
    
    func getTasks() {
        do {
            let projects = try DataManager.shared.projects()
            var _commonTasks = [CommonTaskCoreData]()
            var _categoryTasks = [TaskCoreData]()
            
            try projects.forEach{ project in
                let commonTasks = try DataManager.shared.commonTasks(project: project)
                commonTasks.forEach{ commonTask in
                    _commonTasks.append(commonTask)
                }
                
                let categories = try DataManager.shared.categories(project: project)
                try categories.forEach{ category in
                    let categoryTasks = try DataManager.shared.tasks(category: category)
                    categoryTasks.forEach{ categoryTask in
                        _categoryTasks.append(categoryTask)
                    }
                }
            }
            self.commonTasks = _commonTasks
            self.categoryTasks = _categoryTasks
            self.presenter?.successfulyGetTasks()
        } catch let error {
            self.presenter?.failureGetCoreData(errorText: error.localizedDescription)
        }
    }
    
    func onConfigureDataLineChart(lineChart: LineChartView, dates: [Date],dateFormatter:DateFormatter) {
        guard let commonTasks = commonTasks, let categoryTasks = categoryTasks else {
            self.presenter?.failureSetDataLineChart(errorText: "Failed to get data for this dates, try again!")
            return
        }
        
        var datesData:[String:Int] = [:]
        commonTasks.forEach{ task in
            if let dateFinished = task.timeFinished {
                dates.forEach{ date in
                    if isSameDate(firstDate: dateFinished, secondDate: date) {
                        datesData[dateFormatter.string(from: dateFinished),default:0] += 1
                    }
                }
            }
        }
        
        categoryTasks.forEach { task in
            if let dateFinished = task.timeFinished {
                dates.forEach{ date in
                    if isSameDate(firstDate: dateFinished, secondDate: date) {
                        datesData[dateFormatter.string(from: dateFinished),default:0] += 1
                    }
                }
            }
        }
        
        guard datesData.count != 0 else {
            lineChart.data = nil
            lineChart.notifyDataSetChanged()
            return
        }
        
        var sortedDataDates = [DateTasksEntity]()
        datesData.forEach{ dateData in
            let newDateCountTasksEntity = DateTasksEntity(date: dateData.key, countFinishedTasks: dateData.value)
            sortedDataDates.append(newDateCountTasksEntity)
        }
        
        sortedDataDates.sort {
            guard let firstDate = dateFormatter.date(from: $0.date), let secondDate = dateFormatter.date(from: $1.date) else {return false}
            return firstDate < secondDate
        }
        
        var dataEntries = [ChartDataEntry]()
        
        for (x,dateData) in sortedDataDates.enumerated() {
            dataEntries.append(ChartDataEntry(x: Double(x), y: Double(dateData.countFinishedTasks)))
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "")
        lineChartDataSet.axisDependency = .left
        lineChartDataSet.setColor(UIColor.black)
        lineChartDataSet.setCircleColor(UIColor.blue)
        lineChartDataSet.lineWidth = 1.0
        lineChartDataSet.circleRadius = 3.0 // the radius of the node circle
        lineChartDataSet.fillAlpha = 1
        lineChartDataSet.fillColor = UIColor.black
        lineChartDataSet.highlightColor = UIColor.white
        lineChartDataSet.drawCircleHoleEnabled = true
        
        var dataSets = [LineChartDataSet]()
        dataSets.append(lineChartDataSet)
        
        let lineChartData = LineChartData(dataSets: dataSets)
        lineChart.data = lineChartData
        
        let stringsXAxisData = sortedDataDates.map{ dateData -> String in
            var xAxisString = dateData.date
            xAxisString.insert("\n", at: xAxisString.index(xAxisString.startIndex, offsetBy: 5))
            return xAxisString
        }
        
        lineChart.xAxis.setLabelCount(stringsXAxisData.count, force: false)
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: stringsXAxisData)
        lineChart.notifyDataSetChanged()
    }
    
    
    func onSetDataPieChart(pieChart: PieChartView) {
        
        guard let commonTasks = commonTasks,let categoryTasks = categoryTasks else {
            self.presenter?.failureSetDataPieChart(errorText: "Failed to get data, try again!")
            return
        }
        
        var data:[String:Int] = [:]
        
        commonTasks.forEach{ task in
            if let projectName = task.project?.name,task.isFinished {
                data[projectName,default: 0] += 1
            }
        }
        
        categoryTasks.forEach{ task in
            if let projectName = task.category?.project?.name,task.isFinished {
                data[projectName,default:0] += 1
            }
        }
        
        guard data.count != 0 else {return}
        
        var dataEntries: [PieChartDataEntry] = []
        
        var x = 0
        data.forEach{ projectEntity in
            
            let dataEntry = PieChartDataEntry(value: Double(projectEntity.value), label: projectEntity.key, data: projectEntity.key as AnyObject)
            dataEntries.append(dataEntry)
            x += 1
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: Resources.Titles.projectsSection)
        pieChartDataSet.drawIconsEnabled = false
        pieChartDataSet.sliceSpace = 2
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        pieChartData.setValueFont(.systemFont(ofSize: 11, weight: .light))
        pieChartData.setValueTextColor(.black)
        
        pieChart.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<data.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        
        pieChart.animate(xAxisDuration: 1.4, easingOption: .easeInQuad)
        pieChart.highlightValues(nil)
    }
}
