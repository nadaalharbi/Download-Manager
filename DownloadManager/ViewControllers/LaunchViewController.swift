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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.layer.cornerRadius = 15
        startBtn.layer.masksToBounds = true
    }
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        // Call service
        APIService.getUsersData()
        performSegue(withIdentifier: "navigateToUsersViewController", sender: self)
    }
    
}