//
//  PostListViewPresenter.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import Foundation

protocol PostListPresenter: AnyObject {
    func fetchPostList()
    func sort(_ method: SortingMethod)
    func isExpanded(_ postId: Int) -> Bool
    func setState(for post: Int)
    func showDetails(for index: Int)
    func getDataSource() -> [PostListModel]
    func changeTab(type: TabType)
    func search(with text: String)
    func stopSearch()
}

enum SortingMethod {
    case byDefault
    case byLikes
    case byDate
}

enum TabType: String, CaseIterable {
    case list = "List"
    case grid = "Grid"
    case gallery = "Gallery"
}

final class PostListViewPresenter {
    
    //MARK: - Properties
    private weak var view: PostListView!
    private let apiManager: PostListAPIService
    private let router: DefaultPostListRouter
    private var timer: Timer?
    private var postList = [PostListModel]() {
        didSet {
            self.view.update()
        }
    }
    private var expandedPosts = [Int]() {
        didSet {
            self.view.update()
        }
    }
    private var filtredPostList = [PostListModel]() {
        didSet {
            self.view.update()
        }
    }
    private var searchIsActive: Bool = false
    
    //MARK: - Life Cycle
    init(view: PostListView,
         apiManager: PostListAPIService,
         router: DefaultPostListRouter) {
        self.view = view
        self.apiManager = apiManager
        self.router = router
    }
    
    //MARK: - Private methods
    private func filter(with text: String) {
        if text.count >= 2 {
            timer?.invalidate()
            searchIsActive = true
            let filtred = postList.filter { $0.previewText.lowercased().contains(text.lowercased()) }
            timer = .scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.filtredPostList = filtred
            }
        } else {
            stopSearch()
        }
    }
}

//MARK: - PostsViewPresenterProtocol
extension PostListViewPresenter: PostListPresenter {
    func changeTab(type: TabType) {
        switch type {
        case .list:
            self.view.showList()
        case .grid:
            self.view.showGrid()
        case .gallery:
            self.view.showGallery()
        }
    }
    
    func getDataSource() -> [PostListModel] {
        if searchIsActive {
            return filtredPostList
        } else {
            return postList
        }
    }
    
    func fetchPostList() {
        apiManager.request { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.postList = data.posts
            case .failure(let error):
                self.view.showAlert(error: error.rawValue)
            }
        }
    }
    
    func sort(_ method: SortingMethod) {
        switch method {
        case .byDefault:
            postList = postList.sorted(by: { $0.id < $1.id })
        case .byLikes:
            postList =  postList.sorted(by: { $0.likesCount > $1.likesCount })
        case .byDate:
            postList = postList.sorted(by: { $0.timeShamp > $1.timeShamp })
        }
    }
    
    func isExpanded(_ postId: Int) -> Bool {
        var state: Bool
        if expandedPosts.contains(postId) {
            state = true
        } else {
            state = false
        }
        return state
    }
    
    func setState(for post: Int) {
        if expandedPosts.contains(post) {
            var postIndex: Int
            if let index = expandedPosts.firstIndex(where: { $0 == post }) {
                postIndex = Int(index)
                expandedPosts.remove(at: postIndex)
            }
        } else {
            expandedPosts.append(post)
        }
    }
    
    func showDetails(for index: Int) {
        let postId = postList[index].id
        router.showDetails(for: postId)
    }
    
    func search(with text: String) {
        filter(with: text)
    }
    
    func stopSearch() {
        searchIsActive = false
        filtredPostList = []
    }
}
