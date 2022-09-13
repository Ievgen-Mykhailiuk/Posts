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
    func getPost(at index: Int) -> PostListModel
    func getPostListCount() -> Int
    func isExpanded(_ postId: Int) -> Bool
    func setState(for post: Int)
}

enum SortingMethod {
    case byDefault
    case byLikes
    case byDate
}

final class PostListViewPresenter {
    
    //MARK: - Properties
    private weak var view: PostListView!
    private let apiManager: PostListAPIService
    private let router: DefaultPostListRouter
    private var postList = [PostListModel]() {
        didSet {
            self.view.updatePostList()
        }
    }
    private var expandedPosts = [Int]() {
        didSet {
            self.view.updatePostList()
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
    func fetchPostList() {
        apiManager.request { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.postList = data.posts
            case .failure(let error):
                self.view.didFailWithError(error: error.rawValue)
            }
        }
    }
    
    func sort(_ method: SortingMethod) {
        switch method {
        case .byDefault:
            fetchPostList()
        case .byLikes:
            postList =  postList.sorted(by: { $0.likesCount > $1.likesCount })
        case .byDate:
            postList = postList.sorted(by: { $0.timeShamp > $1.timeShamp })
        }
    }
    
    func getPost(at index: Int) -> PostListModel {
        return postList[index]
    }
    
    func getPostListCount() -> Int {
        return postList.count
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
            guard let index = expandedPosts.firstIndex(where: { $0 == post }) else { return }
            expandedPosts.remove(at: index)
        } else {
            expandedPosts.append(post)
        }
    }
}
