//
//  TableCellRegistable.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import UIKit

protocol TableCellRegistable: CellIdentifying {
    static func registerClass(in table: UITableView)
    static func registerNib(in table: UITableView)
}

extension TableCellRegistable {
    static func registerNib(in table: UITableView) {
        table.register(UINib(nibName: cellIdentifier, bundle: nil),
                       forCellReuseIdentifier: cellIdentifier)
    }
    
    static func registerClass(in table: UITableView) {
        table.register(Self.self, forCellReuseIdentifier: cellIdentifier)
    }
}
