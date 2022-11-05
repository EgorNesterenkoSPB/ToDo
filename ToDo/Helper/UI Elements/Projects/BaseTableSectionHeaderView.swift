import UIKit

protocol BaseTableSectionHeaderViewProtocol {
    func updateExpandable(sectionIndex:Int)
}

class BaseTableSectionHeaderView: UIView {

    let title = UILabel()
    let chevronImageView = UIImageView()
    let titleText:String
    let section:Int
    let expandable:Bool
    var delegate:BaseTableSectionHeaderViewProtocol?

    init(titleText:String,section:Int,expandable:Bool) {
        self.titleText = titleText
        self.section = section
        self.expandable = expandable
        super.init(frame: .zero)
        self.configureView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
     public func configureView() {
        self.backgroundColor = .clear
        self.tag = section
        
        title.text = titleText
        title.textColor = .black
        title.font = .boldSystemFont(ofSize: 18)
        self.addView(title)
        
         chevronImageView.image = UIImage(systemName: expandable ? Resources.Images.chevronDown : Resources.Images.chevronRight)
        chevronImageView.tintColor = .gray
        self.addView(chevronImageView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(expandSection))
        self.addGestureRecognizer(gesture)
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            chevronImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            chevronImageView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -20),
        ])
    }
}

extension BaseTableSectionHeaderView {
    @objc private func expandSection(_ gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else {return}
        let sectionIndex = tag
        self.delegate?.updateExpandable(sectionIndex: sectionIndex)
    }
}

