//
//  LaunchViewController.swift
//  DownloadManager
//
//  Created by sy on 10/3/21.
//

import UIKit

class LaunchViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var versionNumber: UILabel!
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.layer.cornerRadius = 15
        startBtn.layer.masksToBounds = true
        
        versionNumber.font = UIFont(name: Constants.Fonts.MontserratLightFont, size: 14.0)
        versionNumber.textColor = .darkGray
        versionNumber.text = Bundle.main.versionString
    }
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        // Call service
        APIService.getUsersData()
        performSegue(withIdentifier: "navigateToUsersVC", sender: self)
    }
}
