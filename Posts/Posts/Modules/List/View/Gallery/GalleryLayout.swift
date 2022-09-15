//
//  GridLayout.swift
//  Posts
//
//  Created by Евгений  on 15/09/2022.
//

import UIKit

final class GalleryLayout : UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            let attributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
            attributesObjects?.forEach({ attributes in
                if attributes.representedElementCategory == .cell {
                    if let newFrame = layoutAttributesForItem(at: attributes.indexPath)?.frame {
                        attributes.frame = newFrame
                    }
                }
            })
            return attributesObjects
        }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else { fatalError() }
        guard let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else { return nil }
        attributes.frame.origin.x = sectionInset.left
        attributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return attributes
    }
}

