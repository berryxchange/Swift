//
//  UsersTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 1/23/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
class MessagesCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPostedText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
