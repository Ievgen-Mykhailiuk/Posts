//
//  DefaultPostListAssembly.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import UIKit

protocol PostListAssembly {
    func createPostsModule() -> UIViewController
}

final class DefaultPostListAssembly: PostListAssembly {
    func createPostsModule() -> UIViewController {
        let view  = PostListViewController.instantiateFromStoryboard()
        let apiManager = PostListAPIService()
        let router = DefaultPostListRouter(viewController: view)
        let presenter = PostListViewPresenter(view: view,
                                           apiManager: apiManager,
                                           router: router)
        view.presenter = presenter
        let navigationController = UINavigationController(rootViewController: view)
        return navigationController
    }
}
