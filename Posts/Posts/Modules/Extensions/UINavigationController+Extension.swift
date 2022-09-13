//
//  UINavigationController+Extension.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import UIKit

typealias EmptyBlock = () -> Void

extension UINavigationController {
    func pushViewController(_ viewController: UIViewController,
                            animated: Bool,
                            completion: EmptyBlock?) {
        pushViewController(viewController, animated: animated)
        guard animated, let coordinator = transitionCoordinator else { return }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }
    
    func popViewController(animated: Bool,
                           completion: EmptyBlock?) {
        popViewController(animated: animated)
        guard animated, let coordinator = transitionCoordinator else { return }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }
    
    func popToViewController(_ viewController: UIViewController,
                             animated: Bool,
                             completion: EmptyBlock?) {
        popToViewController(viewController, animated: animated)
        guard animated, let coordinator = transitionCoordinator else { return }
        coordinator.animate(alongsideTransition: nil) { _ in completion?() }
    }
}
