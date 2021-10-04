//
//  String+Extension.swift
//  DownloadManager
//
//  Created by sy on 10/3/21.
//

import Foundation
import UIKit


extension String {
    
    func toImage() -> UIImage? {
        return UIImage(data: try! Data(contentsOf: URL(string: self)!))
    }
    
    
    func toDate(dateFormat: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        let date: Date? = dateFormatter.date(from: self)
        return date
    }
}// end of extension
