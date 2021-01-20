//
//  TableViewCell.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/16/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
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
    
    
}
