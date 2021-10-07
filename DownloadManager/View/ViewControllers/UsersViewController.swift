//
//  UsersViewController.swift
//  DownloadManager
//
//  Created by sy on 10/3/21.
//

import UIKit

class UsersViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var usersSearchBar: UISearchBar!
    @IBOutlet weak var usersTableView: UITableView!
    
    // MARK: - Variables
    var filteredUsers = [UserModel]()
    var currentUserObj = [UserModel]()
    
    // 3
    var userModelObj = [UserModel]()
    // 4
    var usersViewModel: UsersViewModel!
    var dataSource: UsersTableViewDataSource<UserTableViewCell, UserModel>!

    var selectedIndexPath: Int = 0
    var isSearchActive: Bool = false
    
    var refreshControl = UIRefreshControl()
    private lazy var session: URLSession = {
        print("Current Memory Capacity: \( URLCache.shared.memoryCapacity)")
        // change URLCache default size 
        URLCache.shared.memoryCapacity = 512 * 1024 * 1024
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        
        return URLSession(configuration: config)
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        /// Set Navigation Bar
        navigationController?.navigationBar.barTintColor = UIColor(named: Constants.Colors.primaryColor.rawValue)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont(name: Constants.Fonts.MontserratBoldFont, size: 17.0)!]
        self.title = "Download Manager"
        
        /// Set Back Button
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        let font = UIFont(name: Constants.Fonts.MontserratRegularFont, size: 17.0)
        backItem.setTitleTextAttributes([
                                            NSAttributedString.Key.font: font!, NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        self.navigationItem.backBarButtonItem = backItem
        
        /// Set Table View
        usersTableView.delegate = self
        usersTableView.dataSource = self
        usersTableView.backgroundColor = .clear
        
        /// Set Refresh Control
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh Users...")
        refreshControl.addTarget(self, action: #selector(self.refreshUsers(_:)), for: .valueChanged)
        usersTableView.addSubview(refreshControl)
        
        /// Set Search Bar
        self.setupSearchBar()
        
        
        
        // Todo test
        self.usersViewModel = UsersViewModel()
        self.usersViewModel.getUsersData() { data, error in
            self.usersTableView.reloadData()
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        filteredUsers.removeAll()
        isSearchActive = false
        usersSearchBar?.text = ""
    }
    
    // MARK: - Selector Functions (Objcetive-C)
    @objc func refreshUsers(_ sender: AnyObject) {
        
        self.usersViewModel.getUsersData() { data, error in
            self.usersTableView.reloadData()
        }
        
//        APIService.getUsersData(){ data, error in
//            if data != nil {
//                self.usersTableView.reloadData()
//                self.refreshControl.endRefreshing()
//            }else{
//                print(error?.localizedDescription ?? "error")
//            }
//        }
    }
    
    fileprivate func setupSearchBar() {
        usersSearchBar.delegate = self
        usersSearchBar.placeholder = "Search by Name"
        usersSearchBar.text = ""
        usersSearchBar.showsScopeBar = false
        usersSearchBar.showsCancelButton = true
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        self.displayAlertMessage(userTitle: "Logout", userMessage: "Are you sure you want to logout?", displayCancelAction: true) { (alert, action) in
            if action == .OK {
                
                let rootVC : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LaunchViewController") as! LaunchViewController
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,let sceneDelegate = windowScene.delegate as? SceneDelegate
                else {
                    return
                }
                sceneDelegate.window?.rootViewController = rootVC
            }
        }
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredUsers.count == 0 && isSearchActive {
            return 0
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return filteredUsers.count > 0 ? filteredUsers.count : usersViewModel.usersData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: UserTableViewCell = Bundle.main.loadNibNamed("UserTableViewCell", owner: self, options: nil)?.first as? UserTableViewCell else {
            fatalError("Error: Undable to load User Table View Cell.")
        }
        
        cell.accessoryType = .disclosureIndicator
        
        let users = isSearchActive ? filteredUsers : usersViewModel.usersData
        guard indexPath.row < users.count  else { return cell }
        
        cell.configure(username: users[indexPath.row].user.name, url: URL(string: users[indexPath.row].user.profileImage.medium), session: session)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let users = isSearchActive ? filteredUsers : usersViewModel.usersData
        guard indexPath.row < users.count  else { return }
        
        print("Selected cell is: \(users[indexPath.row])")
        self.selectedIndexPath = indexPath.row
        self.currentUserObj = users
        
        guard let detailedUserVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailedUserViewController") as? DetailedUserViewController else{
            return
        }
        
        detailedUserVC.selectedIndexPath = indexPath.row
        detailedUserVC.currentUserObj = users
        
        navigationController?.pushViewController(detailedUserVC, animated: true)
//        performSegue(withIdentifier: "detailedUserVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        
        view.addSubview(label)
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        
        switch tableView.numberOfRows(inSection: section) {
        case 0:
            label.text = "No Users"
        case 1:
            label.text = "One User"
        case 2:
            label.text = "Two Users"
        case 3...10:
            label.text = "\(tableView.numberOfRows(inSection: section)) \("Users")"
        default:
            label.text = "\(tableView.numberOfRows(inSection: section)) \("User")"
        }
        
        //label.font = UIFont(name: Constants.DroidNormal, size: 14.0)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        return view
    }
}// end of extension

extension UsersViewController: UISearchBarDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.usersSearchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchActive = false
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.usersSearchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.usersSearchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchActive = false
        self.usersSearchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let indexes = usersViewModel.usersData.enumerated().filter({$0.element.user.name.range(of: searchBar.text!, options: .caseInsensitive) != nil}).map{$0.offset}
        
        filteredUsers.removeAll()
        for i in indexes {
            if i < usersViewModel.usersData.count {
                filteredUsers.append(usersViewModel.usersData[i])
            }
        }
        
        if(searchText == ""){
            isSearchActive = false
        } else {
            isSearchActive = true
        }
        self.usersTableView.reloadData()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.usersSearchBar.endEditing(true)
        self.usersSearchBar.resignFirstResponder()
    }
}// end of extension
