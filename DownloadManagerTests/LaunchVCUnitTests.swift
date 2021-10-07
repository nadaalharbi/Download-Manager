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

//    var session: URLSession!
    var launch: LaunchViewController!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        launch = LaunchViewController()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
//    func testFetchUsersWithNoNetwork() {
//        let result = Reachability.isConnectedToNetwork()
//        XCTAssertFalse(result, "Unable to create reachability")
//    }
    
    func testFetchUsersWithNetwork() {
        let result = Reachability.isConnectedToNetwork()
        XCTAssertTrue(result)
    }

    
    
//    func getUsersDataa() {
//        // given
//         let urlString =
//            "https://pastebin.com/raw/wgkJgazENada"
//         let url = URL(string: urlString)!
//         // 1
//         let promise = expectation(description: "Status code: 200")
//
//         // when
//         let dataTask = session.dataTask(with: url) { _, response, error in
//           // then
//           if let error = error {
//             XCTFail("Error: \(error.localizedDescription)")
//             return
//           } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
//             if statusCode == 200 {
//               // 2
//               promise.fulfill()
//             } else {
//               XCTFail("Status code: \(statusCode)")
//             }
//           }
//         }
//         dataTask.resume()
//         // 3
//         wait(for: [promise], timeout: 5)
//    }
}
