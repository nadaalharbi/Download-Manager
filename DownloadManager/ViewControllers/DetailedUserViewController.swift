//
//  DetailedUserViewController.swift
//  DownloadManager
//
//  Created by sy on 10/4/21.
//

import Foundation
import UIKit

class DetailedUserViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var selectedUserImgView: UIImageView!
    @IBOutlet weak var imageSizeSegmentControl: UISegmentedControl!

    @IBOutlet weak var viewAsLbl: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    
    // MARK: - Variables
    var selectedIndexPath: Int = 0
    var currentUserObj = [UserModel]()
    
    var selectedImageStringURL: String = ""
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Set Selected User Image
        selectedUserImgView.layer.cornerRadius = 50.0
        selectedUserImgView.layer.masksToBounds = true
        //selectedUserImgView.contentMode = .scaleAspectFit
        
        viewAsLbl.font = UIFont(name: Constants.Fonts.MontserratRegularFont, size: 15.0)
        
        self.imageSizeSegmentControl.selectedSegmentIndex = 0
        self.setSegmentFont(segment: self.imageSizeSegmentControl)
        
        /// Set Navigation Bar
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont(name: Constants.Fonts.MontserratRegularFont, size: 16.0)!]
        navigationItem.title = currentUserObj[selectedIndexPath].user.name
        
        /// Set Default displayed image --> Small
        selectedImageStringURL =  currentUserObj[selectedIndexPath].user.profileImage.small
        selectedUserImgView.image = currentUserObj[selectedIndexPath].user.profileImage.small.toImage()
        
        
//        /// Set up Drop Down Menu
//        let menu: DropDown = [
//        let]
//        
//        
        /// Set Gesture Recognizer for Download Button
        let gestureRecognizer = UIGestureRecognizer(target: self, action: #selector(downloadDropDownAction))
        downloadBtn.addGestureRecognizer(gestureRecognizer)
    }
    
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            // Small
            selectedImageStringURL = currentUserObj[selectedIndexPath].user.profileImage.small
            selectedUserImgView.image = currentUserObj[selectedIndexPath].user.profileImage.small.toImage()
        case 1:
            // Medium
            selectedImageStringURL = currentUserObj[selectedIndexPath].user.profileImage.medium
            selectedUserImgView.image = currentUserObj[selectedIndexPath].user.profileImage.medium.toImage()
        case 2:
            // Large
            selectedImageStringURL = currentUserObj[selectedIndexPath].user.profileImage.large
            selectedUserImgView.image = currentUserObj[selectedIndexPath].user.profileImage.large.toImage()
        default:
            print("\(#function) Default value")
        }
    }
    
    
    @IBAction func downloadAction(_ sender: Any) {
        let imageString = String(selectedImageStringURL)

        if let url = URL(string: imageString),
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    // MARK: - Selector Functions @objc
    @objc func downloadDropDownAction() {
        
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        guard error == nil else{
            print(error?.localizedDescription ?? "")
            self.displayAlertMessage(userTitle: "Error", userMessage: Constants.AlertMessages.DownloadError.stringValue)
            return
        }
        self.displayAlertMessage(userTitle: "Success", userMessage: Constants.AlertMessages.DownloadSuccess.stringValue)
    }
    
}// end of class
