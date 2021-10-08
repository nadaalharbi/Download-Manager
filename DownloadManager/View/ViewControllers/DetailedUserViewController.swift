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
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var linkBtn: UIButton!
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
    
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedImageView.createShadowView(shadowOpacityValue: 0.3, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        profileView.createShadowView(shadowOpacityValue: 0.3, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))

        viewAsLbl.font = UIFont(name: Constants.Fonts.MontserratRegularFont, size: 15.0)
        
        /// Setup open Unsplash link
        let icon = UIImage(systemName: "link")!
            linkBtn.setImage(icon, for: .normal)
        linkBtn.imageView?.contentMode = .scaleAspectFit
        linkBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        
        /// Set the default index of the SegmentControl
        self.imageSizeSegmentControl.selectedSegmentIndex = 0
        self.setSegmentFont(segment: self.imageSizeSegmentControl)
        
        /// Set Navigation Bar
        navigationController?.navigationBar.barTintColor = UIColor(named: Constants.Colors.primaryColor.rawValue)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Constants.Fonts.MontserratBoldFont, size: 17.0)!]
        navigationItem.title = currentUserObj[selectedIndexPath].user.name
        
        /// Set Default displayed image --> Small
        selectedImageStringURL =  currentUserObj[selectedIndexPath].user.profileImage.small
        selectedUserImgView.image = currentUserObj[selectedIndexPath].user.profileImage.small.toImage()
        
        profileImg.layer.borderColor = currentUserObj[selectedIndexPath].color.toUIColor.cgColor
        profileImg.image = currentUserObj[selectedIndexPath].urls.thumb.toImage()
        usernameLbl.text = "@\(currentUserObj[selectedIndexPath].user.username)"
        profileCreatedAtLbl.text = "Profile created at: \( currentUserObj[selectedIndexPath].createdAt.toDateFormat()!)"

        
        /// Set target Download Button
        downloadBtn.addTarget(self, action: #selector(downloadAlertAction), for: .touchUpInside)
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
            self.displayAlertMessage(userTitle: "Success", userMessage: Constants.AlertMessages.CopyAndOpenURL.stringValue, displayCancelAction: true) { (alert, action) in
                if action == .OK {
                    self.openLink(link: self.selectedImageStringURL)
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
        
        activity.popoverPresentationController?.sourceView = self.view// self.downloadBtn
        activity.popoverPresentationController?.sourceRect = self.view.bounds
        self.present(activity, animated: true, completion: nil)
    }
    
    
    @IBAction func openLinkAction(_ sender: UIButton) {
        let linkString = currentUserObj[self.selectedIndexPath].links.html
        self.openLink(link: linkString)
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
    
    func openLink(link: String){
        guard let url = URL(string: link) else { return }
        UIApplication.shared.open(url)
    }
    
    
    // MARK: - Selector Functions Objective-
    @objc func downloadAlertAction() {
        func handleAlertAction(_ action: UIAlertAction){
            print("Selected action is : \(String(describing: action.title))")
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        // 1. Download photo to PhotoAlbum after asking for permission
        let download = UIAlertAction(title: "Save to Photo Album", style: .default, handler: handleDownloadImage)
        let downloadIcon = UIImage(systemName: "square.and.arrow.up")
        download.setValue(downloadIcon, forKey: "image")
        alertController.addAction(download)
    
        // 2. Copy URL or image OR open it directly to Safari browser
        let copyURL = UIAlertAction(title: "Copy URL", style: .default, handler: handleCopyURL)
        let copyURLIcon = UIImage(systemName: "plus.square.on.square")
        copyURL.setValue(copyURLIcon, forKey: "image")
        alertController.addAction(copyURL)
        
        // 3. Share URL of the selected photo
        let shareURL = UIAlertAction(title: "Share URL", style: .default, handler: handleShareURL)
        let shareURLIcon = UIImage(systemName: "arrow.up.doc")
        shareURL.setValue(shareURLIcon, forKey: "image")
        alertController.addAction(shareURL)
        
        // Cancel/Dismiss the AlertControler
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
