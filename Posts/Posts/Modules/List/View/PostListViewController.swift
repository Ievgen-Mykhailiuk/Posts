//
//  PostListViewController.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import UIKit

protocol PostListView: AnyObject {
    func update(postList: [PostListModel])
    func showAlert(error: String)
    func showList()
    func showGrid()
    func showGallery()
}

final class PostListViewController: UIViewController {
    
    //MARK: - Properties
    var presenter: PostListPresenter!
    private var listView: ListView?
    private var gridView: GridView?
    private var galleryView: GalleryView?
    private lazy var tabView: TabView = {
        let tabsView = TabView(dataSource: ["List", "Grid", "Gallery"],
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
        presenter.fetchPostList { result in
            switch result {
            case .success(()):
                self.setupTabsView()
                self.setupListView()
                self.setupSortMenu()
                self.setupNavigationBar()
            case .failure(let error):
                self.showAlert(error: error.localizedDescription)
            }
        }
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
    
    private func setupListView() {
        listView = ListView(dataSource: presenter.getDataSource())
        if let contentView = listView {
            contentView.delegate = self
            view.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: tabView.bottomAnchor, constant: 3),
                contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
                contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
                contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
    
    private func setupGridView() {
        gridView = GridView(dataSource: presenter.getDataSource())
        if let contentView = gridView {
            contentView.delegate = self
            view.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: tabView.bottomAnchor, constant: 3),
                contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
                contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
                contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
    }
    
    private func setupGalleryView() {
        galleryView = GalleryView(dataSource: presenter.getDataSource())
        if let contentView = galleryView {
            contentView.delegate = self
            view.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: tabView.bottomAnchor, constant: 3),
                contentView.leftAnchor.constraint(equalTo: view.leftAnchor),
                contentView.rightAnchor.constraint(equalTo: view.rightAnchor),
                contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        }
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
        gridView?.removeFromSuperview()
        gridView = nil
        galleryView?.removeFromSuperview()
        galleryView = nil
        setupListView()
    }
    
    func showGrid() {
        listView?.removeFromSuperview()
        listView = nil
        galleryView?.removeFromSuperview()
        galleryView = nil
        setupGridView()
    }
    
    func showGallery() {
        gridView?.removeFromSuperview()
        gridView = nil
        listView?.removeFromSuperview()
        listView = nil
        setupGalleryView()
    }
    
    func update(postList: [PostListModel]) {
        if listView != nil {
            listView?.dataSource = postList
        } else if gridView != nil {
            gridView?.dataSource = postList
        } else {
            galleryView?.dataSource = postList
        }
    }
    
    func showAlert(error: String) {
        self.showAlert(title: "Error", message: error)
    }
}

//MARK: - TabsViewDelegate
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
