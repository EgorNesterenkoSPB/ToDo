import UIKit

class TaskTableViewCell: BaseTableViewCell {
    
    let circleButton = UIButton()
    let nameTitle = UILabel()
    let projectTitle = UILabel()
}

extension TaskTableViewCell {
    override func addViews() {
        contentView.addView(circleButton)
        contentView.addView(nameTitle)
        contentView.addView(projectTitle)
    }
    
    override func configure() {
        self.selectionStyle = .none
        
        circleButton.setImage(UIImage(systemName: isSelected ? Resources.Images.circleFill : Resources.Images.circle,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        circleButton.tintColor = isSelected ? .systemOrange : .black
        circleButton.addTarget(self, action: #selector(userTapFinishTask(_:)), for: .touchUpInside)
        
        nameTitle.textColor = .black
        nameTitle.font = .systemFont(ofSize: 20)
        
        projectTitle.textColor = .gray
        projectTitle.font = .systemFont(ofSize: 15)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            circleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleButton.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant:20),
            nameTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameTitle.leftAnchor.constraint(equalTo: circleButton.rightAnchor, constant: 15),
            projectTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            projectTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10)
        ])
    }
}



extension TaskTableViewCell {
    @objc private func userTapFinishTask(_ sender:UIButton) {
        sender.setImage(UIImage(systemName: Resources.Images.circleFill,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        sender.tintColor = .systemOrange
        //TODO: - Logic to remove the task
    }

}
