//
//  DetailedUserViewController.swift
//  DownloadManager
//
//  Created by sy on 10/4/21.
//

import UIKit

class DetailedUserViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var selectedUserImgView: UIImageView!
    
    // MARK: - Variables
    var selectedIndexPath = Int()
    var currentUserObj = [UserModel]()

    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailedUserViewController: \(selectedIndexPath)")
        print("DetailedUserViewController: \(currentUserObj)")

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont(name: Constants.Fonts.MontserratRegularFont, size: 16.0)!]
        navigationItem.title = SharedModel.ElmUsers[selectedIndexPath].user.name//"User Info"
        
        
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        let font = UIFont(name: Constants.Fonts.MontserratRegularFont, size: 16.0)
        backItem.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)
        self.navigationItem.backBarButtonItem = backItem
        
        selectedUserImgView.image = SharedModel.ElmUsers[selectedIndexPath].user.profileImage.medium.toImage()
    }
}// end of class
