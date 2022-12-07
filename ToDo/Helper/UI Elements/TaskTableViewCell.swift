import UIKit

class TaskTableViewCell: BaseTableViewCell {
    
    let circleButton = UIButton()
    let nameTitle = UILabel()
    let projectTitle = UILabel()
    let descriptionTitle = UILabel()
    var handleFinishTask: (() -> Void)?
    
    private enum UIConstants {
        static let circleWidth = 30.0
    }
}

extension TaskTableViewCell {
    override func addViews() {
        contentView.addView(circleButton)
        contentView.addView(nameTitle)
        contentView.addView(projectTitle)
        contentView.addView(descriptionTitle)
    }
    
    override func configure() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
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
            circleButton.widthAnchor.constraint(equalToConstant: UIConstants.circleWidth),
            nameTitle.centerYAnchor.constraint(equalTo: circleButton.centerYAnchor),
            nameTitle.leftAnchor.constraint(equalTo: circleButton.rightAnchor, constant: 10),
            nameTitle.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor, constant: -10),
            projectTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -5),
            projectTitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            descriptionTitle.topAnchor.constraint(equalTo: nameTitle.bottomAnchor, constant: 5),
            descriptionTitle.leftAnchor.constraint(equalTo: nameTitle.leftAnchor),
            descriptionTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            descriptionTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ])
    }
}

extension TaskTableViewCell {
    public func setup(nameTitle:String?,descriptionTitle:String?,projectTitle:String?) {
        self.circleButton.setImage(UIImage(systemName: Resources.Images.circle,withConfiguration: Resources.Configurations.largeConfiguration), for: .normal)
        self.circleButton.tintColor = UIColor(named: Resources.Titles.labelAndTintColor)
        self.nameTitle.attributedText = nil
        self.nameTitle.textColor = UIColor(named: Resources.Titles.labelAndTintColor)
        self.projectTitle.text = projectTitle
        self.handleFinishTask = nil
        self.nameTitle.text = nameTitle
        self.descriptionTitle.text = descriptionTitle
    }
}


extension TaskTableViewCell {
    @objc private func userTapFinishTask(_ sender:UIButton) {
        self.handleFinishTask?()
    }

}
