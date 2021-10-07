//
//  FetchingUsersTests.swift
//  DownloadManagerTests
//
//  Created by sy on 10/6/21.
//

import XCTest
@testable import DownloadManager

class FetchingUsersTests: XCTestCase {

//    var session: URLSession!
    
    override func setUp() {
        super.setUp()

    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
       // session = URLSession(configuration: .default)
    }
    
    override func tearDownWithError() throws {
        //session = nil
    }
    
    override func tearDown() {
        super.tearDown()
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
