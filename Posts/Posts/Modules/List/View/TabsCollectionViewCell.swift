//
//  TabsCollectionViewCell.swift
//  Posts
//
//  Created by Евгений  on 13/09/2022.
//

import UIKit

final class TabsCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - Properties
    private var selectedStateColor: UIColor = .blue
    private var unselectedStateColor: UIColor = .black
    private lazy var tabTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Lyfe Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTabTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupTabTitleLabel() {
        contentView.addSubview(tabTitleLabel)
        tabTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tabTitleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            tabTitleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
    }
    
    private func setState(isSelected: Bool) {
        tabTitleLabel.textColor = isSelected ? selectedStateColor : unselectedStateColor
    }
    
    //MARK: - Configuration method
    func configure(with tabTitle: String,
                   isSelected: Bool,
                   selectedStateColor: UIColor,
                   unselectedStateColor: UIColor) {
        tabTitleLabel.text = tabTitle
        self.selectedStateColor = selectedStateColor
        self.unselectedStateColor = unselectedStateColor
        setState(isSelected: isSelected)
    }
}
