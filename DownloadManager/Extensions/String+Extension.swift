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
        if Reachability.isConnectedToNetwork() {
            do{
                let data = try Data(contentsOf: URL(string: self)!)
                return UIImage(data: data)
            } catch {
                print( error.localizedDescription)
                return nil
            }
        } else {
            print("Not connected")
            return nil
        }
//        if Reachability.isConnectedToNetwork() {
//            return UIImage(data: try! Data(contentsOf: URL(string: self)!))
//        } else {
//            return nil
//        }
    }
    
    // convert hex string color to UIColor
    public var toUIColor: UIColor {
        var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.clear
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    func toDateFormat() -> String? {
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en")
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        let date = dateFormatter.date(from: self)!
    // Take the string and convert it to date base on givn orgin format
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    let date = dateFormatter.date(from: self)
    // then, convert it to string with the format you need
    dateFormatter.dateFormat = "dd-MM-yyy"
    return dateFormatter.string(from: date!)
    }
}// end of extension
