//
//  GroupMembersListTableViewCell.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/22/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class GroupMembersListTableViewCell: UITableViewCell {

    @IBOutlet weak var memberImage: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getMembers(member: Member){
        self.memberImage.loadImageUsingCacheWithURLString(urlString: member.userImageUrl!)
        self.memberName.text = "\(member.firstname!) \(member.lastname!)"
    }
    
}
