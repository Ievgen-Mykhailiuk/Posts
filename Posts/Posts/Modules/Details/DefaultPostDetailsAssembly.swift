//
//  DefaultPostDetailsAssembly.swift
//  Posts
//
//  Created by Евгений  on 13/09/2022.
//

import UIKit

protocol PostDetailsAssembly {
    func createPostDetailsModule(for post: Int) -> UIViewController
}

final class DefaultPostDetailsAssembly: PostDetailsAssembly {
    func createPostDetailsModule(for postId: Int) -> UIViewController {
        let view  = PostDetailsViewController.instantiateFromStoryboard()
        let apiManager = PostDetailsAPIService()
        let router = DefaultPostDetailsRouter(viewController: view)
        let presenter = PostDetailsViewPresenter(view: view,
                                                 apiManager: apiManager,
                                                 router: router,
                                                 postId: postId)
        view.presenter = presenter
        return view
    }
}
