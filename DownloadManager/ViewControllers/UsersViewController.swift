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
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // MARK: - Variables
    var filteredUsers = [UserModel]()
    var currentUserObj = [UserModel]()
    
    var selectedIndexPath = 0
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font: UIFont(name: Constants.Fonts.MontserratRegularFont, size: 16.0)!]
//        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.title = "Download Manager"
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        usersTableView.backgroundColor = .clear
        
        // Set Refresh Control
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh Users")
        refreshControl.addTarget(self, action: #selector(self.refreshUsers(_:)), for: .valueChanged)
           usersTableView.addSubview(refreshControl)
        
        // Set Search Bar
        self.setupSearchBar()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        filteredUsers.removeAll()
        isSearchActive = false
        usersSearchBar?.text = ""
    }
    
    @objc func refreshUsers(_ sender: AnyObject) {
        DispatchQueue.main.async {
            APIService.getUsersData()
            self.usersTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
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
        self.displayAlertMessage(userTitle: "Warning", userMessage: "Are you sure you want to logout?", displayCancelAction: true) { (alert, action) in
            if action == .OK {
                
                let rootVC : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LaunchViewController") as! LaunchViewController
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,let sceneDelegate = windowScene.delegate as? SceneDelegate         else {
                   return
                }
                sceneDelegate.window?.rootViewController = rootVC
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let backItem = UIBarButtonItem()
           backItem.title = "Back"
           navigationItem.backBarButtonItem = backItem
        
        if segue.identifier == "detailedUserVC" {
            if let vc = segue.destination as? DetailedUserViewController {
                vc.selectedIndexPath = selectedIndexPath
                vc.currentUserObj = currentUserObj
            }
        }
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Nada - numberOfRowsInSection: \(SharedModel.ElmUsers.count)")
        //return SharedModel.ElmUsers.count
        
        if filteredUsers.count == 0 && isSearchActive {
            return 0
        } else {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return filteredUsers.count > 0 ? filteredUsers.count : SharedModel.ElmUsers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: UserTableViewCell = Bundle.main.loadNibNamed("UserTableViewCell", owner: self, options: nil)?.first as? UserTableViewCell else {
            fatalError("Error: Undable to load User Table View Cell.")
        }
        
        cell.accessoryType = .disclosureIndicator
        
        let users = isSearchActive ? filteredUsers : SharedModel.ElmUsers
        guard indexPath.row < users.count  else { return cell }
        
        // cell.usernameLbl?.text = SharedModel.ElmUsers[indexPath.row].user.name
        //cell.userImgView.image = SharedModel.ElmUsers[indexPath.row].user.profileImage.medium.toImage()
        cell.configure(username: users[indexPath.row].user.name, url: URL(string: users[indexPath.row].user.profileImage.medium), session: session)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let users = isSearchActive ? filteredUsers : SharedModel.ElmUsers
        guard indexPath.row < users.count  else { return }
        
        print("Selected cell is: \(users[indexPath.row])")
        self.selectedIndexPath = indexPath.row
        self.currentUserObj = users
    
        performSegue(withIdentifier: "detailedUserVC", sender: self)
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
        
        let indexes = SharedModel.ElmUsers.enumerated().filter({$0.element.user.name.range(of: searchBar.text!, options: .caseInsensitive) != nil}).map{$0.offset}
        
        filteredUsers.removeAll()
        for i in indexes {
            if i < SharedModel.ElmUsers.count {
                filteredUsers.append(SharedModel.ElmUsers[i])
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
