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
        
        // test user cell identifer fount is not nil
        XCTAssertNotNil(userViewCell, "User View Cell Found")
    }
    
    func testFilteredUserEqualZero(){
        userViewController.filteredUsers = [UserModel]()
        userViewController.isSearchActive = true
        let result = userViewController.filteredUsers.count == 0 && userViewController.isSearchActive ? true : false
        
        // test if the count is Zero
        XCTAssertEqual(userViewController.filteredUsers.count, 0)
        
        // test both count is zero & search is active
        XCTAssertTrue(result, "Search is active & filtered is Zero")
    }
    
    func testFilteredUserIsGreaterThanZero() {
        userViewController.filteredUsers = [UserModel(id: "4kQA1aQK8-Y", color: "#060607", width: 2448, height: 1836, likes: 12, likedByUser: false, createdAt: "2016-05-29T15:42:02-04:00", user: User(id: "OevW4fja2No", username: "nicholaskampouris", name: "Nicholas Kampouris", profileImage: ProfileImage(small: "https://images.unsplash.com/profile-1464495186405-68089dcd96c3?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32&s=63f1d805cffccb834cf839c719d91702", medium: "https://images.unsplash.com/profile-1464495186405-68089dcd96c3?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=64&w=64&s=ef631d113179b3137f911a05fea56d23", large: "https://images.unsplash.com/profile-1464495186405-68089dcd96c3?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=128&w=128&s=622a88097cf6661f84cd8942d851d9a2"), links: UserLinks(userLinksSelf: "https://api.unsplash.com/users/nicholaskampouris", html: "http://unsplash.com/@nicholaskampouris", photos: "https://api.unsplash.com/users/nicholaskampouris/photos", likes: "https://api.unsplash.com/users/nicholaskampouris/likes")), currentUserCollections: [], urls: Urls(raw: "https://images.unsplash.com/photo-1464550883968-cec281c19761", full: "https://images.unsplash.com/photo-1464550883968-cec281c19761?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&s=4b142941bfd18159e2e4d166abcd0705", regular: "https://images.unsplash.com/photo-1464550883968-cec281c19761?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=1080&fit=max&s=1881cd689e10e5dca28839e68678f432", small: "https://images.unsplash.com/photo-1464550883968-cec281c19761?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=400&fit=max&s=d5682032c546a3520465f2965cde1cec", thumb: "https://images.unsplash.com/photo-1464550883968-cec281c19761?ixlib=rb-0.3.5&q=80&fm=jpg&crop=entropy&w=200&fit=max&s=9fba74be19d78b1aa2495c0200b9fbce"), categories: [Category(id: 4, photoCount: 46148, title: "Nature", links: CategoryLinks(categoryLinks: "https://api.unsplash.com/categories/4", photos: "https://api.unsplash.com/categories/4/photos")), Category(id: 6, photoCount: 15513, title: "People", links: CategoryLinks(categoryLinks: "https://api.unsplash.com/categories/6", photos: "https://api.unsplash.com/categories/6/photos"))], links: Links(linksSelf: "https://api.unsplash.com/photos/4kQA1aQK8-Y", html: "http://unsplash.com/photos/4kQA1aQK8-Y", download: "http://unsplash.com/photos/4kQA1aQK8-Y/download"))] //[UserModel]()
        XCTAssertGreaterThan(userViewController.filteredUsers.count, 0)
    }
    
    func testSeachTextIsEmpty() {
        let searcText = userViewController.usersSearchBar?.text!
        XCTAssertNil(searcText, "Search Text is Nil")
    }
}
