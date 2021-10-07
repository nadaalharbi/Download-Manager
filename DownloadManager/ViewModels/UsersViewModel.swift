//
//  UsersViewModel.swift
//  DownloadManager
//
//  Created by sy on 10/7/21.
//

import Foundation


class UsersViewModel: NSObject {
    
    //MARK: - Variables
    private var apiService: APIService!
    var usersData = [UserModel]()
    
    override init() {
        super.init()
        apiService = APIService()
    }
    
    // MARK: - Functions
    func getUsersData(completion: @escaping (Users?, Error?) -> Void) {
        self.apiService.getUsersData { (data, error) in
            if let data = data {
                print(#function, data)
                self.usersData = data
                completion(data, nil)
            } else {
                completion(nil, error)
            }
        }
    }
}
