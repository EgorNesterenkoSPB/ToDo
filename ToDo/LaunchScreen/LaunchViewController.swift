import UIKit

class LaunchViewController: BaseViewController {
    
    let label = UILabel()
    lazy var shadowView: UIView = {
    let v = UIView()
    v.frame = view.bounds
    v.alpha = 0.90
        v.backgroundColor = .systemOrange
    return v
    }()
    var presenter:(ViewToPresenterLaunchProtocol & InteractorToPresenterLaunchProtocol)?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.configureShadow(label: label, shadowView: shadowView, navigationController: navigationController)
    }
    
}

extension LaunchViewController {
    
    override func addViews() {
        self.view.addView(shadowView)
        self.view.addView(label)
    }
    
    override func configure() {
        super.configure()
        self.view.backgroundColor = UIColor(named: Resources.launchColorName)
        self.navigationController?.navigationBar.isHidden = true
        view.bringSubviewToFront(shadowView)
        
        label.text = Resources.Titles.applicationName
        label.font = .preferredFont(forTextStyle: UIFont.TextStyle.largeTitle, compatibleWith: .none)
        label.textColor = .white
        label.alpha = 0
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 1
        label.layer.shadowOffset = CGSize(width: 10, height: 0) // x offset shadow (center of shadow)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
}

extension LaunchViewController:PresenterToViewLaunchProtocol {}
