//
//  CellStateDelegate.swift
//  Posts
//
//  Created by Евгений  on 15/09/2022.
//

import Foundation

protocol CellStateDelegate: AnyObject {
    func readMoreButtonTapped(_ postId: Int)
}
