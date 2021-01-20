//
//  Attendance.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/20/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import Foundation
import Firebase

struct Attendance {
    var key: String
    var attendanceDate: String? = ""
    var attendanceStatus: String? = ""
    let ref: FIRDatabaseReference?
    
    
    
    init(key: String = "", attendanceDate: String, attendanceStatus: String){
        self.key = key
        self.attendanceDate = attendanceDate
        self.attendanceStatus = attendanceStatus
        self.ref = nil
        
    }
    
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapShotValue = snapshot.value as! [String: AnyObject]
    
        attendanceDate = snapShotValue["attendanceDate"] as? String
        attendanceStatus = snapShotValue["attendanceStatus"] as? String
        ref = snapshot.ref
        
    }
    func toAnyObject() -> Any{
        return [
            "attendanceDate":  attendanceDate ,
            "attendanceStatus": attendanceStatus
            
        ]
    }
    
}
