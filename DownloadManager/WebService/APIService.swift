//
//  APIService.swift
//  DownloadManager
//
//  Created by sy on 10/3/21.
//

import Foundation
import Network
import UIKit

class APIService {
    
    private let urlString = "https://pastebin.com/raw/wgkJgazE"
    
    func getUsersData(completion: @escaping (Users?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let parsedJSON = try jsonDecoder.decode(Users.self, from: data)
                        DispatchQueue.main.async {
                            completion(parsedJSON, nil)
                        }
                    } catch {
                        print(error.localizedDescription)
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
