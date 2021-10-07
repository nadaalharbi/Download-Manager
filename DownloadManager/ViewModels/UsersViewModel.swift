//
//  UsersViewModel.swift
//  DownloadManager
//
//  Created by sy on 10/7/21.
//

import Foundation


class UsersViewModel: NSObject {
    
    private var apiService: APIService!
   // private(set)
    // 1
    var usersData = [UserModel]() //{
//            didSet {
//                self.bindUsersViewModelToController()
//            }
//        }
//
//    var bindUsersViewModelToController : (() -> ()) = {}
    
    override init() {
        super.init()
        apiService = APIService()
        //self.getUsersData(completion: <#Result<Users, Error>#>)
    }
    
    //2.
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
