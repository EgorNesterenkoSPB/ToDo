import UIKit
import Charts

class ProductivityViewController: BaseViewController {

    var presenter: (ViewToPresenterProductivityProtocol & InteractorToPresenterProductivityProtocol)?
    let pieChart = PieChartView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var contentHeightConstraint:NSLayoutConstraint?
    
}

extension ProductivityViewController {
    override func addViews() {
        self.view.addView(scrollView)
        scrollView.addSubview(contentView)
        contentView.addView(pieChart)
    }
    
    override func configure() {
        super.configure()
        self.presenter?.setDataPieChart(pieChart: pieChart)
        pieChart.noDataText = Resources.Titles.pieChartNoData
        pieChart.centerText = Resources.Titles.pieChartCenterText
        pieChart.holeColor = .systemBackground
        let l = pieChart.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        pieChart.entryLabelColor = .white
        pieChart.entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
        scrollView.showsVerticalScrollIndicator = false
        
    }
    
    override func layoutViews() {
        
        contentHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: pieChart.frame.height)
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
            pieChart.topAnchor.constraint(equalTo: contentView.topAnchor),
            pieChart.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            pieChart.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            pieChart.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2),
        ])
    }
    
}

extension ProductivityViewController:PresenterToViewProductivityProtocol {
    func failedGetCoreData(errorText: String) {
        self.present(createInfoAlert(messageText: Resources.Titles.errorTitle, titleText: errorText), animated: true)
    }
}
