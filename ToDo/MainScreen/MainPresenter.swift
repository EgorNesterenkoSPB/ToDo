import UIKit

final class MainPresenter: ViewToPresenterMainProtocol {
    var view: PresenterToViewMainProtocol?
    var router: PresenterToRouterMainProtocol?
    var interactor: PresenterToInteractorMainProtocol?
   // var sectionsData = [MainSection(sectionTitle: "Today", data: [], expandable: false),MainSection(sectionTitle: "Favorite", data: ["Test3","Test4"], expandable: false),MainSection(sectionTitle: "Projects", data: ["Test1","Test2"], expandable: false)]
    var todayProject = Project(name: "Today", categories: [Category(name: "", tasks: [Task(name: "FastAPI", description: "test description", priority: "high", time: "test time", isOverdue: false),Task(name: "2 videos OOP", description: "watch it", priority: "medium", time: "test time", isOverdue: false),Task(name: "Oruel", description: "read book", priority: "low", time: "test time", isOverdue: false)])]).self
    
    private enum UIConstants {
        static let heightHeader = 60.0
        static let heightFooter = 2.0
    }
    
    func handleBottomSheetGesture(gesture: UIPanGestureRecognizer, view: UIView, bottomSheetView: BottomSheetUIView) {
        if gesture.state == .changed {
            let translation = gesture.translation(in: view)
            
            if ((view.frame.height - bottomSheetView.center.y > 150 && translation.y < 0 ) || (view.frame.height - bottomSheetView.center.y < 0 && translation.y > 0)) {
                
            }
            else {
                gesture.view!.center = CGPoint(x: gesture.view!.center.x, y: gesture.view!.center.y + translation.y)
                gesture.setTranslation(CGPoint.zero, in: view)
            }
            
            if (view.frame.height - bottomSheetView.center.y > 150) {
                bottomSheetView.center.y = view.frame.height
                 - 150
            }
            if (view.frame.height - bottomSheetView.center.y < -0.5) {
                //bottomSheetView.center.y = self.view.frame.height
                bottomSheetView.removeFromSuperview()
            }
        }
        else if gesture.state == .ended {
            gesture.view?.center = CGPoint(x: bottomSheetView.center.x, y: bottomSheetView.center.y)
            
            UIView.animate(withDuration: 0.15, animations: {
                if (view.frame.height - bottomSheetView.center.y < 60) {
                    bottomSheetView.center.y = view.frame.height
                }
                else {
                    bottomSheetView.center.y = view.frame.height - 150
                }
            })
        }
    }
    
    func numberOfSections() -> Int {
        //sectionsData.count
        2
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
//        if sectionsData[section].expandable {
//            return sectionsData[section].data.count
//        }
//        else {
//            return 0
//        }
        var countOverdueTasks = 0
        if section == 0 {
            for task in todayProject.categories[0].tasks {
                if task.isOverdue {
                    countOverdueTasks += 1
                }
            }
            return countOverdueTasks
        }
        else {
            return todayProject.categories[0].tasks.count
        }
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.taskCellIdentefier, for: indexPath) as? TaskTableViewCell else {
            return UITableViewCell()
        }
        cell.nameTitle.text = todayProject.categories[0].tasks[indexPath.row].name
        cell.projectTitle.text = todayProject.name
        //cell.textLabel?.text = sectionsData[indexPath.section].sectionTitle
        //cell.textLabel?.text = todayProject.categories[0].tasks[indexPath.row].name
        return cell
    }
    
    func viewForHeaderInSection(tableView: UITableView, section: Int) -> UIView? {
        let headerView = UIView()
        
        let date = Date()
        let calendar = NSCalendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        
        let title:UILabel = {
           let label = UILabel()
            label.font = .boldSystemFont(ofSize: 24)
            label.text = section == 0 ? "Overdue" : "\(day).\(month) \u{2022} Today"
            return label
        }()
        headerView.addView(title)
        
        
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            title.leftAnchor.constraint(equalTo: headerView.leftAnchor,constant: 20)
        ])
        
        return headerView
//        let headerView = UIView()
//        headerView.backgroundColor = .clear
//        headerView.tag = section
//
//        let title:UILabel = {
//           let label = UILabel()
//            label.text = sectionsData[section].sectionTitle
//            label.textColor = .black
//            label.font = .boldSystemFont(ofSize: 18)
//            return label
//        }()
//        headerView.addView(title)
//
//        let addProjectButton:UIButton = {
//           let button = UIButton()
//            button.setImage(UIImage(systemName: Resources.Images.plusImage), for: .normal)
//            button.tintColor = .gray
//            button.addTarget(self, action: #selector(createProjectButtonTapped(_:)), for: .touchUpInside)
//            return button
//        }()
//        headerView.addView(addProjectButton)
//
//        let chevronImageView = UIImageView.init(image: UIImage(systemName: sectionsData[section].expandable ? Resources.Images.chevronDown : Resources.Images.chevronRight))
//        chevronImageView.tintColor = .gray
//        headerView.addView(chevronImageView)
//
//        NSLayoutConstraint.activate([
//            title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
//            title.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20),
//            chevronImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
//            chevronImageView.rightAnchor.constraint(equalTo: headerView.rightAnchor,constant: -20),
//            addProjectButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
//            addProjectButton.rightAnchor.constraint(equalTo: chevronImageView.leftAnchor, constant: -30)
//        ])
//
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(expandSection))
//        headerView.addGestureRecognizer(gesture)
//        return headerView
    }
    
    func heightForHeaderInSection() -> CGFloat {
        UIConstants.heightHeader
    }
    
    func heightForFooterInSection() -> CGFloat {
        UIConstants.heightFooter
    }
    
}

extension MainPresenter:InteractorToPresenterMainProtocol {
    
}

extension MainPresenter {
//    @objc private func expandSection(_ gesture: UITapGestureRecognizer) {
//        guard let tag = gesture.view?.tag else {return}
//        let sectionIndex = tag
//        sectionsData[sectionIndex].expandable.toggle()
//        view?.updateTableView()
//    }
    
//    @objc private func createProjectButtonTapped(_ sender:UIButton) {
//    }
}
