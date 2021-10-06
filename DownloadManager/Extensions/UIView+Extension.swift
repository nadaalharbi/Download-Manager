//
//  UIView+Extension.swift
//  DownloadManager
//
//  Created by sy on 10/6/21.
//

import Foundation
import UIKit

extension UIView {
    
    func createShadowView(shadowOpacityValue: Float, shadowColor: CGColor){
        layer.cornerRadius = 15.0
        layer.shadowColor = shadowColor
        layer.shadowOpacity = shadowOpacityValue
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 6
        layer.masksToBounds = false
    }
}
