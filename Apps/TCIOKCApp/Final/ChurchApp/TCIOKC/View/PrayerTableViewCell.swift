//
//  PrayerTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit

class PrayerTableViewCell: UITableViewCell {

    @IBOutlet weak var prayerPostDateMonth: UILabel!
    @IBOutlet weak var prayerPostDateDay: UILabel!
    @IBOutlet weak var prayerPostTitle: UILabel!
    @IBOutlet weak var prayerPostPersonName: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getPrayer(prayer: Prayer){
        self.prayerPostDateMonth.text = prayer.prayerPostDateMonth
        self.prayerPostDateDay.text = prayer.prayerPostDateDay
        self.prayerPostTitle.text = prayer.prayerPostTitle
        self.prayerPostPersonName.text = prayer.byUserName
        
    }

}
