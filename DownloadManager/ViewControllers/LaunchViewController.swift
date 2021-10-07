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
        
        startBtn.layer.cornerRadius = 15.0
        startBtn.layer.masksToBounds = true
        
        versionNumber.text = Bundle.main.versionString
    }
    
    func fetchingUsers(){
        if Reachability.isConnectedToNetwork() {
            self.performSegue(withIdentifier: "navigateToUsersVC", sender: self)
//
//            APIService.getUsersData() { data, error in
//                if data != nil {
//                    self.performSegue(withIdentifier: "navigateToUsersVC", sender: self)
//                }else{
//                    print(error?.localizedDescription ?? "Error")
//                }
//            }
        } else {
            self.displayAlertMessage(userTitle: Constants.AlertMessages.ConnectionError.stringValue, userMessage: Constants.AlertMessages.NoInternetConnection.stringValue)
            return
        }
    }
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        // Call service
        sender.isEnabled = false
        sender.isUserInteractionEnabled = false
        
        fetchingUsers()
    }
}
