//
//  UIButton+Extension.swift
//  DownloadManager
//
//  Created by sy on 10/7/21.
//

import Foundation
import UIKit

extension UITextField {
    func setIcon(image: UIImageView) {
        image.frame = CGRect(x: 5, y: 5, width: 20, height: 20)
        //let iconView =  UIImageView(frame:
        //CGRect(x: 5, y: 5, width: 20, height: 20))
        //iconView.image = image
        let iconContainerView: UIView = UIView(frame:
                                                CGRect(x: 20, y: 2, width: 30, height: 30))
        iconContainerView.addSubview(image)
        leftView = iconContainerView
        leftViewMode = .always
    }
}
