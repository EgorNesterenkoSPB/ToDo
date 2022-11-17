import UIKit

protocol BaseTableSectionHeaderViewProtocol {
    func updateExpandable(sectionIndex:Int)
}

class BaseTableSectionHeaderView: UIView {
    
    let title = UILabel()
    let chevronImageView = UIImageView()
    let addButton = UIButton()
    let titleText:String
    let section:Int
    let expandable:Bool
    var delegate:BaseTableSectionHeaderViewProtocol?
    var titleRightAnchorConstraint:NSLayoutConstraint?
    
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
}

extension BaseTableSectionHeaderView {
    @objc private func expandSection(_ gesture: UITapGestureRecognizer) {
        guard let tag = gesture.view?.tag else {return}
        let sectionIndex = tag
        self.delegate?.updateExpandable(sectionIndex: sectionIndex)
    }
    
    @objc private func addButtonTapped(_ sender:UIButton) {
        self._addButtonTapped()
    }
}

@objc extension BaseTableSectionHeaderView {
    func _addButtonTapped() {}
    
    func configureView() {
        self.backgroundColor = .systemBackground
        self.tag = section
        
        title.text = titleText
        title.textColor = UIColor(named: Resources.Titles.labelAndTintColor)
        title.font = .boldSystemFont(ofSize: 18)
        self.addView(title)
        
        chevronImageView.image = UIImage(systemName: expandable ? Resources.Images.chevronDown : Resources.Images.chevronRight)
        chevronImageView.tintColor = .lightGray
        self.addView(chevronImageView)
        
        addButton.setImage(UIImage(systemName: Resources.Images.plusImage), for: .normal)
        addButton.tintColor = .lightGray
        addButton.addTarget(self, action: #selector(addButtonTapped(_:)), for: .touchUpInside)
        self.addView(addButton)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(expandSection))
        self.addGestureRecognizer(gesture)
        
        NSLayoutConstraint.activate([
            title.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            title.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            addButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addButton.rightAnchor.constraint(equalTo: chevronImageView.leftAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: addButton.imageView?.image?.size.width ?? 20),
            chevronImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            chevronImageView.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -25),
            chevronImageView.widthAnchor.constraint(equalToConstant: chevronImageView.image?.size.width ?? 20)
        ])
        titleRightAnchorConstraint = title.rightAnchor.constraint(lessThanOrEqualTo: addButton.leftAnchor, constant: -10)
        titleRightAnchorConstraint?.isActive = true
    }
}
