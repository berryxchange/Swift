//
//  Prayer.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Prayer {
    
    var key: String
    var prayerPostTitle = ""
    var prayerPostMessage = ""
    var prayerPostPersonName = ""
    var prayerPostDateMonth = ""
    var prayerPostDateDay = ""
    var prayerFullDate = ""
    var prayerPostAgreements = Int()
    var byUserName = ""
    let ref: FIRDatabaseReference?
    
    init(key: String = "", prayerPostTitle: String, prayerPostMessage: String, prayerPostPersonName: String, prayerPostDateMonth: String, prayerPostDateDay: String, prayerFullDate : String, prayerPostAgreements: Int,  byUserName: String){
        
        self.key = key
        self.prayerPostTitle = prayerPostTitle
        self.prayerPostMessage = prayerPostMessage
        self.prayerPostPersonName = prayerPostPersonName
        self.prayerPostDateMonth = prayerPostDateMonth
        self.prayerPostDateDay = prayerPostDateDay
        self.prayerFullDate = prayerFullDate
        self.prayerPostAgreements = prayerPostAgreements
        
        self.byUserName = byUserName
        self.ref = nil
        
    }
    
    // database init for snapshot
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapShotValue = snapshot.value as! [String: AnyObject] // is a dictionary ie: [key : value] property
        
        prayerPostTitle = snapShotValue["prayerPostTitle"] as! String
        prayerPostMessage = snapShotValue["prayerPostMessage"] as! String
        prayerPostPersonName = snapShotValue["prayerPostPersonName"] as! String
        prayerPostDateMonth = snapShotValue["prayerPostDateMonth"] as! String
        prayerPostDateDay = snapShotValue["prayerPostDateDay"] as! String
        prayerFullDate = snapShotValue["prayerFullDate"] as! String
        prayerPostAgreements = snapShotValue["prayerPostAgreements"] as! Int
        
        byUserName = snapShotValue["byUserName"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any{
        return [
            "prayerPostTitle": prayerPostTitle,
            "prayerPostMessage": prayerPostMessage,
            "prayerPostPersonName": prayerPostPersonName,
            "prayerPostDateMonth": prayerPostDateMonth,
            "prayerPostDateDay": prayerPostDateDay,
            "prayerFullDate" : prayerFullDate,
            "prayerPostAgreements": prayerPostAgreements,
            
            "byUserName": byUserName
            
        ]
    }
    
    func toOneObject() -> Any{
        return [ "prayerPostAgreements": prayerPostAgreements
        ]
    }
}
