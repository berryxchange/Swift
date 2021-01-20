//
//  CalendarMeetupsTableViewCell.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/20/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class CalendarMeetupsTableViewCell: UITableViewCell {

    @IBOutlet weak var meetupTitle: UILabel!
    
    @IBOutlet weak var meetupDate: UILabel!
    @IBOutlet weak var parentGroup: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getMeetup(meetup: Meetup){
        self.meetupTitle.text = meetup.meetupName
        self.parentGroup.text = meetup.meetupParentName

    }
}
