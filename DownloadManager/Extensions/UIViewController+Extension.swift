//
//  UIViewController+Extension.swift
//  DownloadManager
//
//  Created by sy on 10/4/21.
//

import UIKit

extension UIViewController {
    
    // MARK: - Alert Message
    func displayAlertMessage(userTitle: String = "Warning", userMessage: String, textFieldPlaceHolder: String? = nil, displayCancelAction: Bool = false, completion: ((UIAlertController , Constants.AlertActionTypes?) -> Void)? = nil){
        
        let alert = UIAlertController(title:userTitle , message:userMessage, preferredStyle: UIAlertController.Style.alert)
        if let textFieldPlaceHolder = textFieldPlaceHolder {
            alert.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = textFieldPlaceHolder
                textField.textAlignment = .right
            }
        }
        
        let myString  = userTitle
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSAttributedString.Key.font:UIFont(name: Constants.Fonts.MontserratBoldFont, size: 17.0)!])
        alert.setValue(myMutableString, forKey: "attributedTitle")
        
        let message  = userMessage
        var messageMutableString = NSMutableAttributedString()
        messageMutableString = NSMutableAttributedString(string: message as String, attributes: [NSAttributedString.Key.font:UIFont(name: Constants.Fonts.MontserratRegularFont, size: 14.0)!])
        alert.setValue(messageMutableString, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            completion?(alert, .OK)
        }
        
        if displayCancelAction {
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive){ (action) in
                completion?(alert, .Cancel)
            }
            //cancelAction.titleTextColor = .systemRed
            alert.addAction(cancelAction)
        }
        alert.addAction(okAction)
        self.present(alert, animated:true,completion:nil)
    }
    
    func setSegmentFont(segment: UISegmentedControl){
        let font = UIFont(name: Constants.Fonts.MontserratRegularFont, size: 12.0)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
        
        segment.layer.cornerRadius = 70.0
        segment.layer.masksToBounds = true
    }
}// end of extension
