//
//  Church.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/30/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import Foundation
import Firebase

struct Church {
    var key: String
    var address: String? = ""
    var telephone: String? = ""
    var mission: String? = ""
    var pastor: String? = ""
    var website: String? = ""
    let ref: FIRDatabaseReference?
    
    
    init(key: String = "",
         address: String, telephone: String, mission: String, pastor: String, website: String){
        self.key = key
        self.address = address
        self.telephone = telephone
        self.mission = mission
        self.pastor = pastor
        self.website = website
        self.ref = nil
        
    }
    
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapShotValue = snapshot.value as! [String: AnyObject]
        address = snapShotValue["address"] as? String
        telephone = snapShotValue["telephone"] as? String
        mission = snapShotValue["mission"] as? String
        pastor = snapShotValue["pastor"] as? String
        website = snapShotValue["website"] as? String
        
        ref = snapshot.ref
        
    }
    func toAnyObject() -> Any {
        return [
            "address": address,
            "telephone": telephone,
            "mission": mission,
            "pastor": pastor,
            "website": website
            
        ]
    }
    
}
