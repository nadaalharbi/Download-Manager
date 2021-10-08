//
//  LaunchVCUnitTests.swift
//  DownloadManagerTests
//
//  Created by sy on 10/6/21.
//

import XCTest
import UIKit
@testable import DownloadManager

class LaunchVCUnitTests: XCTestCase {

    var launch: LaunchViewController!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        launch = LaunchViewController()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testFetchUsersWithNetwork() {
        let result = Reachability.isConnectedToNetwork()
        XCTAssertTrue(result)
    }
}
