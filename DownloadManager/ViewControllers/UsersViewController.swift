//
//  UsersViewController.swift
//  DownloadManager
//
//  Created by sy on 10/3/21.
//

import UIKit

class UsersViewController: UIViewController {
    
    
    @IBOutlet weak var usersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //APIService.getUsersData()
        usersTableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UsersTableViewCell")
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
        usersTableView.backgroundColor = .clear
        usersTableView.rowHeight = 88.0
        print("Nada: \(SharedModel.ElmUsers.count)")
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Nada - numberOfRowsInSection: \(SharedModel.ElmUsers.count)")
        return SharedModel.ElmUsers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UserTableViewCell = Bundle.main.loadNibNamed("UserTableViewCell", owner: self, options: nil)?.first as! UserTableViewCell
        //cell.delegate = self

        cell.usernameLbl?.text = SharedModel.ElmUsers[indexPath.row].user.name
        cell.userImgView.image = SharedModel.ElmUsers[indexPath.row].user.profileImage.small.toImage()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected cell is: \(SharedModel.ElmUsers[indexPath.row])")
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
