//
//  AllGroupsCollectionViewCell.swift
//  GroupApp
//
//  Created by Quinton Quaye on 9/6/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class AllGroupsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryImageOverlay: UIView!
    
    @IBOutlet weak var groupName: UILabel!
    
    func getCategories(category: Category){
        self.groupName.text = category.categoryName
        
    }
    
    
}
