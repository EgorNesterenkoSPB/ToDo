import Foundation
import UIKit

//MARK: - View Input (View -> Presenter)
protocol ViewToPresenterMainProtocol {
    var view: PresenterToViewMainProtocol? {get set}
    var router: PresenterToRouterMainProtocol? {get set}
    var interactor: PresenterToInteractorMainProtocol? {get set}
    func numberOfSections() -> Int
    func numberOfRowsInSection(section:Int) -> Int
    func cellForRowAt(tableView:UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell
    func viewForHeaderInSection(tableView: UITableView, section:Int) -> UIView?
    func heightForHeaderInSection() -> CGFloat
    func heightForFooterInSection() -> CGFloat
    func handleBottomSheetGesture(gesture:UIPanGestureRecognizer,view:UIView,bottomSheetView:BottomSheetUIView)
}

//MARK: - View Output (Presenter -> View)
protocol PresenterToViewMainProtocol {
    func updateTableView()
}

//MARK: -  Interactor Input (Presenter -> Interactor)
protocol PresenterToInteractorMainProtocol {
    var presenter:InteractorToPresenterMainProtocol? {get set}

}

//MARK: - Interactor Output (Interactor -> Presenter)
protocol InteractorToPresenterMainProtocol {

}

//MARK: - Router Input (Presenter -> Router)
protocol PresenterToRouterMainProtocol {
    static func createModule() -> MainViewController
}
