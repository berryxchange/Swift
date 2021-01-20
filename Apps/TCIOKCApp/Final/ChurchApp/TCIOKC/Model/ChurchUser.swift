//
//  ChurchUser.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/29/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import Foundation
import FirebaseAuth
struct ChurchUser {
    
    var uid: String // for firebase unique id
    var userName: String
    var admin: Bool
    var userImage: String
    var firstname: String?
    var lastname: String?
    var birthday: String?
    // stadard init
    init(uid: String, userName: String, admin: Bool, userImage: String, firstname: String?, lastname: String?, birthday: String? ){
        
        self.uid = uid
        self.userName = userName
        self.admin = admin
        self.userImage = userImage
        self.firstname = firstname
        self.lastname = lastname
        self.birthday = birthday
    }
    
    // firebase authorization init
    init(authData: FIRUser){
        uid = authData.uid
        userName = authData.email!
        admin = false
        userImage = ""
        firstname = ""
        lastname = ""
        birthday = ""
        
    }
    
    func toAnyObject() -> Any{
        return [
            "uid" : uid,
            "userName" : userName,
            "admin" : admin,
            "userImage" : userImage,
            "firstname" : firstname!,
            "lastname" : lastname!,
            "birthday" : birthday!
        ]
    }
    
    func setValuesForKeys(dictionary: NSDictionary) -> Any{
        return [
            "uid" : uid,
            "userName" : userName,
            "admin" : admin,
            "userImage" : userImage,
            "firstname" : firstname!,
            "lastname" : lastname!,
            "birthday" : birthday!
        ]
    }
    
}

