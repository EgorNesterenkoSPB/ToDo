import UIKit

class CommonTableViewCell: BaseTableViewCell {

    private let iconContainer:UIView = {
       let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let iconImageView:UIImageView = {
       let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label:UILabel = {
       let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private enum UIConstans {
        static let labelXOffset = 25.0
    }
}

extension CommonTableViewCell {
    override func addViews() {
        contentView.addView(iconContainer)
        iconContainer.addView(iconImageView)
        contentView.addView(label)
    }
    
    override func configure() {
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    override func layoutViews() {
        NSLayoutConstraint.activate([
            iconContainer.widthAnchor.constraint(equalToConstant: contentView.frame.size.height - 12),
            iconContainer.heightAnchor.constraint(equalTo: iconContainer.widthAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: (contentView.frame.size.height - 12) / 1.5),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            label.widthAnchor.constraint(equalToConstant: contentView.frame.size.width - UIConstans.labelXOffset - iconContainer.frame.size.width),
            label.heightAnchor.constraint(equalToConstant: contentView.frame.size.height),
            iconContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor,constant: 10),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            label.leftAnchor.constraint(equalTo: iconContainer.rightAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor)
        ])
    }
}

extension CommonTableViewCell {
    public func setup(with model: CommonCellOption) {
        label.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
    }
}

extension CommonTableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        iconContainer.backgroundColor = nil
    }
}
