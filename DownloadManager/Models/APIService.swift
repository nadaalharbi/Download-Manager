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
    
    static let urlString = "https://pastebin.com/raw/wgkJgazE"
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void){
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let jsonData = data else{
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                let responseObj = try JSONDecoder().decode(ResponseType.self, from: jsonData)
                DispatchQueue.main.async {
                    completion(responseObj, nil)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func getUsersData(completion: @escaping (Users?, Error?) -> Void) {
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let parsedJSON = try jsonDecoder.decode(Users.self, from: data)
                        SharedModel.ElmUsers = parsedJSON
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
