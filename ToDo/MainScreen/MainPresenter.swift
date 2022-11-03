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
        let sectionHeaderButton = UIButton()
        sectionHeaderButton.setTitle(sectionsData[section].sectionTitle, for: .normal)
        sectionHeaderButton.setTitleColor(.black, for: .normal)
        sectionHeaderButton.layer.borderWidth = 1
        sectionHeaderButton.layer.borderColor = UIColor.lightGray.cgColor
        sectionHeaderButton.setImage(sectionsData[section].expandable ? UIImage(systemName: Resources.Images.chevronDown) : UIImage(systemName: Resources.Images.chevronRight), for: .normal)
        sectionHeaderButton.tintColor = .lightGray
        sectionHeaderButton.semanticContentAttribute = .forceRightToLeft
        sectionHeaderButton.tag = section
        sectionHeaderButton.addTarget(self, action: #selector(expandSection(sender:)), for: .touchUpInside)
        sectionHeaderButton.titleLabel?.font = .systemFont(ofSize: 20)
        return sectionHeaderButton
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
    @objc private func expandSection(sender:UIButton) {
        let sectionIndex = sender.tag
        sectionsData[sectionIndex].expandable.toggle()
        view?.updateTableView()
    }
}
