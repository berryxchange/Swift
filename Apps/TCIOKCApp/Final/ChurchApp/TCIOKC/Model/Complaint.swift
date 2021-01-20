//
//  Complaint.swift
//  ChurchAppOne
//
//  Created by Quinton Quaye on 11/9/18.
//  Copyright © 2018 Transformation Church International. All rights reserved.
//

import Foundation
import Firebase

struct Complaint{
    var complaintType: String?
    var complaintTitle: String?
    var complaintMessage: String?
    var reporterName: String?
    var reporterUID: String?
    var issueCreatorName: String?
    var issueCreatorUID: String?
    var complaintDate: String?
    var complaintNotes: String?
    var isResolved: String?
    //var linkData: [String:AnyObject]?
    var key: String
    let ref: FIRDatabaseReference?

    init(complaintType: String?, complaintTitle: String?, complaintMessage: String?, reporterName: String?, reporterUID: String?, issueCreatorName: String?, issueCreatorUID: String?, complaintDate: String?, isResolved: String?,complaintNotes: String?, key: String = ""){
        
        self.complaintType = complaintType
        self.complaintTitle = complaintTitle
        self.complaintMessage = complaintMessage
        self.reporterName = reporterName
        self.reporterUID = reporterUID
        self.issueCreatorName = issueCreatorName
        self.issueCreatorUID = issueCreatorUID
        self.complaintDate = complaintDate
        self.isResolved = isResolved
        self.complaintNotes = complaintNotes
        //self.linkData = linkData
        self.key = key
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        ref = snapshot.ref
        let snapShotValue = snapshot.value as! [String: AnyObject]
        complaintType = snapShotValue["complaintType"] as? String
        complaintType = snapShotValue["complaintType"] as? String
        complaintTitle = snapShotValue["complaintTitle"] as? String
        complaintMessage = snapShotValue["complaintMessage"] as? String
        reporterName = snapShotValue["reporterName"] as? String
        reporterUID = snapShotValue["reporterUID"] as? String
        issueCreatorName = snapShotValue["issueCreatorName"] as? String
        issueCreatorUID = snapShotValue["issueCreatorUID"] as? String
        complaintDate = snapShotValue["complaintDate"] as? String
        isResolved = snapShotValue["isResolved"] as? String
        complaintNotes = snapShotValue["complaintNotes"] as? String
        //linkData = snapShotValue["linkData"] as? [String:AnyObject]
    }
    
    func toAnyObject() -> Any {
        return [
            "complaintType" : complaintType!,
            "complaintTitle" : complaintTitle!,
            "complaintMessage" : complaintMessage!,
            "reporterName" : reporterName!,
            "reporterUID" : reporterUID!,
            "issueCreatorName" : issueCreatorName!,
            "issueCreatorUID" : issueCreatorUID!,
            "complaintDate": complaintDate!,
            "isResolved" : isResolved!,
            "complaintNotes" : complaintNotes!
            //"linkData" : linkData!
        ]
    }
}

