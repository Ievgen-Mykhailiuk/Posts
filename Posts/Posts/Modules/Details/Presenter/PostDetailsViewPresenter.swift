//
//  PostDetailsViewPresenter.swift
//  Posts
//
//  Created by Евгений  on 13/09/2022.
//

import Foundation

protocol PostDetailsPresenter: AnyObject {
    func fetchPostDetails()
}

final class PostDetailsViewPresenter {
    
    //MARK: - Properties
    private weak var view: PostDetailsView!
    private let apiManager: PostDetailsAPIService
    private let router: DefaultPostDetailsRouter
    private let postId: Int
    
    //MARK: - Life Cycle
    init(view: PostDetailsView,
         apiManager: PostDetailsAPIService,
         router: DefaultPostDetailsRouter,
         postId: Int) {
        self.view = view
        self.apiManager = apiManager
        self.router = router
        self.postId = postId
    }
}

//MARK: - PostsViewPresenterProtocol
extension PostDetailsViewPresenter: PostDetailsPresenter {
    func fetchPostDetails() {
        apiManager.request(with: postId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.view.showDetails(for: data.post)
            case .failure(let error):
                self.view.showAlert(error: error.rawValue)
            }
        }
    }
}
