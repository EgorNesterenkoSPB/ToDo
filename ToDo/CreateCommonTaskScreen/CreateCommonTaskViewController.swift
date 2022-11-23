import UIKit

protocol CreateCommonTaskViewControllerProtocol {
    func updateCommonTasksTableView()
}

final class CreateCommonTaskViewController:CreateTaskBaseController {
    var presenter: (ViewToPresenterCreateCommonTaskProtocol & InteractorToPresenterCreateCommonTaskProtocol)?
    let project:ProjectCoreData
    var delegate:CreateCommonTaskViewControllerProtocol?
    
    init(project:ProjectCoreData) {
        self.project = project
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateCommonTaskViewController {
    override func addViews() {
        super.addViews()
    }
    
    override func configure() {
        super.configure()
        projectButton.setTitle(project.name, for: .normal)
        projectButton.isEnabled = false
        projectButton.setTitleColor(.placeholderText, for: .normal)
        
        nameTextField.delegate = self
        descriptionTextView.delegate = self
        
        createTaskButton.addTarget(self, action: #selector(createTaskButtonTapped(_:)), for: .touchUpInside)
    }
    
    override func layoutViews() {
        super.layoutViews()
    }
}

extension CreateCommonTaskViewController {
    @objc private func createTaskButtonTapped(_ sender:UIButton) {
        presenter?.createTask(project: project,date: self.date,time: self.timeDate)
    }
}

extension CreateCommonTaskViewController:PresenterToViewCreateCommonTaskProtocol {
    func onFailedCreateTask(errorText: String) {
        self.present(createInfoAlert(messageText: errorText, titleText: Resources.Titles.errorTitle),animated: true)
    }
    
    func onSuccessfulyCreateTask() {
        self.delegate?.updateCommonTasksTableView()
        super.animateDismissView()
    }
    
    
}

extension CreateCommonTaskViewController {
    
    override func textViewDidEndEditing(_ textView: UITextView) {
        super.textViewDidEndEditing(textView)
        presenter?.textViewDidEndEditing(textView: textView)
    }
}

extension CreateCommonTaskViewController {
    override func textFieldDidEndEditing(_ textField: UITextField) {
        super.textFieldDidEndEditing(textField)
        presenter?.textFieldDidEndEditing(textField: textField)
    }
}
