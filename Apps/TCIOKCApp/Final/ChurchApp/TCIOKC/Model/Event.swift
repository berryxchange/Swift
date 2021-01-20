//
//  Event.swift
//  TCIApp
//
//  Created by Quinton Quaye on 1/11/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Event {
    var key: String
    var eventImage: String? = ""
    var eventIcon = ""
    var eventTitle = ""
    var eventSubtitle = ""
    var eventDescription = ""
    var eventdate = "\(Date())"
    var eventStartTime = ""
    var eventEndTime = ""
    var regularEventStartDate = "\(Date())"
    var regularEventEndDate = "\(Date())"
    var eventStartDate = ""
    var eventEndDate = ""
    var eventLocation = ""
    var peopleGoing = 0
    let ref: FIRDatabaseReference?
    
    init(key: String = "", eventImage: String, eventIcon: String, eventTitle: String, eventSubtitle: String, eventDescription: String, eventdate: String, eventStartTime: String, eventEndTime: String, regularEventStartDate : String, regularEventEndDate: String, eventStartDate: String, eventEndDate: String, eventLocation: String, peopleGoing: Int){
        
        self.key = key
        self.eventImage = eventImage
        self.eventIcon = eventIcon
        self.eventTitle = eventTitle
        self.eventSubtitle = eventSubtitle
        self.eventDescription = eventDescription
        self.eventdate = eventdate
        self.eventStartTime = eventStartTime
        self.eventEndTime = eventEndTime
        self.regularEventStartDate = regularEventStartDate
        self.regularEventEndDate = regularEventEndDate
        self.eventStartDate = eventStartDate
        self.eventEndDate = eventEndDate
        self.eventLocation = eventLocation
        self.peopleGoing = peopleGoing
        self.ref = nil
        
    }
        
        // database init for snapshot
        init(snapshot: FIRDataSnapshot){
            key = snapshot.key
            let snapShotValue = snapshot.value as! [String: AnyObject] // is a dictionary ie: [key : value] property
            eventImage = snapShotValue["eventImage"] as? String
            eventIcon = snapShotValue["eventIcon"] as! String
            eventTitle = snapShotValue["eventTitle"] as! String
            eventSubtitle = snapShotValue["eventSubtitle"] as! String
            eventDescription = snapShotValue["eventDescription"] as! String
            eventdate = snapShotValue["eventdate"] as! String
            eventStartTime = snapShotValue["eventStartTime"] as! String
            eventEndTime = snapShotValue["eventEndTime"] as! String
            
            regularEventStartDate = snapShotValue["regularEventStartDate"] as! String
            regularEventEndDate = snapShotValue["regularEventEndDate"] as! String
            eventStartDate = snapShotValue["eventStartDate"] as! String
            eventEndDate = snapShotValue["eventEndDate"] as! String
            eventLocation = snapShotValue["eventLocation"] as! String
            peopleGoing = snapShotValue["peopleGoing"] as! Int
            
            ref = snapshot.ref
        }
        
        
        
        func toAnyObject() -> Any{
            return [
                "eventImage": eventImage!,
                "eventIcon": eventIcon,
                "eventTitle": eventTitle,
                "eventSubtitle": eventSubtitle,
                "eventDescription": eventDescription,
                // for the display of the date
                "eventdate": eventdate,
                // for the display to show the needed time
                "eventStartTime": eventStartTime,
                "eventEndTime": eventEndTime,
                // for the list to arrange appropriately
                "regularEventStartDate": regularEventStartDate,
                "regularEventEndDate": regularEventEndDate,
                // for the date picker to show the needed dates and controls all needed date info
                "eventStartDate": eventStartDate,
                "eventEndDate": eventEndDate,
                "eventLocation": eventLocation,
                "peopleGoing": peopleGoing
            ]
        }
        
        
    }

