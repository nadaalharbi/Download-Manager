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
    
    @IBOutlet weak var welcomeView: UIView!
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeView.createShadowView(shadowOpacityValue: 0.3, shadowColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
        // Disable clicking of the button once clicked
        startBtn.isEnabled = true
        startBtn.isUserInteractionEnabled = true
        
        startBtn.layer.cornerRadius = 15.0
        startBtn.layer.masksToBounds = true
        
        versionNumber.text = Bundle.main.versionString
    }
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        // Disable clicking of the button once clicked
        sender.isEnabled = false
        sender.isUserInteractionEnabled = false
        if Reachability.isConnectedToNetwork() {
            self.performSegue(withIdentifier: "navigateToUsersVC", sender: self)
        }else{
            self.displayAlertMessage(userTitle: Constants.AlertMessages.ConnectionError.stringValue, userMessage: Constants.AlertMessages.ContinueWithNoInternet.stringValue, displayCancelAction: true){ (alert, action) in
                if action == .OK {
                    self.performSegue(withIdentifier: "navigateToUsersVC", sender: self)
                }
            }
        }
    }
}
