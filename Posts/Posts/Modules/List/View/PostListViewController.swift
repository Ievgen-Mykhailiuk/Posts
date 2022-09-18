//
//  PostListViewController.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import UIKit

protocol PostListView: AnyObject {
    func update()
    func showAlert(error: String)
    func showList()
    func showGrid()
    func showGallery()
}

final class PostListViewController: UIViewController {
    
    //MARK: - Properties
    var presenter: PostListPresenter!
    private var activeTab: TabType = .list
    private lazy var tableView: TableView = {
        let tableView = TableView()
        return tableView
    }()
    private lazy var collectionView: CollectionView = {
        let collectionView = CollectionView()
        return collectionView
    }()
    private lazy var tabView: TabView = {
        let tabsView = TabView(dataSource: TabType.allCases.map { $0.rawValue },
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
        self.setupTabsView()
        self.setupCollectionView()
        self.setupTableView()
        self.setupSortMenu()
        self.setupNavigationBar()
        presenter.fetchPostList()
    }
    
    private func setupTabsView() {
        tabView.delegate = self
        view.addSubview(tabView)
        tabView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tabView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tabView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tabView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tabView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: tabView.bottomAnchor, constant: 3),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: tabView.bottomAnchor, constant: 3),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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
    func showList() {
        collectionView.dataSource = []
        collectionView.isHidden = true
        tableView.isHidden = false
        tableView.dataSource = presenter.getDataSource()
        activeTab = .list
    }
    
    func showGrid() {
        tableView.dataSource = []
        tableView.isHidden = true
        collectionView.isHidden = false
        collectionView.contentView.setCollectionViewLayout(collectionView.gridLayout, animated: false)
        collectionView.dataSource = presenter.getDataSource()
        activeTab = .grid
    }
    
    func showGallery() {
        tableView.dataSource = []
        tableView.isHidden = true
        collectionView.isHidden = false
        collectionView.contentView.setCollectionViewLayout(collectionView.galleryLayout, animated: false)
        collectionView.dataSource = presenter.getDataSource()
        activeTab = .gallery
    }
    
    func update() {
        switch activeTab {
        case .list:
            tableView.dataSource = presenter.getDataSource()
        case .grid:
            collectionView.dataSource = presenter.getDataSource()
        case .gallery:
            collectionView.dataSource = presenter.getDataSource()
        }
    }
    
    func showAlert(error: String) {
        self.showAlert(title: "Error", message: error)
    }
}

//MARK: - TabViewDelegate
extension PostListViewController: TabViewDelegate {
    func tabSelected(type: TabType) {
        presenter.changeTab(type: type)
    }
}

//MARK: - ListViewDelegate
extension PostListViewController: ContentViewDelegate {
    func readMoreButtonTapped(on post: Int) {
        presenter.setState(for: post)
    }
    
    func cellSelected(at index: Int) {
        presenter.showDetails(for: index)
    }
    
    func getPostState(for post: Int) -> Bool {
        return presenter.isExpanded(post)
    }
}
