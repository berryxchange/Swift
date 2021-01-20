//
//  Student.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/18/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//


import Foundation
import Firebase

struct Student {
    var key: String
    var username: String?
    var userImageUrl: String?
    var id: String?
    var firstname: String?
    var lastname: String?
    var email: String?
    var telephone: String?
    var bio: String?
    var role: String?
    var birthday: String?
    var anniversary: String?
    var profession: String?
    var address: String?
    var gender: String?
    var status: String?
    var work: String?
    var currentLevelStatus: String?
    var allergies: String?
    var hobbies: String?
    var parentName: String?
    var parentUserName: String?
    var parentUid: String?
    var parentImage: String?
    var parentEmail: String?
    var parentTelephone: String?
    var parentWorkTelephone: String?
    var studentSelected: Bool?
    let ref: FIRDatabaseReference?
    
    
    init(key: String = "", username: String, userImageUrl: String?, id: String?, firstname: String?, lastname: String?, email: String?, telephone: String?, bio: String?, role: String?, birthday: String?, anniversary: String?, profession: String?, address: String?, gender: String?, status: String?, work: String?, currentLevelStatus: String?, allergies: String?, hobbies: String?, parentName: String?, parentUserName: String?, parentUid: String?, parentImage: String, parentEmail: String?, parentTelephone: String?, parentWorkTelephone: String?, studentSelected: Bool){
        self.key = key
        self.username = username
        self.userImageUrl = userImageUrl
        self.id = id
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.telephone = telephone
        self.bio = bio
        self.role = role
        self.birthday = birthday
        self.anniversary = anniversary
        self.profession = profession
        self.address = address
        self.gender = gender
        self.status = status
        self.work = work
        self.currentLevelStatus = currentLevelStatus
        self.allergies = allergies
        self.hobbies = hobbies
        self.parentName = parentName
        self.parentUserName = parentUserName
        self.parentUid = parentUid
        self.parentImage = parentImage
        self.parentEmail = parentEmail
        self.parentTelephone = parentTelephone
        self.parentWorkTelephone = parentWorkTelephone
        self.studentSelected = studentSelected
        self.ref = nil
        
    }
    
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapShotValue = snapshot.value as! [String: AnyObject]
        
        username = snapShotValue["username"] as? String
        userImageUrl = snapShotValue["userImageUrl"] as? String
        id = snapShotValue["id"] as? String
        firstname = snapShotValue["firstname"] as? String
        lastname = snapShotValue["lastname"] as? String
        email = snapShotValue["email"] as? String
        telephone = snapShotValue["telephone"] as? String
        bio = snapShotValue["bio"] as? String
        role = snapShotValue["role"] as? String
        birthday = snapShotValue["birthday"] as? String
        anniversary = snapShotValue["anniversary"] as? String
        profession = snapShotValue["profession"] as? String
        address = snapShotValue["address"] as? String
        gender = snapShotValue["gender"] as? String
        status = snapShotValue["status"] as? String
        work = snapShotValue["work"] as? String
        currentLevelStatus = snapShotValue["currentLevelStatus"] as? String
        allergies = snapShotValue["allergies"] as? String
        hobbies = snapShotValue["hobbies"] as? String
        parentName = snapShotValue["parentName"] as? String
        parentUserName = snapShotValue["parentUserName"] as? String
        parentUid = snapShotValue["parentUid"] as? String
        parentImage = snapShotValue["parentImage"] as? String
        parentEmail = snapShotValue["parentEmail"] as? String
        parentTelephone = snapShotValue["parentTelephone"] as? String
        parentWorkTelephone = snapShotValue["parentWorkTelephone"] as? String
        studentSelected = snapShotValue["studentSelected"] as? Bool
        
        ref = snapshot.ref
        
    }
     func toAnyObject() -> Any{
        return [
            "username": username!,
            "userImageUrl": userImageUrl!,
            "id": id!,
            "firstname": firstname!,
            "lastname": lastname!,
            "email": email!,
            "telephone": telephone!,
            "bio": bio!,
            "role": role!,
            "birthday": birthday!,
            "anniversary": anniversary!,
            "profession": profession!,
            "address": address!,
            "gender": gender!,
            "status": status!,
            "work": work!,
            "currentLevelStatus": currentLevelStatus!,
            "allergies": allergies!,
            "hobbies": hobbies!,
            "parentName": parentName!,
            "parentUserName": parentUserName!,
            "parentUid": parentUid!,
            "parentImage": parentImage!,
            "parentEmail": parentEmail!,
            "parentTelephone": parentTelephone!,
            "parentWorkTelephone": parentWorkTelephone!,
            "studentSelected": studentSelected!
        ]
    }
    
}
