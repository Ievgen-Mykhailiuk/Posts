//
//  GalleryView.swift
//  Posts
//
//  Created by Евгений  on 15/09/2022.
//

import UIKit

final class GalleryView: UIView {
    //MARK: - Properties
    weak var delegate: ContentViewDelegate?
    var dataSource = [PostListModel]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Life Cycle
    init(dataSource: [PostListModel]) {
        self.dataSource = dataSource
        super.init(frame: .zero)
        setupGalleryView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupGalleryView() {
        setupGalleryViewLayout()
        GalleryCell.registerNib(in: self.collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        setupGalleryViewConstraints()
    }
    
    private func setupGalleryViewLayout() {
        let layout = GalleryLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        collectionView.collectionViewLayout = layout
        collectionView.contentInsetAdjustmentBehavior = .always
    }
    
    private func setupGalleryViewConstraints() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GalleryCell = .cell(in: self.collectionView, at: indexPath)
        let post = dataSource[indexPath.row]
        guard let state = self.delegate?.getPostState(for: post.id) else { return cell }
        cell.configure(post: post, isExpanded: state)
        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDataSource
extension GalleryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellForItem(at: indexPath)
    }
}

//MARK: - UICollectionViewDelegate
extension GalleryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.cellSelected(at: indexPath.item)
        self.collectionView.deselectItem(at: indexPath, animated: false)
    }
}

//MARK: - CellStateDelegate
extension GalleryView: CellStateDelegate {
    func readMoreButtonTapped(_ post: Int) {
        self.delegate?.readMoreButtonTapped(on: post)
    }
}
