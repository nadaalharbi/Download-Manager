//
//  DetailedUserVCUnitTests.swift
//  DownloadManagerTests
//
//  Created by sy on 10/8/21.
//

import XCTest
@testable import DownloadManager

class DetailedUserVCUnitTests: XCTestCase {

    var detailedUser: DetailedUserViewController!
    
    override func setUp() {
        super.setUp()
        detailedUser = DetailedUserViewController()
    }
    
    func testPasteboardNotEmpty() {
        detailedUser.selectedImageStringURL = "https://images.unsplash.com/profile-1464495186405-68089dcd96c3?ixlib=rb-0.3.5&q=80&fm=jpg&crop=faces&fit=crop&h=32&w=32&s=63f1d805cffccb834cf839c719d91702"
        XCTAssertNotEqual(detailedUser.selectedImageStringURL, "", "URL not empty")
        XCTAssertNotEqual(detailedUser.selectedImageStringURL, nil, "URL not nil")
    }
    
    
    
    

}
