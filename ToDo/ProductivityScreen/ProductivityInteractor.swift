import Foundation
import Charts
import CoreData

final class ProductivityInteractor:PresenterToInteractorProductivityProtocol {
    var presenter: InteractorToPresenterProductivityProtocol?

    
    func onSetDataPieChart(pieChart: PieChartView) {
        do {
            let projects = try DataManager.shared.projects()
            var data = [ProjectBarEntity]()
            
            try projects.forEach{ project in
                guard let projectName = project.name else {return}
                var countFinishedTasks = 0
                let commonTasks = try DataManager.shared.commonTasks(project: project)
                commonTasks.forEach{ task in
                    if task.isFinished {
                        countFinishedTasks += 1
                    }
                }
                
                let categories = try DataManager.shared.categories(project: project)
                try categories.forEach{ category in
                    let categoryTasks = try DataManager.shared.tasks(category: category)
                    categoryTasks.forEach{ task in
                        if task.isFinished {
                            countFinishedTasks += 1
                        }
                    }
                }
                let projectBarEntity = ProjectBarEntity(projectName: projectName, countFinishedTasks: countFinishedTasks)
                data.append(projectBarEntity)
            }
            
            var dataEntries: [PieChartDataEntry] = []
            
            var x = 0
            data.forEach{ projectEntity in
                
                
                let dataEntry = PieChartDataEntry(value: Double(projectEntity.countFinishedTasks), label: projectEntity.projectName, data: projectEntity.projectName as AnyObject)
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
            
        } catch let error {
            self.presenter?.failureSetDataPieChart(errorText: "Failed to get data : \(error.localizedDescription)")
        }
    }
}
