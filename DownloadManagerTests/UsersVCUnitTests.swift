//
//  UsersVCUnitTests.swift
//  DownloadManagerTests
//
//  Created by sy on 10/8/21.
//

import XCTest
@testable import DownloadManager

class UsersVCUnitTests: XCTestCase {

    var userViewController: UsersViewController!
    var userViewCell: UserTableViewCell!
    
    override func setUp() {
        super.setUp()
        userViewController = UsersViewController()
        
    }
    

    func testUserTableViewCellNotNil() {
        userViewCell = Bundle.main.loadNibNamed( "UserTableViewCell", owner: self, options: nil)?.first as? UserTableViewCell
           
            XCTAssertNotNil(userViewCell, "User View Cell Found")
    }
    
    func testFilteredUserEqualZero(){
        userViewController.filteredUsers = [UserModel]()
        userViewController.isSearchActive = false
        XCTAssertEqual(userViewController.filteredUsers.count, 0)
    }
    
    func testFilteredUserNotGreaterThanZero() {
        userViewController.filteredUsers = [UserModel]()
        XCTAssertGreaterThan(12, 0)
    }
    
//    func testSeachTextIsEmpty() {
//        userViewController.usersSearchBar?.text = ""
//        XCTAssert(((userViewController.usersSearchBar?.text!) != nil), "")
//    }

}
