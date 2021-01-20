//
//  ClassesCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/17/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class ClassesCell: UITableViewCell {

    @IBOutlet weak var nameText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func getClass(thisClass: ClassRoom){
        self.nameText.text = thisClass.className
        
    }
    
}
