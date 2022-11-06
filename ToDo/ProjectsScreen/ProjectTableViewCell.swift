import UIKit

class ProjectTableViewCell: BaseTableViewCell {
    
    let nameTitle = UILabel()
    let circleImageView = UIImageView()
    let countOfTasksLabel = UILabel()

}

extension ProjectTableViewCell {
    override func addViews() {
        contentView.addView(nameTitle)
        contentView.addView(circleImageView)
        contentView.addView(countOfTasksLabel)
    }
    
    override func configure() {
        self.backgroundColor = .clear
        
        nameTitle.font = .systemFont(ofSize: 18)
        circleImageView.image = UIImage(systemName: Resources.Images.circleFill,withConfiguration: Resources.Configurations.largeConfiguration)
        countOfTasksLabel.textColor = .gray
        countOfTasksLabel.font = .systemFont(ofSize: 16)
        
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            circleImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            circleImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 20),
            nameTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameTitle.leftAnchor.constraint(equalTo: circleImageView.rightAnchor,constant: 15),
            countOfTasksLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            countOfTasksLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10)
        ])
    }
}
