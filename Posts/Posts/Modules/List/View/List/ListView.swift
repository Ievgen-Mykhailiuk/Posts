//
//  ListView.swift
//  Posts
//
//  Created by Евгений  on 15/09/2022.
//

import UIKit

final class ListView: UIView {
    
    //MARK: - Properties
    var dataSource = [PostListModel]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    weak var delegate: ContentViewDelegate?
    private lazy var tableView: UITableView  = {
        let tableView = UITableView()
        tableView.frame = .zero
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    //MARK: - Life Cycle
    init(dataSource: [PostListModel]) {
        self.dataSource = dataSource
        super.init(frame: .zero)
        setupTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    private func setupTableView() {
        ListCell.registerNib(in: self.tableView)
        tableView.dataSource = self
        tableView.delegate = self
        setupTableViewConstraints()
    }
   
    private func setupTableViewConstraints() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func cellForRow(at indexPath: IndexPath) -> UITableViewCell {
        let cell: ListCell = .cell(in: self.tableView, at: indexPath)
        let post = dataSource[indexPath.row]
        guard let state = self.delegate?.getPostState(for: post.id) else { return cell }
        cell.configure(post: post, isExpanded: state)
        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDataSource
extension ListView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellForRow(at: indexPath)
    }
}

//MARK: - UITableViewDelegate
extension ListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.cellSelected(at: indexPath.row)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}

//MARK: - CellStateDelegate
extension ListView: CellStateDelegate {
    func readMoreButtonTapped(_ post: Int) {
        self.delegate?.readMoreButtonTapped(on: post)
    }
}

