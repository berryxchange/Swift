//
//  GroupMembersCollectionViewCell.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/20/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class GroupMembersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var memberImage: UIImageView!
    
    func getMember(member: Member){
        self.memberImage.loadImageUsingCacheWithURLString(urlString: member.userImageUrl!)
    }
}
