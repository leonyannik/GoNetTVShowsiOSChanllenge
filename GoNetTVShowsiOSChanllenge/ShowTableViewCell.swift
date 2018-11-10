//
//  ShowTableViewCell.swift
//  GoNetTVShowsiOSChanllenge
//
//  Created by Leon Yannik Lopez Rojas on 11/3/18.
//  Copyright © 2018 Leon Yannik Lopez Rojas. All rights reserved.
//

import UIKit

class ShowTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var showImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    // MARK: - Constants
    // MARK: - Variables
    var index = ""
    // MARK: - View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func assignImage() {
        self.showImageView.image = imagesCacheContent[index]
    }
    
    func imageFromServerURL(urlString: String, index: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                DispatchQueue.main.async {
                    self.showImageView.image = nil
                }
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imagesCacheContent[index] = image
                    self.assignImage()
                }
            }
        }).resume()
    }

}
