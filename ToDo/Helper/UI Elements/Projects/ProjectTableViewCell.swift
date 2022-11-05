import UIKit

class ProjectTableViewCell: BaseTableViewCell {
    
    let nameTitle = UILabel()
    let circleImageView = UIImageView()
    let countOfTasksLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}

extension ProjectTableViewCell {
    override func addViews() {
        self.addView(nameTitle)
        self.addView(circleImageView)
        self.addView(countOfTasksLabel)
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
            circleImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circleImageView.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 20),
            nameTitle.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameTitle.leftAnchor.constraint(equalTo: circleImageView.rightAnchor,constant: 15),
            countOfTasksLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            countOfTasksLabel.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10)
        ])
    }
}
