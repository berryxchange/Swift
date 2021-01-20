//
//  Message.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/9/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase

@objcMembers
class Message: NSObject {
    
    var text: String?
    var toUid: String?
    var fromId: String?
    @objc var timestamp: NSNumber?
    var imageUrl: String?
    var imageHeight: NSNumber?
    var imageWidth: NSNumber?
    var videoUrl: String?
    var stringOfProfileImageView : String?
    var stringOfProfileName : String?
    var stringOfProfileUid : String?
    // for getting the partner image on the chat
    func chatPartnerId() -> String? {
        if fromId == FIRAuth.auth()?.currentUser?.uid {
            return toUid!
        } else {
            return fromId!
        }
    }
    
    init(dictionary: [String: AnyObject]){
        super.init()
        
        fromId = dictionary["fromId"] as? String
        text = dictionary["text"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        toUid = dictionary["toUid"] as? String
        
        imageUrl = dictionary["imageUrl"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
        videoUrl = dictionary["videoUrl"] as? String
    }
    
}
