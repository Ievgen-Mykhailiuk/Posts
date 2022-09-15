//
//  PostListViewPresenter.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import Foundation

typealias Block = (Result<Void, Error>)->()

protocol PostListPresenter: AnyObject {
    func fetchPostList(completion: Block?)
    func sort(_ method: SortingMethod)
    func isExpanded(_ postId: Int) -> Bool
    func setState(for post: Int)
    func showDetails(for index: Int)
    func getDataSource() -> [PostListModel]
    func changeTab(type: TabType)
}

enum SortingMethod {
    case byDefault
    case byLikes
    case byDate
}

enum TabType: String {
    case list = "List"
    case grid = "Grid"
    case gallery = "Gallery"
}

final class PostListViewPresenter {
    
    //MARK: - Properties
    private weak var view: PostListView!
    private let apiManager: PostListAPIService
    private let router: DefaultPostListRouter
    private var postList = [PostListModel]() {
        didSet {
            self.view.updatePostList(postList: postList)
        }
    }
    private var expandedPosts = [Int]() {
        didSet {
            self.view.updatePostList(postList: postList)
        }
    }
    
    //MARK: - Life Cycle
    init(view: PostListView,
         apiManager: PostListAPIService,
         router: DefaultPostListRouter) {
        self.view = view
        self.apiManager = apiManager
        self.router = router
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
        return postList
    }
    
    func fetchPostList(completion: Block?) {
        apiManager.request { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.postList = data.posts
                completion?(.success(()))
            case .failure(let error):
                completion?(.failure(error))
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
}
