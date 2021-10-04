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
    var selectedIndexPath: Int?

    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.selectedIndexPath!)
        selectedUserImgView.image = SharedModel.ElmUsers[self.selectedIndexPath!].user.profileImage.medium.toImage()
    }
}
