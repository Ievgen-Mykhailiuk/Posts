//
//  GridView.swift
//  Posts
//
//  Created by Евгений  on 15/09/2022.
//

import UIKit

final class GridView: UIView {
    
    //MARK: - Properties
    var dataSource = [PostListModel]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    private let itemsInLine: CGFloat = 2
    private let collapsedCellHeight: CGFloat = 200
    private let spacing: CGFloat = 5
    private let totalPaddings: CGFloat = 65
    private let totalInsets: CGFloat = 8
    weak var delegate: ContentViewDelegate?
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: .zero,
                                                   left: 4,
                                                   bottom: .zero,
                                                   right: 4)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    //MARK: - Life Cycle
    init(dataSource: [PostListModel]) {
        self.dataSource = dataSource
        super.init(frame: .zero)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupCollectionView() {
        GridCell.registerNib(in: self.collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        setupCollectionViewConstraints()
    }
    
    private func setupCollectionViewConstraints() {
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func calculatedSize(for post: PostListModel) -> CGSize {
        var cellSize: CGSize = .zero
        let cellWidth = self.collectionView.frame.width/itemsInLine - totalInsets - spacing
        guard let isExpanded = self.delegate?.getPostState(for: post.id) else { return .zero}
        if isExpanded {
            let titleLabelHeight = post.previewText.rectHeight(with: cellWidth)
            let textLabelHeight = post.title.rectHeight(with: cellWidth)
            let expandedCellHeight = titleLabelHeight + textLabelHeight + totalPaddings
            cellSize = CGSize(width: cellWidth, height: expandedCellHeight)
        } else {
            cellSize = CGSize(width: cellWidth, height: collapsedCellHeight)
        }
        return cellSize
    }
    
    private func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GridCell = .cell(in: self.collectionView, at: indexPath)
        let post = dataSource[indexPath.item]
        guard let state = self.delegate?.getPostState(for: post.id) else { return cell }
        cell.configure(post: post, isExpanded: state)
        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDataSource
extension GridView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellForItem(at: indexPath)
    }
}

//MARK: - UICollectionViewDelegate
extension GridView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.cellSelected(at: indexPath.item)
        self.collectionView.deselectItem(at: indexPath, animated: false)
    }
}

//MARK: - CellStateDelegate
extension GridView: CellStateDelegate {
    func readMoreButtonTapped(_ post: Int) {
        self.delegate?.readMoreButtonTapped(on: post)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension GridView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let post = dataSource[indexPath.item]
        return calculatedSize(for: post)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
}

