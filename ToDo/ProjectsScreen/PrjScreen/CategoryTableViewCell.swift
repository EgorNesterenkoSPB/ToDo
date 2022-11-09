import UIKit

class CategoryTableViewCell: BaseTableViewCell {

    let nameLabel = UILabel()
    let countOfTasksLabel = UILabel()

}

extension CategoryTableViewCell {
    override func addViews() {
        self.addView(nameLabel)
        self.addView(countOfTasksLabel)
    }
    
    override func configure() {
        nameLabel.font = .boldSystemFont(ofSize: 18)
        
        countOfTasksLabel.font = .systemFont(ofSize: 15)
        countOfTasksLabel.textColor = .gray
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 20),
            countOfTasksLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            countOfTasksLabel.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -10)
        ])
    }
}
