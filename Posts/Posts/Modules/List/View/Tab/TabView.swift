//
//  TabsView.swift
//  Posts
//
//  Created by Евгений  on 13/09/2022.
//

import UIKit

protocol TabViewDelegate: AnyObject {
    func tabSelected(type: TabType)
}

final class TabView: UIView {
    
    //MARK: - Properties
    weak var delegate: TabViewDelegate?
    private let dataSource: [String]
    private let selectedStateColor: UIColor
    private let unselectedStateColor: UIColor
    private let spacingValue: CGFloat = 20
    private let font: UIFont = .systemFont(ofSize: 17)
    private let collectionViewPadding: CGFloat = 10
    private let cellHeight: CGFloat = 50
    private let cellInset: CGFloat = 10
    private let indicatorHeight: CGFloat = 5
    private let maxTabsCountForEqualWidth = 3
    private let animationDuration = 0.2
    private var selectedTabIndex: Int = .zero {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private lazy var layout: UICollectionViewCompositionalLayout = {
        let itemSize = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.estimated(20),
                                              heightDimension: NSCollectionLayoutDimension.fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                                               heightDimension: NSCollectionLayoutDimension.fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: dataSource.count)
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private lazy var indicatorView: UIView = {
        let view = UIView(frame: CGRect(x: .zero,
                                        y: .zero,
                                        width: .zero,
                                        height: self.indicatorHeight))
        view.makeRounded()
        view.backgroundColor = selectedStateColor
        return view
    }()

    //MARK: - Life Cycle
    init(dataSource: [String],
         selectedStateColor: UIColor,
         unselectedStateColor: UIColor) {
        self.dataSource = dataSource
        self.selectedStateColor = selectedStateColor
        self.unselectedStateColor = unselectedStateColor
        super.init(frame: .zero)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSelectionIndicatorPosition()
        selectTab(at: selectedTabIndex)
    }
    
    //MARK: - Private methods
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        TabCell.registerClass(in: self.collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.addSubview(indicatorView)
        addSubview(collectionView)
        setupCollectionViewConstraints()
    }
    
    private func setupCollectionViewConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: collectionViewPadding),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -collectionViewPadding),
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func updateIndicatorPosition(at index: Int) {
        guard let attributes = collectionView.layoutAttributesForItem(at: .init(item: index, section: .zero)) else { return }
        UIView.animate(withDuration: animationDuration, delay: .zero, options: [.curveLinear]) {
            self.indicatorView.frame.origin.x = attributes.frame.origin.x
            self.indicatorView.frame.size.width = attributes.size.width
        }
    }
    
    private func setSelectionIndicatorPosition() {
        indicatorView.frame.origin.y = self.frame.height - indicatorHeight
    }
    
    private func calculateTabSize(with tabTitle: String) -> CGSize {
        var cellSize: CGSize = .zero
        if dataSource.count <= maxTabsCountForEqualWidth {
            collectionView.isScrollEnabled = false
            let widthToCalculate = self.frame.width - collectionViewPadding * 2
            let spacingCount = dataSource.count - 1
            let totalSpacingValue = CGFloat(spacingCount) * spacingValue
            let cellWidth = (widthToCalculate - totalSpacingValue)/CGFloat(dataSource.count)
            cellSize = CGSize(width: cellWidth, height: cellHeight)
        } else {
            let cellWidth = tabTitle.textWidth(with: font) + cellInset
            cellSize = CGSize(width: cellWidth, height: cellHeight)
        }
        return cellSize
    }
    
    private func selectTab(at index: Int) {
        collectionView.scrollToItem(at: .init(item: index, section: .zero),
                                    at: .centeredHorizontally,
                                    animated: true)
        updateIndicatorPosition(at: index)
    }
}

//MARK: - UICollectionViewDataSource
extension TabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TabCell = .cell(in: collectionView, at: indexPath)
        let tabTitle = dataSource[indexPath.item]
        cell.configure(with: tabTitle,
                       isSelected: selectedTabIndex == indexPath.item,
                       selectedStateColor: selectedStateColor,
                       unselectedStateColor: unselectedStateColor)
        return cell
    }
}

//MARK: - UICollectionViewDelegate
extension TabView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTabIndex = indexPath.item
        selectTab(at: indexPath.item)
        guard let type = TabType(rawValue: dataSource[indexPath.item]) else { return }
        delegate?.tabSelected(type: type)
    }
}
