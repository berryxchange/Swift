//
//  Class.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/17/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import Foundation
import Firebase

struct ClassRoom {
    var key: String
    var className = ""
    var classTeacher = ""
    var classStartTime = ""
    var classEndTime = ""
    var classDays = ""
    var classBeginningDate = ""
    var classNumberOfStudents = 0
    let ref: FIRDatabaseReference?
    
    
    init(key: String = "", className: String, classTeacher : String, classStartTime: String, classEndTime: String,classDays: String, classBeginningDate : String, classNumberOfStudents : Int){
        self.key = key
        self.className = className
        self.classTeacher = classTeacher
        self.classStartTime = classStartTime
        self.classEndTime = classEndTime
        self.classDays = classDays
        self.classBeginningDate = classBeginningDate
        self.classNumberOfStudents = classNumberOfStudents
        self.ref = nil
        
    }
    
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapShotValue = snapshot.value as! [String: AnyObject]
        
        className = snapShotValue["className"] as! String
        classTeacher = snapShotValue["classTeacher"] as! String
        classStartTime = snapShotValue["classStartTime"] as! String
        classEndTime = snapShotValue["classEndTime"] as! String
        classDays = snapShotValue["classDays"] as! String
        classBeginningDate = snapShotValue["classBeginningDate"] as! String
        classNumberOfStudents = snapShotValue["classNumberOfStudents"] as! Int
        ref = snapshot.ref

    }
    func toAnyObject() -> Any {
        return [
        "className" : className,
        "classTeacher" : classTeacher,
        "classStartTime" : classStartTime,
        "classEndTime" : classEndTime,
        "classDays" : classDays,
        "classBeginningDate" : classBeginningDate,
        "classNumberOfStudents" : classNumberOfStudents
        ]
    }
    
}
