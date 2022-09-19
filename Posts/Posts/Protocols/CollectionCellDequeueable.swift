//
//  CollectionCellDequeueable.swift
//  Posts
//
//  Created by Евгений  on 13/09/2022.
//

import UIKit

protocol CollectionCellDequeueable: CellIdentifying {
    static func cell<T: BaseCollectionViewCell>(in collection: UICollectionView,
                                                at indexPath: IndexPath) -> T
}

extension CollectionCellDequeueable {
    static func cell<T: BaseCollectionViewCell>(in collection: UICollectionView,
                                                at indexPath: IndexPath) -> T  {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                        for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(cellIdentifier)")
        }
        return cell
    }
}

