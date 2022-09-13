//
//  CollectionCellRegistable.swift
//  Posts
//
//  Created by Евгений  on 13/09/2022.
//

import UIKit

protocol CollectionCellRegistable: CellIdentifying {
    static func registerClass(in collection: UICollectionView)
    static func registerNib(in collection: UICollectionView)
}

extension CollectionCellRegistable {
    static func registerNib(in collection: UICollectionView) {
        collection.register(UINib(nibName: cellIdentifier, bundle: nil),
                            forCellWithReuseIdentifier: cellIdentifier)
    }
    
    static func registerClass(in collection: UICollectionView) {
        collection.register(Self.self, forCellWithReuseIdentifier: cellIdentifier)
    }
}
