
//
//  YourMemberGroupsTableViewCell.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/17/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class YourMemberGroupsTableViewCell: UITableViewCell {

    @IBOutlet weak var groupImage: UIImageView!
    
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var groupMembers: UILabel!
    
    func getGroups(group: Group){
        self.groupName.text = group.groupName
        self.groupImage.loadImageUsingCacheWithURLString(urlString: group.groupImage!)
        self.groupMembers.text = "\(group.groupMemberCount!) Members"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
