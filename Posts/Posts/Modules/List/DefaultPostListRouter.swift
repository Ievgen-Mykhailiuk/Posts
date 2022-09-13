//
//  DefaultPostListRouter.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import Foundation

protocol PostListRouter {
    func showDetails(for post: Int)
}

final class DefaultPostListRouter: BaseRouter, PostListRouter {
    func showDetails(for postId: Int) {
        let viewController = DefaultPostDetailsAssembly().createPostDetailsModule(for: postId)
        show(viewController: viewController,
             isModal: false,
             animated: true,
             completion: nil)
    }
}
