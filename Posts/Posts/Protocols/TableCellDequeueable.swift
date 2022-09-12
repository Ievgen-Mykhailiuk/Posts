//
//  TableCellDequeueable.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import UIKit

protocol TableCellDequeueable: CellIdentifying {
    static func cell<T: BaseTableViewCell>(in table: UITableView,
                                           at indexPath: IndexPath) -> T
}

extension TableCellDequeueable {
    static func cell<T: BaseTableViewCell>(in table: UITableView,
                                           at indexPath: IndexPath) -> T  {
        guard let cell = table.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                   for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(cellIdentifier)")
        }
        return cell
    }
}
