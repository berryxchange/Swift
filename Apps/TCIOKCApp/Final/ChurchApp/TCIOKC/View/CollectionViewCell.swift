//
//  CollectionViewCell.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/16/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionText: UILabel!

    @IBOutlet weak var groupImage: UIImageView!
    
    func getGroups(group: Group){
        self.collectionText.text = group.groupName
        
        self.groupImage.loadImageUsingCacheWithURLString(urlString: group.groupImage!)
    }
    
    

}
