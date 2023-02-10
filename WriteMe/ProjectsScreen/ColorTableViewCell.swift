import UIKit

class ColorTableViewCell: BaseTableViewCell {

    let title = UILabel()
    let colorCircleImageView = UIImageView()

}

extension ColorTableViewCell {
    override func addViews() {
        contentView.addView(title)
        contentView.addView(colorCircleImageView)
    }
    
    override func configure() {
        self.selectionStyle = .none
        
        title.font = .boldSystemFont(ofSize: 20)
        colorCircleImageView.image = UIImage(systemName: Resources.Images.circleFill,withConfiguration: Resources.Configurations.largeConfiguration)
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            colorCircleImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorCircleImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 10),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leftAnchor.constraint(equalTo: colorCircleImageView.rightAnchor, constant: 20)
        ])
    }
}
