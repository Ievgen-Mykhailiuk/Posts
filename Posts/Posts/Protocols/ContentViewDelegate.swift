//
//  ContentViewDelegate.swift
//  Posts
//
//  Created by Евгений  on 15/09/2022.
//

import Foundation

protocol ContentViewDelegate: AnyObject {
    func readMoreButtonTapped(on post: Int)
    func cellSelected(at index: Int)
    func getPostState(for post: Int) -> Bool
}
