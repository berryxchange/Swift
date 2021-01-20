//
//  FoodCollectionViewCell.swift
//  Foodzilla
//
//  Created by Quinton Quaye on 5/10/19.
//  Copyright © 2019 Quinton Quaye. All rights reserved.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var foodPrice: UILabel!
    
    func getFood(item: Food){
        self.foodImage.image = UIImage(named: item.foodImage!)
        self.foodName.text = item.foodName
        self.foodPrice.text = "\(item.foodPrice!)"
    }
}
