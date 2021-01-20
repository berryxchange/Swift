//
//  AdministratorControlTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/24/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase

class AdministratorControlTableViewCell: UITableViewCell {

    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var occupation: UILabel!
    
    
    @IBOutlet weak var userImagePad: UIView!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //var administratorControl : AdministratorControlViewController?
        
       
       
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
   
    
    
    func getUser(user: Member){
        self.userImage.image = UIImage(named: user.userImageUrl!)
        self.username.text = user.username
        self.occupation.text = user.role!
        
        
    }
    
    
    
}
