//
//  DetailedUserViewController.swift
//  DownloadManager
//
//  Created by sy on 10/4/21.
//

import Foundation
import UIKit
import DropDown

class DetailedUserViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var selectedUserImgView: UIImageView!
    @IBOutlet weak var backgroundViewOfImage: UIView!
    
    @IBOutlet weak var imageSizeSegmentControl: UISegmentedControl!

    @IBOutlet weak var viewAsLbl: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    
    
    // MARK: - Variables
    var selectedIndexPath: Int = 0
    var currentUserObj = [UserModel]()
    var selectedImageStringURL: String = ""
    
    /// Set up Drop Down Menu
    let menu: DropDown = {
        let dropDownMenu = DropDown()
        dropDownMenu.dataSource = ["PNG", "URL", "JSON", "XML"]
        return dropDownMenu
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Set Selected User Image
        selectedUserImgView.layer.cornerRadius = 15.0
        selectedUserImgView.layer.masksToBounds = true
        selectedUserImgView.contentMode = .scaleAspectFit
        
        viewAsLbl.font = UIFont(name: Constants.Fonts.MontserratRegularFont, size: 15.0)
        
        self.imageSizeSegmentControl.selectedSegmentIndex = 0
        self.setSegmentFont(segment: self.imageSizeSegmentControl)
        
        /// Set Navigation Bar
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont(name: Constants.Fonts.MontserratRegularFont, size: 16.0)!]
        navigationItem.title = currentUserObj[selectedIndexPath].user.name
        
        /// Set Default displayed image --> Small
        selectedImageStringURL =  currentUserObj[selectedIndexPath].user.profileImage.small
        selectedUserImgView.image = currentUserObj[selectedIndexPath].user.profileImage.small.toImage()
        
        //backgroundViewOfImage.layer.cornerRadius = 15.0
        //backgroundViewOfImage.backgroundColor = currentUserObj[selectedIndexPath].color.toUIColor.withAlphaComponent(0.3)

        
        /// Set target Download Button
        downloadBtn.addTarget(self, action: #selector(downloadDropDownAction), for: .touchUpInside)
        
        /// Drop Down menu UI Set up
        menu.anchorView = downloadBtn
        menu.dismissMode = .onTap
        menu.selectRow(at: 0)
        
        menu.width = 100.0
        
        menu.cornerRadius = 15.0
        menu.shadowColor = .black
        menu.shadowRadius = 20.0
        
        menu.textFont = UIFont(name: Constants.Fonts.MontserratLightFont, size: 15.0)!
        menu.textColor = .black
        menu.selectedTextColor = .systemBlue
        
        
        menu.selectionAction = { (index, item) in
            print("selected indes is: \(index) with title: \(item)")
            switch index {
            case 0:
                // PNG
                let imageString = String(self.selectedImageStringURL)
                if let url = URL(string: imageString),
                   let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
                }
            case 1:
                // URL
                let pasteboard = UIPasteboard.general
                pasteboard.string = String(self.selectedImageStringURL)
                if pasteboard.string != "" || pasteboard.string != nil {
                    self.displayAlertMessage(userTitle: "Success", userMessage: "URL has been copied successfuly! Do you want to open the link to Safari?", displayCancelAction: true) { (alert, action) in
                        if action == .OK {
                            guard let url = URL(string: self.selectedImageStringURL) else { return }
                            UIApplication.shared.open(url)
                        }
                    }
                }
            case 2:
                // JSON - Share
                let activity = UIActivityViewController(activityItems: ["\(self.selectedImageStringURL)"], applicationActivities: nil)
                activity.excludedActivityTypes = [
                    .postToWeibo,
                    .print,
                    .saveToCameraRoll,
                    //addToReadingList,
                    .postToFlickr,
                    .postToVimeo,
                    .postToTencentWeibo,
                    .postToFacebook
                    //.copyToPasteboard
                ]
                
                activity.popoverPresentationController?.sourceView = self.downloadBtn
                activity.popoverPresentationController?.sourceRect = self.downloadBtn.bounds
                self.present(activity, animated: true, completion: nil)
            case 3:
                // XML
                print()
            default:
                print()
            }
        }
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
    
//
//    @IBAction func downloadAction(_ sender: Any) {
//        let imageString = String(selectedImageStringURL)
//
//        if let url = URL(string: imageString),
//           let data = try? Data(contentsOf: url),
//           let image = UIImage(data: data) {
//            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
//        }
//    }
    
    // MARK: - Selector Functions Objective-C
    @objc func downloadDropDownAction() {
        menu.show()
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
