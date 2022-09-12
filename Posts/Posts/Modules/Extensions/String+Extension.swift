//
//  String+Extension.swift
//  Posts
//
//  Created by Евгений  on 12/09/2022.
//

import UIKit

extension String {

    func visibleRectHeight(with font: UIFont = .systemFont(ofSize: 13), numberOfLines: Int) -> CGFloat {
        return font.lineHeight*CGFloat(numberOfLines)
    }
    
    func rectHeight(with width: CGFloat, font: UIFont = UIFont.systemFont(ofSize: 13)) -> CGFloat {
       let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
       let rect = self.boundingRect(with: constraintRect,
                                           options: .usesLineFragmentOrigin,
                                           attributes: [NSAttributedString.Key.font: font],
                                           context: nil)
       
       return rect.height
     }
}
