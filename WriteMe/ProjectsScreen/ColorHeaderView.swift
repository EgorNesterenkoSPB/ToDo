import UIKit

protocol ColorHeaderViewProtocol{
    func updateExpandable()
}

class ColorHeaderView: UIView {

    let titleLabel = UILabel()
    let circleImageView = UIImageView()
    let chevronImageView = UIImageView()
    let color:UIColor
    let expandable:Bool
    var delegate:ColorHeaderViewProtocol?
    
    init(color:UIColor,expandable:Bool) {
        self.color = color
        self.expandable = expandable
        super.init(frame: .zero)
        self.configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.backgroundColor = .systemBackground
        titleLabel.text = Resources.Titles.color
        titleLabel.font = .boldSystemFont(ofSize: 22)
        self.addView(titleLabel)
        
        circleImageView.image = UIImage(systemName: Resources.Images.circleFill,withConfiguration: Resources.Configurations.largeConfiguration)
        circleImageView.tintColor = color
        self.addView(circleImageView)
        
        chevronImageView.image = UIImage(systemName: expandable ? Resources.Images.chevronDown : Resources.Images.chevronRight)
        chevronImageView.tintColor = .gray
        self.addView(chevronImageView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(expandSection))
        self.addGestureRecognizer(gesture)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor,constant: 20),
            chevronImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            chevronImageView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -20),
            circleImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            circleImageView.rightAnchor.constraint(equalTo: chevronImageView.leftAnchor,constant: -10)
        ])
    }
}

extension ColorHeaderView {
    @objc private func expandSection(_ gesture: UITapGestureRecognizer) {
        self.delegate?.updateExpandable()
    }
}
