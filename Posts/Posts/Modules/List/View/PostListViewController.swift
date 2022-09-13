//
//  PostListViewController.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import UIKit

protocol PostListView: AnyObject {
    func updatePostList()
    func showAlert(error: String)
}

final class PostListViewController: UIViewController {
    
    //MARK: - Properties
    var presenter: PostListPresenter!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var tabsView: TabsView = {
        let tabsView = TabsView(dataSource: ["List", "Grid", "Gallery"],
                                selectedStateColor: .blue,
                                unselectedStateColor: .black)
        return tabsView
    }()
    
    private lazy var sortButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "menubar.arrow.down.rectangle"),
                                     style: .plain,
                                     target: self,
                                     action: nil)
        button.tintColor = .black
        return button
    }()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: - Private methods
    private func initialSetup() {
        setupTabsView()
        setupTableView()
        setupSortMenu()
        setupNavigationBar()
        presenter.fetchPostList()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        PostListCell.registerNib(in: self.tableView)
        setupTableViewConstraints()
    }
    
    private func setupTabsView() {
        view.addSubview(tabsView)
        setupTabsViewConstraints()
    }
    
    private func setupTableViewConstraints() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tabsView.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTabsViewConstraints() {
        view.addSubview(tabsView)
        tabsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabsView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tabsView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            tabsView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupSortMenu() {
        let sortMenu = UIMenu(title: "Sort by", children: [
            UIAction(title: "Default", image: UIImage(systemName: "stop"))  { action in
                self.presenter.sort(.byDefault)
            },
            UIAction(title: "Likes", image: UIImage(systemName: "heart"))  { action in
                self.presenter.sort(.byLikes)
            },
            UIAction(title: "Date", image: UIImage(systemName: "calendar")) { action in
                self.presenter.sort(.byDate)
            }
        ])
        sortButton.menu = sortMenu
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = sortButton
        title = "PostList"
    }
}

//MARK: - PostListViewProtocol
extension PostListViewController: PostListView {
    func updatePostList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showAlert(error: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "Error", message: error)
        }
    }
}

//MARK: - UITableViewDataSource
extension PostListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.getPostListCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PostListCell = .cell(in: self.tableView, at: indexPath)
        let post = presenter.getPost(at: indexPath.row)
        let state = presenter.isExpanded(post.id)
        cell.configure(post: post, isExpanded: state)
        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDelegate
extension PostListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.showDetails(at: indexPath.row)
        self.tableView.deselectRow(at: indexPath, animated: false)
    }
}

//MARK: - CellStateDelegate
extension PostListViewController: CellStateDelegate {
    func readMoreButtonTapped(_ post: Int) {
        presenter.setState(for: post)
    }
}
