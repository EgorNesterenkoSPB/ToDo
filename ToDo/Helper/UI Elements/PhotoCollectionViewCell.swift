import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let checkMarkImageView = UIImageView()
    
    var cellModel:PhotoCellModel? {
        didSet {
            imageView.image = cellModel?.image
            guard let selected = cellModel?.isSelected else {return}
            selected ? self.selectCell() : self.unSelectCell()
        }
    }
    
    private enum UIContstants {
        static let layerCornerRadius = 10.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension PhotoCollectionViewCell {
    private func configure() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = UIContstants.layerCornerRadius
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        
        checkMarkImageView.image = UIImage(systemName: Resources.Images.checkmark,withConfiguration: Resources.Configurations.largeConfiguration)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
    
    private func selectCell() {
        imageView.layer.borderColor = UIColor.blue.cgColor
        imageView.layer.borderWidth = 2
        imageView.addView(checkMarkImageView)
        NSLayoutConstraint.activate([
            checkMarkImageView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 10),
            checkMarkImageView.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -10)
        ])
    }
    
    private func unSelectCell() {
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0
        checkMarkImageView.removeFromSuperview()
    }
}
