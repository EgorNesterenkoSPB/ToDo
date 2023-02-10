import UIKit

class NoteListCollectionViewCell: UICollectionViewCell {
    let nameLabel = UILabel()
        
    var cellModel:NoteCellModel? {
        didSet {
            nameLabel.text = cellModel?.note.name
            self.backgroundColor = .systemOrange
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

extension NoteListCollectionViewCell {
    private func configure() {
        self.backgroundColor = .systemOrange
        self.layer.masksToBounds = true
        self.layer.cornerRadius = UIContstants.layerCornerRadius
        
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            nameLabel.rightAnchor.constraint(lessThanOrEqualTo: self.rightAnchor,constant: -10)
        ])
    }
}
