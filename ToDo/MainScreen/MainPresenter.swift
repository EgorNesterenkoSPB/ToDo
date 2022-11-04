import UIKit

final class MainPresenter: ViewToPresenterMainProtocol {
    var view: PresenterToViewMainProtocol?
    var router: PresenterToRouterMainProtocol?
    var interactor: PresenterToInteractorMainProtocol?
    var sectionsData = [MainSection(sectionTitle: "Today", data: [], expandable: false),MainSection(sectionTitle: "Favorite", data: ["Test3","Test4"], expandable: false),MainSection(sectionTitle: "Projects", data: ["Test1","Test2"], expandable: false)]
    
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
        sectionsData.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if sectionsData[section].expandable {
            return sectionsData[section].data.count
        }
        else {
            return 0
        }
    }
    
    func cellForRowAt(tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Resources.Cells.mainCell, for: indexPath)
        cell.textLabel?.text = sectionsData[indexPath.section].sectionTitle
        return cell
    }
    
    func viewForHeaderInSection(tableView: UITableView, section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .white
        headerView.tag = section
        
        let title:UILabel = {
           let label = UILabel()
            label.text = sectionsData[section].sectionTitle
            label.textColor = .black
            label.font = .boldSystemFont(ofSize: 18)
            return label
        }()
        headerView.addView(title)
        
        let addProjectButton:UIButton = {
           let button = UIButton()
            button.setImage(UIImage(systemName: Resources.Images.plusImage), for: .normal)
            button.tintColor = .gray
            return button
        }()
        headerView.addView(addProjectButton)
        
        let chevronImageView = UIImageView.init(image: UIImage(systemName: sectionsData[section].expandable ? Resources.Images.chevronDown : Resources.Images.chevronRight))
        chevronImageView.tintColor = .gray
        headerView.addView(chevronImageView)
        
        let deviderTopView:UIView = {
           let view = UIView()
            view.backgroundColor = .lightGray
            return view
        }()
        headerView.addView(deviderTopView)
        
        NSLayoutConstraint.activate([
            deviderTopView.topAnchor.constraint(equalTo: headerView.topAnchor),
            deviderTopView.heightAnchor.constraint(equalToConstant: 1),
            deviderTopView.leftAnchor.constraint(equalTo: headerView.leftAnchor),
            deviderTopView.rightAnchor.constraint(equalTo: headerView.rightAnchor),
            title.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            title.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 20),
            chevronImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            chevronImageView.rightAnchor.constraint(equalTo: headerView.rightAnchor,constant: -20),
            addProjectButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            addProjectButton.rightAnchor.constraint(equalTo: chevronImageView.leftAnchor, constant: -30)
        ])
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(expandSection))
        headerView.addGestureRecognizer(gesture)
        
        return headerView
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
    @objc private func expandSection(_ gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else {return}
        let sectionIndex = tag
        sectionsData[sectionIndex].expandable.toggle()
        view?.updateTableView()
    }
}
