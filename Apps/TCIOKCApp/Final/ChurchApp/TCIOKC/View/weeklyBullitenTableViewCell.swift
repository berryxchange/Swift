//
//  weeklyBullitenTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 1/24/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class weeklyBullitenTableViewCell: UITableViewCell {

    @IBOutlet weak var weeklyTitle: UILabel!
    @IBOutlet weak var weeklyDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getBulliten(bulliten: Bulliten){
        self.weeklyTitle.text = bulliten.bullitenName
        self.weeklyDate.text = bulliten.bullitenDate
    }
}
