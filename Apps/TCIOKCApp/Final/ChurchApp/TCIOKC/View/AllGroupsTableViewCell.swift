//
//  AllGroupsTableViewCell.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/24/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class AllGroupsTableViewCell: UITableViewCell {

    
    
    //@IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var category: Category?

    
    //@IBOutlet weak var groupMembers: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    // this sets the cells for the collection view
    func setCollectionViewDataSourceDelegate <D: UICollectionViewDataSource & UICollectionViewDelegate>(dataSourceDelegate: D, forRow row: Int){
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
    func collectionReloadData(){
        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }
    
    func getCategories(category: Category){
        
        
    }
   
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

