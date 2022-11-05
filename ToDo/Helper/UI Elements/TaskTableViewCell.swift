import UIKit

class TaskTableViewCell: BaseTableViewCell {
    
    let circleButton = UIButton()
    let nameTitle = UILabel()
    let projectTitle = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension TaskTableViewCell {
    override func addViews() {
        self.addView(circleButton)
        self.addView(nameTitle)
        self.addView(projectTitle)
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
            circleButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circleButton.leftAnchor.constraint(equalTo: self.leftAnchor,constant:20),
            nameTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameTitle.leftAnchor.constraint(equalTo: circleButton.rightAnchor, constant: 15),
            projectTitle.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            projectTitle.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10)
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
