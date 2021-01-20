//
//  EventsCollectionViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 1/11/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class EventsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    
    @IBOutlet weak var totalCellFront: UIView!
    @IBOutlet weak var totalCell: UIView!
    
    /*func getEvents(event: Event){
        self.eventIcon.image = UIImage(named: event.eventIcon)
        self.eventImage.image = UIImage(named: event.eventImage!)
        self.eventTitle.text = event.eventTitle
        self.eventDate.text = event.eventdate
        self.eventTime.text = event.eventTime
    }
 */
}
 
