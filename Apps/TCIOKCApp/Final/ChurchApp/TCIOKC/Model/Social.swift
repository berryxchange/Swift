//
//  Social.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/27/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct SocialMediaPost {
    
    var key: String
    
    var socialMediaIcon: String? = ""
    
    var byUserName = ""
    
    var timeAndDate = ""
    
    var userUploadImage: String? = ""
    
    var userPostLikes = Int()
    
    var userIcon: String? = ""
    
    var userPostTitle = ""
    
    var socialDetails = ""
    
    
    var socialUniq = ""
    
    let ref: FIRDatabaseReference?
    
    init(key: String = "", socialMediaIcon: String, byUserName: String, timeAndDate: String, userUploadImage: String, userPostLikes: Int, userIcon: String,userPostTitle: String, socialDetails: String, socialUniq: String) {
        
        self.key = key
        self.socialMediaIcon = socialMediaIcon
        self.byUserName = byUserName
        self.timeAndDate = timeAndDate
        self.userUploadImage = userUploadImage
        self.userPostLikes = userPostLikes
        self.userIcon = userIcon
        self.userPostTitle = userPostTitle
        self.socialDetails = socialDetails
        self.socialUniq = socialUniq
        self.ref = nil
        
    }
    
    // database init for snapshot
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapShotValue = snapshot.value as! [String: AnyObject] // is a dictionary id: [key: Value] property
        socialMediaIcon = snapShotValue["socialMediaIcon"] as? String
        byUserName = snapShotValue["byUserName"] as! String
        timeAndDate = snapShotValue["timeAndDate"] as! String
        userUploadImage = snapShotValue["userUploadImage"] as? String
        userPostLikes = snapShotValue["userPostLikes"] as! Int
        userIcon = snapShotValue["userIcon"] as? String
        userPostTitle = snapShotValue["userPostText"] as! String
        socialDetails = snapShotValue["socialDetails"] as! String
        socialUniq = snapShotValue["socialUniq"] as! String
        ref = snapshot.ref
        
    }
    
    
    func toAnyObject() -> Any{
        return [
            "socialMediaIcon": socialMediaIcon!,
            "byUserName": byUserName,
            "timeAndDate": timeAndDate,
            "userUploadImage": userUploadImage!,
            "userPostLikes": userPostLikes,
            "userIcon": userIcon!,
            "userPostText": userPostTitle,
            "socialDetails": socialDetails,
            "socialUniq": socialUniq,
            
        ]
    }
    
}
