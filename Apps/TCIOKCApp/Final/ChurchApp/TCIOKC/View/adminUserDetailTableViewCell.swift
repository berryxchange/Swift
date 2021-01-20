//
//  adminUserDetailTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 2/2/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class adminUserDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var UserRole: UILabel!
    
    @IBOutlet weak var onlnineIndecatorText: UILabel!
    
    @IBOutlet weak var onlineIndecator: UIImageView!
    
    @IBOutlet weak var viewBackground: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
