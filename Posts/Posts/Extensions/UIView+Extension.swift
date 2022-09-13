//
//  UIView+Extension.swift
//  Posts
//
//  Created by Евгений  on 13/09/2022.
//

import UIKit

extension UIView {
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    func makeRounded() {
        cornerRadius = frame.height/2
    }
}
