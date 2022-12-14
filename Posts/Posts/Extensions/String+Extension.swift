//
//  String+Extension.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import UIKit

extension String {
    static let empty = ""
    
    func rectHeight(with width: CGFloat,
                    with font: UIFont = UIFont.systemFont(ofSize: 16)) -> CGFloat {
        let rect = self.boundingRect(with: CGSize(width: width, height: .greatestFiniteMagnitude),
                                     options: .usesLineFragmentOrigin,
                                     attributes: [NSAttributedString.Key.font: font],
                                     context: nil)
        return rect.height
    }
    
    func visibleRectHeight(with font: UIFont = .systemFont(ofSize: 16),
                           numberOfLines: Int) -> CGFloat {
        let height = font.lineHeight * CGFloat(numberOfLines)
        return height
    }
    
    func textWidth(with font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
