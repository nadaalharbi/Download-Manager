//
//  UIImage+Extension.swift
//  DownloadManager
//
//  Created by sy on 10/3/21.
//

import UIKit

extension UIImage {
    
    func resizeImage(with size: CGSize) -> UIImage? {
        // 1.Create Graphics Context
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        // 2.Draw Image in graphicsContext
        draw(in: CGRect(origin: .zero, size: size))
        
        // 3.Create Image from current graphicsContext
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // 4.Clean-up graphicsContext
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
}
