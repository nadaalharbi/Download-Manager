//
//  APIService.swift
//  DownloadManager
//
//  Created by sy on 10/3/21.
//

import Foundation
import Network
import UIKit

class APIService{
    
    enum EndPoints {
        static let urlString = "https://pastebin.com/raw/wgkJgazE"
        var url: URL {
            return URL(string: APIService.EndPoints.urlString)!
        }
    }
    
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
    
    class func getUsersData() {
        //        taskForPOSTRequest(url: URL(string: "https://pastebin.com/raw/wgkJgazE")!, responseType: User.self, body: "") { (response, error) in
        //            if response != nil {
        //                // core data
        //                if response != nil {
        //                    print(response!)
        //                }
        //            }
        //        }
        
        if let url = URL(string: "https://pastebin.com/raw/wgkJgazE") {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    let jsonDecoder = JSONDecoder()
                    do {
                        let parsedJSON = try jsonDecoder.decode(Response.self, from: data)
                        print(parsedJSON)
                        SharedModel.ElmUsers = parsedJSON
                        print(parsedJSON.count)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }
    
}
