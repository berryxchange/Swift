//
//  Food.swift
//  Foodzilla
//
//  Created by Quinton Quaye on 5/10/19.
//  Copyright © 2019 Quinton Quaye. All rights reserved.
//

import Foundation

struct Food{
    var foodImage: String?
    var foodName: String?
    var foodPrice: Double?
    
    init(foodImage: String?, foodName: String?, foodPrice: Double?){
        self.foodImage = foodImage
        self.foodName = foodName
        self.foodPrice = foodPrice
        
    }
}
