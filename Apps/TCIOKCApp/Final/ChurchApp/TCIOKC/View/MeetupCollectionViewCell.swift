//
//  MeetupCollectionViewCell.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/19/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class MeetupCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var meetupTitle: UILabel!
    @IBOutlet weak var meetupDate: UILabel!
    @IBOutlet weak var peopleAttending: UILabel!
    
    
    
    func getMeetup(meetup: Meetup){
        self.meetupTitle.text = meetup.meetupName
        
    }
}
