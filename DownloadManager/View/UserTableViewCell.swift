//
//  UserTableViewCell.swift
//  DownloadManager
//
//  Created by sy on 10/3/21.
//

import UIKit
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
    // Todo remove
    var user : UserModel? {
        didSet {
            usernameLbl.text = user?.user.name
            userImgView.image = user?.user.profileImage.small.toImage()
        }
    }
    
    // MARK: - Functions
    func configure(username: String, url: URL?, session: URLSession) {
        self.usernameLbl.text = username
        
        if let url = url {
            // start animating
            self.activityIndicatorView.startAnimating()
            let dataTask = session.dataTask(with: url){ [weak self] (data, response, error) in
                guard let _ = data else {
                    return
                }
                
                if let data = try? Data(contentsOf: url){
                    let image = UIImage(data: data)?.resizeImage(with: CGSize(width: 200.0, height: 200.0))
                    DispatchQueue.main.async {
                        self?.activityIndicatorView.stopAnimating()
                        self?.userImgView.image = image
                    }
                }
            }
            dataTask.resume()
            self.dataTask = dataTask
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
    
    
    //////////////////
    
    func getImage(imageURL: URL) -> Promise<UIImage> {
        
        // let imagePath = imageURL.path
        let request = URLRequest(url: imageURL)
        
        if (self.cache.cachedResponse(for: request) != nil) {
            return self.loadImageFromCache(imageURL: imageURL)
        } else {
            return self.downloadImage(imageURL: imageURL)
        }
    }
    
    func downloadImage(imageURL: URL) -> Promise<UIImage> {
        return Promise { seal in
            let request = URLRequest(url: imageURL)
            
            DispatchQueue.global().async {
                let dataTask = URLSession.shared.dataTask(with: imageURL) {data, response, _ in
                    if let data = data {
                        let cachedData = CachedURLResponse(response: response!, data: data)
                        self.cache.storeCachedResponse(cachedData, for: request)
                        seal.fulfill(UIImage(data: data)!)
                    }
                }
                dataTask.resume()
            }
        }
    }
    
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

