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
    var isSearchActive: Bool = false
    var filteredUsers = [UserModel]()//Users()
    
    var selectedIndexPath: Int?
    
    private lazy var session: URLSession = {
        print( URLCache.shared.memoryCapacity)
        // change URLCache default size 
        URLCache.shared.memoryCapacity = 512 * 1024 * 1024
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .returnCacheDataElseLoad
        
        return URLSession(configuration: config)
    }()
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        //usersTableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UserTableViewCell")
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        usersTableView.backgroundColor = .clear
        print("Nada: \(SharedModel.ElmUsers.count)")
        
        self.setupSearchBar()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        filteredUsers.removeAll()
        isSearchActive = false
        usersSearchBar?.text = ""
    }
    
    fileprivate func setupSearchBar() {
        usersSearchBar.delegate = self
        usersSearchBar.placeholder = "Search by Name"
        usersSearchBar.text = ""
        usersSearchBar.showsScopeBar = false
        usersSearchBar.showsCancelButton = true
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailedUserViewController" {
            if let vc = segue.destination as? DetailedUserViewController {
                vc.selectedIndexPath = self.selectedIndexPath
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
        print("Selected cell is: \(SharedModel.ElmUsers[indexPath.row])")
        self.selectedIndexPath = indexPath.row
        print(self.selectedIndexPath)
        performSegue(withIdentifier: "detailedUserView", sender: self)
        
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
        case 3,4,5,6,7,8,9,10:
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
        
        let indexes = SharedModel.ElmUsers.enumerated().filter({$0.element.user.name.range(of: searchBar.text!) != nil}).map{$0.offset}
        
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
