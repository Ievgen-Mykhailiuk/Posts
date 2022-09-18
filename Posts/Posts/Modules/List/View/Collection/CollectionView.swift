//
//  CollectionView.swift
//  Posts
//
//  Created by Евгений  on 15/09/2022.
//

import UIKit

final class CollectionView: UIView {
    
    //MARK: - Properties
    weak var delegate: ContentViewDelegate?
    var dataSource = [PostListModel]() {
        didSet {
            self.contentView.reloadData()
        }
    }
    lazy var gridLayout: UICollectionViewCompositionalLayout = {
        let size = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                                          heightDimension: NSCollectionLayoutDimension.estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: size)
        item.contentInsets = NSDirectionalEdgeInsets(top:       0,
                                                     leading:   5,
                                                     bottom:    0,
                                                     trailing:  5)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:  size,
                                                       subitem:     item,
                                                       count:       2)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top:        5,
                                                        leading:    0,
                                                        bottom:     5,
                                                        trailing:   0)
        section.interGroupSpacing = 10
        return UICollectionViewCompositionalLayout(section: section)
    }()
    lazy var galleryLayout: UICollectionViewCompositionalLayout = {
        let size = NSCollectionLayoutSize(widthDimension: NSCollectionLayoutDimension.fractionalWidth(1),
                                          heightDimension: NSCollectionLayoutDimension.estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize:  size,
                                                       subitem:     item,
                                                       count:       1)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top:        5,
                                                        leading:    5,
                                                        bottom:     5,
                                                        trailing:   5)
        section.interGroupSpacing = 10
        return UICollectionViewCompositionalLayout(section: section)
    }()
    lazy var contentView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: gridLayout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupCollectionView() {
        CollectionCell.registerNib(in: self.contentView)
        contentView.dataSource = self
        contentView.delegate = self
        setupCollectionViewConstraints()
    }
    
    private func setupCollectionViewConstraints() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: self.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionCell = .cell(in: self.contentView, at: indexPath)
        let post = dataSource[indexPath.item]
        guard let state = self.delegate?.getPostState(for: post.id) else { return cell }
        cell.configure(post: post, isExpanded: state)
        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDataSource
extension CollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellForItem(at: indexPath)
    }
}

//MARK: - UICollectionViewDelegate
extension CollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.cellSelected(at: indexPath.item)
        self.contentView.deselectItem(at: indexPath, animated: false)
    }
}

//MARK: - CellStateDelegate
extension CollectionView: CellStateDelegate {
    func readMoreButtonTapped(_ post: Int) {
        self.delegate?.readMoreButtonTapped(on: post)
    }
}
