//
//  UsersTableViewDataSource.swift
//  DownloadManager
//
//  Created by sy on 10/7/21.
//

import Foundation
import UIKit

class UsersTableViewDataSource<CELL: UITableViewCell, T> : NSObject, UITableViewDataSource {
    
    // MARK: - Variables
    var identifier: String!
    
    private var users : [T]!
    var configureUserCell : (CELL, T) -> () = {_,_ in }
       
       
    init(identifier: String, users : [T], configureUserCell : @escaping (CELL, T) -> ()) {
        self.identifier = identifier
        self.users = users
        self.configureUserCell = configureUserCell
    }
    
    // MARK: TableView Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! UserTableViewCell
        guard let cell: CELL = Bundle.main.loadNibNamed("UserTableViewCell", owner: self, options: nil)?.first as? CELL else {
            fatalError("Error: Undable to load User Table View Cell.")
        }
        cell.accessoryType = .disclosureIndicator

        let user = self.users[indexPath.row]
        self.configureUserCell(cell, user)
        return cell
    }
}
