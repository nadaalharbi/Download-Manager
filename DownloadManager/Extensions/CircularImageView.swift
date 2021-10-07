//
//  CircularImageView.swift
//  DownloadManager
//
//  Created by sy on 10/7/21.
//

import Foundation
import UIKit

@IBDesignable class CircularImageView: UIImageView {
    
    @IBInspectable var borderWidth: CGFloat {
        get { layer.borderWidth}
        set {
            layer.borderWidth = newValue
            layer.cornerRadius = frame.size.width / 2
            layer.masksToBounds = true
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat {
        get { layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
        }
    }
}
