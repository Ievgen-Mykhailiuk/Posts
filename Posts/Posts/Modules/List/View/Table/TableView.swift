//
//  TableView.swift
//  Posts
//
//  Created by Евгений  on 15/09/2022.
//

import UIKit

final class TableView: UIView {
    
    //MARK: - Properties
    var dataSource = [PostListModel]() {
        didSet {
            self.contentView.reloadData()
        }
    }
    weak var delegate: ContentViewDelegate?
    private lazy var contentView: UITableView = {
        let tableView = UITableView()
        tableView.frame = .zero
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    //MARK: - Life Cycle
    init() {
        super.init(frame: .zero)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupTableView() {
        TableCell.registerNib(in: self.contentView)
        contentView.dataSource = self
        contentView.delegate = self
        setupTableViewConstraints()
    }
   
    private func setupTableViewConstraints() {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: self.rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        let cell: TableCell = .cell(in: self.contentView, at: indexPath)
        let post = dataSource[indexPath.row]
        guard let state = self.delegate?.getPostState(for: post.id) else { return cell }
        cell.configure(post: post, isExpanded: state)
        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDataSource
extension TableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRow(at: indexPath)
    }
}

//MARK: - UITableViewDelegate
extension TableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.cellSelected(at: indexPath.row)
        self.contentView.deselectRow(at: indexPath, animated: false)
    }
}

//MARK: - CellStateDelegate
extension TableView: CellStateDelegate {
    func readMoreButtonTapped(_ post: Int) {
        self.delegate?.readMoreButtonTapped(on: post)
    }
}

