//
//  NewMessageControllerTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/9/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class NewMessageControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var occupation: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
