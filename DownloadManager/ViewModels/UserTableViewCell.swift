//
//  UserTableViewCell.swift
//  DownloadManager
//
//  Created by sy on 10/3/21.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    // MARK: - Variables
    static var reusableIdetifier: String{
        return String(describing: self)
    }
    private var dataTask: URLSessionDataTask?
    
    
    // MARK: - Functions
    func configure(username: String, url: URL?, session: URLSession) {
        self.usernameLbl.text = username
        
        // print("Is Main Thread? \(Thread.isMainThread)")
        if let url = url {
            // start animating
            self.activityIndicatorView.startAnimating()
            let dataTask = session.dataTask(with: url){ [weak self] (data, response, error) in
                guard let data = data else {
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
}
