//
//  Blog.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Blog {
    var key: String
    var blogTitle:  String?
    var blogMessage: String?
    var blogDate: String?
    var blogImage: String?
    var blogLikes: Int?
    var blogUniq: String?
    let ref: FIRDatabaseReference?
    
    init(key: String = "", blogTitle: String?, blogMesage: String?, blogDate: String?, blogImage: String?, blogLikes: Int?, blogUniq: String?){
        self.key = key
        self.blogTitle = blogTitle
        self.blogMessage = blogMesage
        self.blogDate = blogDate
        self.blogImage = blogImage
        self.blogLikes = blogLikes
        self.blogUniq = blogUniq
        
        self.ref = nil
        
    }
    
    // database init for snapshot
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapShotValue = snapshot.value as! [String: AnyObject] // is a dictionary ie: [key : value] property
        blogTitle = snapShotValue["blogTitle"] as? String
        blogMessage = snapShotValue["blogMessage"] as? String
        blogDate = snapShotValue["blogDate"] as? String
        blogImage = snapShotValue["blogImage"] as? String
        blogLikes = snapShotValue["blogLikes"] as? Int
        blogUniq = snapShotValue["blogUniq"] as? String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any{
        return [
            "blogTitle": blogTitle!,
            "blogMessage": blogMessage!,
            "blogDate": blogDate!,
            "blogImage": blogImage!,
            "blogLikes": blogLikes!,
            "blogUniq": blogUniq!
        ]
    }
    
}
