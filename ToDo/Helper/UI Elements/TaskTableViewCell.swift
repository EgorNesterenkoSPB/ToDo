import UIKit

class TaskTableViewCell: BaseTableViewCell {
    
    let circleButton = UIButton()
    let nameTitle = UILabel()
    let projectTitle = UILabel()
    let descriptionTitle = UILabel()
    let bottomDividerView = UIView()
}

extension TaskTableViewCell {
    override func addViews() {
        contentView.addView(circleButton)
        contentView.addView(nameTitle)
        contentView.addView(projectTitle)
        contentView.addView(descriptionTitle)
        contentView.addView(bottomDividerView)
    }
    
    override func configure() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        bottomDividerView.backgroundColor = .lightGray
        
        circleButton.setImage(UIImage(systemName: isSelected ? Resources.Images.circleFill : Resources.Images.circle,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        circleButton.tintColor = isSelected ? .systemOrange : UIColor(named: Resources.Titles.labelAndTintColor)
        circleButton.addTarget(self, action: #selector(userTapFinishTask(_:)), for: .touchUpInside)
        
        nameTitle.textColor = UIColor(named: Resources.Titles.labelAndTintColor)
        nameTitle.font = .systemFont(ofSize: 20)
        
        projectTitle.textColor = .gray
        projectTitle.font = .systemFont(ofSize: 15)
        
        descriptionTitle.font = .systemFont(ofSize: 15)
        descriptionTitle.textColor = .secondaryLabel
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            circleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            nameTitle.centerYAnchor.constraint(equalTo: circleButton.centerYAnchor),
            nameTitle.leftAnchor.constraint(equalTo: circleButton.rightAnchor, constant: 10),
            nameTitle.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -10),
            descriptionTitle.topAnchor.constraint(equalTo: nameTitle.bottomAnchor, constant: 5),
            descriptionTitle.leftAnchor.constraint(equalTo: nameTitle.leftAnchor),
            descriptionTitle.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor, constant: -5),
            descriptionTitle.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -5),
            projectTitle.bottomAnchor.constraint(equalTo: bottomDividerView.topAnchor,constant: -5),
            projectTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            bottomDividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomDividerView.heightAnchor.constraint(equalToConstant: 1),
            bottomDividerView.leftAnchor.constraint(equalTo: circleButton.leftAnchor),
            bottomDividerView.rightAnchor.constraint(equalTo: projectTitle.rightAnchor)
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
