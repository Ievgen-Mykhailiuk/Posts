//
//  UIImageView+Extension.swift
//  Posts
//
//  Created by Евгений  on 13/09/2022.
//

import UIKit
import Kingfisher

typealias ImageBlock = (UIImage?) -> Void

extension UIImageView {
    func setImage(imageUrl: String,
                  placeholder: UIImage? = nil,
                  completion: ImageBlock? = nil) {
        guard let url = URL(string: imageUrl) else { return }
        self.kf.setImage(with: url,
                         placeholder: placeholder,
                         options: [.fromMemoryCacheOrRefresh],
                         progressBlock: nil) { result in
            switch result {
            case .success(let imageResult):
                completion?(imageResult.image)
            case .failure(_):
                completion?(nil)
            }
        }
    }
}
