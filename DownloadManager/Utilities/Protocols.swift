//
//  Protocols.swift
//  DownloadManager
//
//  Created by sy on 10/6/21.
//

import Foundation
import UIKit
// Async library
import PromiseKit

protocol ImageRepositoryProtocol: class {
    func getImage(imageURL: URL) -> Promise<UIImage>
    func downloadImage(imageURL: URL) -> Promise<UIImage>
    func loadImageFromCache(imageURL: URL) -> Promise<UIImage>
}


