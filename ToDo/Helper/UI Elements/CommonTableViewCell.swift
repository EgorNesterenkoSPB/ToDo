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
    }
    
    override func layoutViews() {
        
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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size:CGFloat = contentView.frame.size.height - 12 // 6 from top and bottom
        iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
        
        let imageSize:CGFloat = size / 1.5
        iconImageView.frame = CGRect(x: (size - imageSize) / 2, y: (size - imageSize) / 2, width: imageSize, height: imageSize)
        
        label.frame = CGRect(x: UIConstans.labelXOffset + iconContainer.frame.self.width, y: 0, width: contentView.frame.size.width - UIConstans.labelXOffset - iconContainer.frame.size.width, height: contentView.frame.size.height)
    }
}
