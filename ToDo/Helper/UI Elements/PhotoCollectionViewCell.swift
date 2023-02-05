import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    var cellModel:PhotoCellModel? {
        didSet {
            imageView.image = cellModel?.image
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
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            imageView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
    }
}
