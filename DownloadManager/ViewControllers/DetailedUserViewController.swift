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
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var linkLbl: UILabel!
    @IBOutlet weak var profileCreatedAtLbl: UILabel!
    
    @IBOutlet weak var selectedUserImgView: UIImageView!
    @IBOutlet weak var imageSizeSegmentControl: UISegmentedControl!

    @IBOutlet weak var viewAsLbl: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    
    @IBOutlet weak var selectedImageView: UIView!
    @IBOutlet weak var profileView: UIView!
    
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
        selectedImageView.createShadowView(shadowOpacityValue: 0.3, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        profileView.createShadowView(shadowOpacityValue: 0.3, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))

        viewAsLbl.font = UIFont(name: Constants.Fonts.MontserratRegularFont, size: 15.0)
        
        self.imageSizeSegmentControl.selectedSegmentIndex = 0
        self.setSegmentFont(segment: self.imageSizeSegmentControl)
        
        /// Set Navigation Bar
        navigationController?.navigationBar.barTintColor = UIColor(named: Constants.Colors.primaryColor.rawValue)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Constants.Fonts.MontserratRegularFont, size: 16.0)!]
        navigationItem.title = currentUserObj[selectedIndexPath].user.name
        
        /// Set Default displayed image --> Small
        selectedImageStringURL =  currentUserObj[selectedIndexPath].user.profileImage.small
        selectedUserImgView.image = currentUserObj[selectedIndexPath].user.profileImage.small.toImage()
        
        profileImg.layer.borderColor = currentUserObj[selectedIndexPath].color.toUIColor
        profileImg.image = currentUserObj[selectedIndexPath].urls.thumb.toImage()
        usernameLbl.text = "@\(currentUserObj[selectedIndexPath].user.username)"
        linkLbl.text = currentUserObj[selectedIndexPath].links.html
        profileCreatedAtLbl.text = "Profile created at: \( currentUserObj[selectedIndexPath].createdAt.toDate()!)"

        
        /// Set target Download Button
        downloadBtn.addTarget(self, action: #selector(downloadDropDownAction), for: .touchUpInside)
        
        self.setDropDownMenu()
    }
    
    fileprivate func setDropDownMenu() {
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
                //self.handleDownloadImage()
                break
            case 1:
                //handleCopyURL()
                break
            case 2:
                // handleShareURL()
                break
            case 3:
                // XML
                print()
            default:
                print()
            }
        }
    }
    
    
    func handleDownloadImage(_ action: UIAlertAction) {
        // PNG
        let imageString = String(self.selectedImageStringURL)
        if let url = URL(string: imageString),
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func handleCopyURL(_ action: UIAlertAction) {
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
    }
    
    func handleShareURL(_ action: UIAlertAction) {
        // JSON - Share
        let activity = UIActivityViewController(activityItems: ["\(self.selectedImageStringURL)"], applicationActivities: nil)
        activity.excludedActivityTypes = [
            .postToWeibo,
            .print,
            .saveToCameraRoll,
            //addToReadingList,
            //.postToFlickr,
            .postToVimeo,
            .postToTencentWeibo,
            //.postToFacebook
            //.copyToPasteboard
        ]
        
        activity.popoverPresentationController?.sourceView = self.downloadBtn
        activity.popoverPresentationController?.sourceRect = self.downloadBtn.bounds
        self.present(activity, animated: true, completion: nil)
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
        func handleAlertAction(_ action: UIAlertAction){
            print("Selected action is : \(String(describing: action.title))")
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let download = UIAlertAction(title: "Save to Photo Album", style: .default, handler: handleDownloadImage)
        let downloadImg = UIImage(systemName: "square.and.arrow.up")
        download.setValue(downloadImg, forKey: "image")
        alertController.addAction(download)
    
        alertController.addAction(UIAlertAction(title: "Copy URL", style: .default, handler: handleCopyURL))
        alertController.addAction(UIAlertAction(title: "Share URL", style: .default, handler: handleShareURL))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: handleAlertAction))
        self.present(alertController, animated: true, completion: nil)
        //menu.show()
    }
 
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        guard error == nil else {
            print(error?.localizedDescription ?? "Error")
            self.displayAlertMessage(userTitle: "Error", userMessage: Constants.AlertMessages.DownloadError.stringValue)
            return
        }
        self.displayAlertMessage(userTitle: "Success", userMessage: Constants.AlertMessages.DownloadSuccess.stringValue)
    }
    
}// end of class
