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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
