import UIKit
import CoreData

final class TaskViewController:BaseViewController {
    
    let nameTextField = UITextField()
    let descriptionTextView = UITextView()
    let dateTextField = UITextField()
    let pathLabel = UILabel()
    let descriptionTitle = UILabel()
    
    var presenter:(ViewToPresenterTaskProtocol & InteractorToPresenterTaskProtocol)?
    let task:NSManagedObject
    let taskContent:TaskContent
    let formatter:DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()
    
    
    init(task:NSManagedObject,taskContent:TaskContent) {
        self.taskContent = taskContent
        self.task = task
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TaskViewController {
    
    override func addViews() {
        self.view.addView(nameTextField)
        self.view.addView(dateTextField)
        self.view.addView(descriptionTextView)
        self.view.addView(pathLabel)
        self.view.addView(descriptionTitle)
    }
    
    override func configure() {
        super.configure()
        self.navigationController?.navigationBar.isHidden = false
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        navigationItem.rightBarButtonItems = [editButton]
        
        pathLabel.text = taskContent.path
        pathLabel.font = .systemFont(ofSize: 15)
        pathLabel.textColor = .lightGray
        
        nameTextField.delegate = self
        nameTextField.text = taskContent.name
        nameTextField.font = .boldSystemFont(ofSize: 23)
        nameTextField.textAlignment = .center
        
        dateTextField.isEnabled = false
        dateTextField.textColor = .gray
        dateTextField.tintColor = .clear
        if let time = taskContent.time {
            dateTextField.text = formatter.string(from: time)
        }
        dateTextField.font = .systemFont(ofSize: 15)
        
        descriptionTitle.text = "Descriptions"
        descriptionTitle.textColor = .lightGray
        descriptionTitle.font = .boldSystemFont(ofSize: 16)
        
        descriptionTextView.text = taskContent.description == nil ? Resources.Placeholders.textViewPlaceholder : taskContent.description
        descriptionTextView.textColor = UIColor.placeholderText
        descriptionTextView.font = .systemFont(ofSize: 18)
        descriptionTextView.delegate = self
        
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            pathLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pathLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 10),
            pathLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -10),
            nameTextField.leftAnchor.constraint(equalTo: pathLabel.leftAnchor),
            nameTextField.rightAnchor.constraint(equalTo: pathLabel.rightAnchor),
            nameTextField.topAnchor.constraint(equalTo: pathLabel.bottomAnchor, constant: 15),
            dateTextField.leftAnchor.constraint(equalTo: pathLabel.leftAnchor),
            dateTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            descriptionTitle.leftAnchor.constraint(equalTo: pathLabel.leftAnchor),
            descriptionTitle.topAnchor.constraint(equalTo: dateTextField.bottomAnchor, constant: 20),
            descriptionTextView.topAnchor.constraint(equalTo: descriptionTitle.bottomAnchor, constant: 10),
            descriptionTextView.leftAnchor.constraint(equalTo: pathLabel.leftAnchor),
            descriptionTextView.rightAnchor.constraint(equalTo: nameTextField.rightAnchor),
            descriptionTextView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

extension TaskViewController {
    @objc private func editButtonTapped(_ sender:UIButton) {
        
    }
}

//MARK: - TextFieldDelegate
extension TaskViewController:UITextFieldDelegate {
    
}

//MARK: - TextViewDelegate
extension TaskViewController:UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        presenter?.textViewDidBeginEditing(textView: textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        presenter?.textViewDidEndEditing(textView: textView)
    }
}


//MARK: - PresenterToView
extension TaskViewController:PresenterToViewTaskProtocol {
    
}
