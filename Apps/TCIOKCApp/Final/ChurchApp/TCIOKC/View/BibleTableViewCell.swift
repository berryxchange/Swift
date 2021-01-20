//
//  BibleTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 2/25/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class BibleTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getBooks(book: Books){
        self.nameLabel.text = book.name
    }

}
