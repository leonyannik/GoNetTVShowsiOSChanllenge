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
    // MARK: - View lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
