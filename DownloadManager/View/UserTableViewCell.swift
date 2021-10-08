//
//  UserTableViewCell.swift
//  DownloadManager
//
//  Created by sy on 10/3/21.
//

import UIKit
// Async Library
import PromiseKit

class UserTableViewCell: UITableViewCell, ImageRepositoryProtocol {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - Variables
    static var reusableIdetifier: String{
        return String(describing: self)
    }
    
    let cache = URLCache.shared
    private var dataTask: URLSessionDataTask?
    
    // MARK: - Functions
    func configure(username: String, imageUrl: URL?) {
        self.usernameLbl.text = username
        if let url = imageUrl {
            self.getImage(imageURL: url)
                .done({ image in
                    self.userImgView.image = image
                    self.activityIndicatorView.stopAnimating()
                }).catch( { error in
                    print(error.localizedDescription)
                })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let image = userImgView {
            image.layer.cornerRadius = 10.0
            image.layer.masksToBounds = true
            image.contentMode = .scaleAspectFit
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        // Discard and clean object no longer used
        dataTask?.cancel()
        dataTask = nil
        userImgView.image = nil
    }
    
    
    // MARK: Image Repository
    /* 1. getImage() function
     It is used to determine whether or not we should get the image from the Webservice OR Cache.
     */
    func getImage(imageURL: URL) -> Promise<UIImage> {
        let request = URLRequest(url: imageURL)
        
        if (self.cache.cachedResponse(for: request) != nil) {
            // if image is found in cache load it
            return self.loadImageFromCache(imageURL: imageURL)
        } else {
            // if image is NOT found in download it from webservice
            self.activityIndicatorView.startAnimating()
            return self.downloadImage(imageURL: imageURL)
        }
    }
    
    /* 2. downloadImage() function
     It's used to download image from Webservice.
     then, It stors it to Cache
     */
    func downloadImage(imageURL: URL) -> Promise<UIImage> {
        return Promise { seal in
            let request = URLRequest(url: imageURL)
            DispatchQueue.global().async {
                let dataTask = URLSession.shared.dataTask(with: imageURL) {data, response, _ in
                    if let data = data {
                        let cachedData = CachedURLResponse(response: response!, data: data)
                        self.cache.storeCachedResponse(cachedData, for: request)
                        seal.fulfill(UIImage(data: data)!)// promise fulfillment
                    }
                }
                dataTask.resume()
            }
        }
    }
    
    /* 3. loadImageFromCache() function
     It's used to load image back from Cache instead of calling it from service again
     */
    func loadImageFromCache(imageURL: URL) -> Promise<UIImage> {
        return Promise { seal in
            let request = URLRequest(url: imageURL)
            
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = self.cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        seal.fulfill(image)
                    }
                }
            }
        }
    }
}
