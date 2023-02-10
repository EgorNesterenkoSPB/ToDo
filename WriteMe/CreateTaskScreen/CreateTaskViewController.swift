import UIKit

protocol CreateTaskViewControllerProtocol {
    func refreshView(category:CategoryCoreData,section:Int)
    func refreshCommonTasksTable()
}

final class CreateTaskViewController:CreateTaskBaseController {
    var presenter:(InteractorToPresenterCreateTaskProtocol & ViewToPresenterCreateTaskProtocol)?
    var category:CategoryCoreData?
    var delegate:CreateTaskViewControllerProtocol?
    var section:Int?
    var projectName:String?
    
    init(projectName:String? = nil,section:Int? = nil,category:CategoryCoreData? = nil) {
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
        
        projectButton.setTitle(self.projectName ?? "Project", for: .normal)
        projectButton.isEnabled = self.projectName == nil ? true : false
        projectButton.setTitleColor(projectButton.isEnabled ? UIColor(named: Resources.Titles.labelAndTintColor) : .placeholderText, for: .normal)
        
        createTaskButton.addTarget(self, action: #selector(createTaskButtonTapped), for: .touchUpInside)
    }
    
    override func layoutViews() {
        super.layoutViews()
    }
}

extension CreateTaskViewController {
    @objc private func createTaskButtonTapped(_ sender: UIButton) {
        presenter?.createTask(category: self.category, date: self.date, time: self.timeDate,projectID: self.projectID)
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
        self.enableCreateTaskButton()
    }
}

extension CreateTaskViewController:PresenterToViewCreateTaskProtocol {
    func onFailedCreateTask(errorText: String) {
        self.present(createInfoAlert(messageText: errorText, titleText: Resources.Titles.errorTitle),animated: true)
    }
    
    func onSuccessfulyCreateTask() {
        if let category = self.category,let section = self.section{
            self.delegate?.refreshView(category: category, section: section)
        } else if projectID != nil {
            self.delegate?.refreshCommonTasksTable()
        }
        super.animateDismissView()
    }
}
