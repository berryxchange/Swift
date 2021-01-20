//
//  GroupIntroTableViewCell.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/17/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class GroupIntroTableViewCell: UITableViewCell {
    @IBOutlet weak var moreMeetingTitle: UILabel!
    @IBOutlet weak var moreMeetingDate: UILabel!
    @IBOutlet weak var moreMeetingPeopleGoing: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func getMeetup(meetup: Meetup){
        self.moreMeetingTitle.text = meetup.meetupName
        self.moreMeetingDate.text = "\(meetup.meetupStartDate!), \(meetup.meetupStartTime!)"
        if meetup.MembersGoing == nil {
            self.moreMeetingPeopleGoing.text = "0 People Going"
        }else {
            self.moreMeetingPeopleGoing.text = "\(meetup.MembersGoing!.count) People Going"
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
