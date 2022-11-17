import UIKit

protocol CreateTaskViewControllerProtocol {
    func refreshView(category:CategoryCoreData,section:Int)
}

final class CreateTaskViewController:CreateTaskBaseController {
    var presenter:(InteractorToPresenterCreateTaskProtocol & ViewToPresenterCreateTaskProtocol)?
    let category:CategoryCoreData
    var delegate:CreateTaskViewControllerProtocol?
    let section:Int
    let projectName:String
    
    init(section:Int,category:CategoryCoreData,projectName:String) {
        self.category = category
        self.section = section
        self.projectName = projectName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateTaskViewController {
    override func addViews() {
        super.addViews()
    }
    
    override func configure() {
        super.configure()
        
        projectButton.setTitle(self.projectName, for: .normal)
        projectButton.isEnabled = false
        projectButton.setTitleColor(.placeholderText, for: .normal)
        
        createTaskButton.addTarget(self, action: #selector(createTaskButtonTapped), for: .touchUpInside)
    }
    
    override func layoutViews() {
        super.layoutViews()
    }
}

extension CreateTaskViewController {
    @objc private func createTaskButtonTapped(_ sender: UIButton) {
        presenter?.createTask(category: self.category)
    }
}

extension CreateTaskViewController {
    override func textViewDidBeginEditing(_ textView: UITextView) {
        super.textViewDidBeginEditing(textView)
    }
    
    override func textViewDidEndEditing(_ textView: UITextView) {
        super.textViewDidEndEditing(textView)
        presenter?.textViewDidEndEditing(textView: textView)
    }
}

extension CreateTaskViewController {
    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        presenter?.textFieldDidEndEditing(textField: textField)
    }
}

extension CreateTaskViewController:PresenterToViewCreateTaskProtocol {
    func onFailedCreateTask(errorText: String) {
        self.present(createErrorAlert(errorText: errorText),animated: true)
    }
    
    func onSuccessfulyCreateTask() {
        self.delegate?.refreshView(category: self.category, section: self.section)
        super.animateDismissView()
    }
}
