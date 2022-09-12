//
//  CellIdentifying.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import Foundation

protocol CellIdentifying: AnyObject {
    static var cellIdentifier: String { get }
}

extension CellIdentifying {
    static var cellIdentifier: String {
        return String(describing: Self.self)
    }
}
