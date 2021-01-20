//
//  Group.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/18/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import Foundation
import Firebase

struct Group {
    var key: String
    var groupName: String?
    var groupParent: String?
    var groupLocation: String?
    var groupImage:String?
    var groupDescription: String?
    var groupCreatorUID: String?
    var groupMemberCount: Int?
    var Members: [String: AnyObject]?
    var Meetups: [String: AnyObject]?
    var category: String?
    var blockedMembers: [String: AnyObject]?
    
    
    let ref: FIRDatabaseReference?
    // members are of Members Model •
    // group meetup items are of Meetup Model •
    // group descussion is of Discussion Model •
    // group highlights are of the Highlights Model •
    // related topics are of the Related Topics Model •
    // group organizers are under the Organizers Model •
    
    init(key: String = "", groupName: String, groupParent: String, groupLocation: String, groupImage: String, groupDescription: String, groupCreatorUID: String, groupMemberCount: Int, Members: [String: AnyObject], Meetups: [String: AnyObject], category: String, blockedMembers: [String: AnyObject]?) {
        self.key = key
        self.groupName = groupName
        self.groupParent = groupParent
        self.groupLocation = groupLocation
        self.groupImage = groupImage
        self.groupDescription = groupDescription
        self.groupCreatorUID = groupCreatorUID
        self.groupMemberCount = groupMemberCount
        self.Members = Members
        self.Meetups = Meetups
        self.category = category
        self.blockedMembers = blockedMembers
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        let snapShotValue = snapshot.value as! [String: AnyObject]
        groupName = snapShotValue["groupName"] as? String
        groupParent = snapShotValue["groupParent"] as? String
        groupLocation = snapShotValue["groupLocation"] as? String
        groupImage = snapShotValue["groupImage"] as? String
        groupDescription = snapShotValue["groupDescription"] as? String
        groupCreatorUID = snapShotValue["groupCreatorUID"] as? String
        groupMemberCount = snapShotValue["groupMemberCount"] as? Int
        Members = snapShotValue["Members"] as? [String : AnyObject]
        Meetups = snapShotValue["Meetups"] as? [String : AnyObject]
        category = snapShotValue["category"] as? String
        blockedMembers = snapShotValue["blockedMembers"] as? [String : AnyObject]
        
        
        
        ref = snapshot.ref
        
    }
    
    func toAnyObject() -> Any{
        return [
            "groupName" : groupName!,
            "groupParent" : groupParent!,
            "groupLocation" : groupLocation!,
            "groupImage" : groupImage!,
            "groupDescription" : groupDescription!,
            "groupCreatorUID": groupCreatorUID!,
            "groupMemberCount": groupMemberCount!,
            "Members": Members!,
            "Meetups": Meetups!,
            "category": category!,
            "blockedMembers": blockedMembers!
            
        ]
    }
}



struct Member {
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
    
    
    init(key: String = "", username: String, userImageUrl: String?, id: String?, firstname: String?, lastname: String?, email: String?, telephone: String?, bio: String?, role: String?, birthday: String?, anniversary: String?, profession: String?, address: String?, gender: String?, status: String?, work: String?, currentLevelStatus: String?, allergies: String?, hobbies: String?, parentName: String?, parentUserName: String?, parentUid: String?, parentImage: String, parentEmail: String?, parentTelephone: String?, parentWorkTelephone: String?, studentSelected: Bool?){
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

struct Meetup{
    var key: String
    var meetupImage: String?
    var meetupName: String?
    var meetupGoingOrNot: Bool
    var meetupStartTime: String?
    var meetupEndTime: String?
    var meetupStartDate: String?
    var meetupEndDate: String?
    var meetupLocation: String?
    var meetupHost: String?
    var interested: Bool
    var meetupDescription: String?
    var meetupParentName: String?
    var MembersGoing: [String: AnyObject]?
    var fullMeetupStartDate: String?
    var meetupCancelled: Bool?
    var videoId: String?
    var videoTitle: String?
    var videoDescription: String?
    var videoThumbnailUrl: String?
    var videoDate: String?
    let ref: FIRDatabaseReference?
    
    init(key: String = "", meetupImage: String, meetupName: String, meetupGoingOrNot: Bool, meetupStartTime: String, meetupEndTime: String, meetupStartDate: String, meetupEndDate: String,  meetupLocation: String, meetupHost: String, interested: Bool, meetupDescription: String, meetupParentName: String, MembersGoing: [String: AnyObject], fullMeetupStartDate: String, meetupCancelled: Bool, videoId: String?, videoTitle: String?, videoDescription: String?, videoThumbnailUrl: String?, videoDate: String?){
        self.key = key
        self.meetupImage = meetupImage
        self.meetupName = meetupName
        self.meetupGoingOrNot = meetupGoingOrNot
        self.meetupStartTime = meetupStartTime
        self.meetupEndTime = meetupEndTime
        self.meetupStartDate = meetupStartDate
        self.meetupEndDate = meetupEndDate
        self.meetupLocation = meetupLocation
        self.meetupHost = meetupHost
        self.interested = interested
        self.meetupDescription = meetupDescription
        self.meetupParentName = meetupParentName
        self.MembersGoing = MembersGoing
        self.fullMeetupStartDate = fullMeetupStartDate
        self.meetupCancelled = meetupCancelled
        self.videoId = videoId
        self.videoTitle = videoTitle
        self.videoDescription = videoDescription
        self.videoThumbnailUrl = videoThumbnailUrl
        self.videoDate = videoDate
        self.ref = nil
    }
    init(snapshot: FIRDataSnapshot){
        let snapShotValue = snapshot.value as! [String: AnyObject]
        key = snapshot.key
        
        meetupImage = snapShotValue["meetupImage"] as? String
        meetupName = snapShotValue["meetupName"] as? String
        meetupGoingOrNot = snapShotValue["meetupGoingOrNot"] as! Bool
        meetupStartTime = snapShotValue["meetupStartTime"] as? String
        meetupEndTime = snapShotValue["meetupEndTime"] as? String
        meetupStartDate = snapShotValue["meetupStartDate"] as? String
        meetupEndDate = snapShotValue["meetupEndDate"] as? String
        meetupLocation = snapShotValue["meetupLocation"] as? String
        meetupHost = snapShotValue["meetupHost"] as? String
        interested = snapShotValue["interested"] as! Bool
        meetupDescription = snapShotValue["meetupDescription"] as? String
        meetupParentName = snapShotValue["meetupParentName"] as? String
        MembersGoing = snapShotValue["MembersGoing"] as? [String : AnyObject]
        fullMeetupStartDate = snapShotValue["fullMeetupStartDate"] as? String
        meetupCancelled = snapShotValue["meetupCancelled"] as? Bool
        videoId = snapShotValue["videoId"] as? String
        videoTitle = snapShotValue["videoTitle"] as? String
        videoDescription = snapShotValue["videoDescription"] as? String
        videoThumbnailUrl = snapShotValue["videoThumbnailUrl"] as? String
        videoDate = snapShotValue["videoDate"] as? String
        ref = snapshot.ref
    }
    func toAnyObject() -> Any{
        return [
            "meetupImage" : meetupImage!,
            "meetupName" : meetupName!,
            "meetupGoingOrNot" : meetupGoingOrNot,
            "meetupStartTime" : meetupStartTime!,
            "meetupEndTime": meetupEndTime!,
            "meetupStartDate" : meetupStartDate!,
            "meetupEndDate" : meetupEndDate!,
            "meetupLocation" : meetupLocation!,
            "meetupHost" : meetupHost!,
            "interested" : interested,
            "meetupDescription" : meetupDescription!,
            "meetupParentName": meetupParentName!,
            "MembersGoing": MembersGoing!,
            "fullMeetupStartDate": fullMeetupStartDate!,
            "meetupCancelled": meetupCancelled!,
            "videoId": videoId!,
            "videoTitle": videoTitle!,
            "videoDescription": videoDescription!,
            "videoThumbnailUrl": videoThumbnailUrl!,
            "videoDate": videoDate!
            
        ]
    }
    // people going are under members or collection? •
    // photo collection is under image collection Model? •
    // comments under  comments Model •
    // more from this group is meetup Model •
    // related topics is under a collection or relatedTopics Model? •
}

struct Organizer {
    var key: String
    var organizerName: String?
    var organizerUID: String?
    var organizerImage: String?
    let ref: FIRDatabaseReference?
    init(key: String = "", organizerName: String, organizerUID: String, organizerImage: String){
        self.key = key
        self.organizerName = organizerName
        self.organizerUID = organizerUID
        self.organizerImage = organizerImage
        self.ref = nil
    }
    init(snapshot: FIRDataSnapshot){
        let snapShotValue = snapshot.value as! [String: AnyObject]
        key = snapshot.key
        organizerName = snapShotValue["organizerName"] as? String
        organizerUID = snapShotValue["organizerUID"] as? String
        organizerImage = snapShotValue["organizerImage"] as? String
        ref = snapshot.ref
    }
    func toAnyObject() -> Any{
        return [
            "organizerName": organizerName!,
            "organizerUID": organizerUID!,
            "organizerImage": organizerImage!
        ]
    }
    
}

struct Comments {
    var key: String
    var memberName: String?
    var memberImage: String?
    var memberText: String?
    let ref: FIRDatabaseReference?
    
    init(key: String = "", memberName: String, memberImage: String, memberText: String){
        
        self.key = key
        self.memberName = memberName
        self.memberImage = memberImage
        self.memberText = memberText
        self.ref = nil
    }
    init(snapshot: FIRDataSnapshot){
        let snapShotValue = snapshot.value as! [String: AnyObject]
        key = snapshot.key
        memberName = snapShotValue["memberName"] as? String
        memberImage = snapShotValue["memberImage"] as? String
        memberText = snapShotValue["memberText"] as? String
        ref = snapshot.ref
    }
    func toAnyObject() -> Any{
        return [
            "memberName" : memberName!,
            "memberImage" : memberImage!,
            "memberText" : memberText!
        ]
    }
}

struct Discussion {
    var key: String
    let ref: FIRDatabaseReference?
    
    init(key: String = ""){
        self.key = key
        self.ref = nil
    }
    init(snapshot: FIRDataSnapshot){
        //let snapShotValue = snapshot.value as! [String: AnyObject]
        key = snapshot.key
        ref = snapshot.ref
    }
    func toAnyObject() -> Any{
        return [
            
        ]
    }
    //hold off...
}

struct Highlights {
    // just Imgae bank? or a collection?
    var key: String
    var highlightMeetupName: String?
    var highlightMeetupTime: String?
    var highlightMeetupDate: String?
    let ref: FIRDatabaseReference?
    
    init(key: String = "", highlightMeetupName: String, highlightMeetupTime: String, highlightMeetupDate: String){
        self.key = key
        self.highlightMeetupName = highlightMeetupName
        self.highlightMeetupTime = highlightMeetupTime
        self.highlightMeetupDate = highlightMeetupDate
        self.ref = nil
    }
    init(snapshot: FIRDataSnapshot){
        let snapShotValue = snapshot.value as! [String: AnyObject]
        key = snapshot.key
        highlightMeetupName = snapShotValue["highlightMeetupName"] as? String
        highlightMeetupTime = snapShotValue["highlightMeetupTime"] as? String
        highlightMeetupDate = snapShotValue["highlightMeetupDate"] as? String
        ref = snapshot.ref
    }
    func toAnyObject() -> Any{
        return [
            "highlightMeetupName" : highlightMeetupName!,
            "highlightMeetupTime" : highlightMeetupTime!,
            "highlightMeetupDate" : highlightMeetupDate!
        ]
    }
    
}


struct RelatedTopics {
    var key: String
    var topicName: String?
    let ref: FIRDatabaseReference?
    
    init(key: String = "", topicName: String){
        self.key = key
        self.topicName = topicName
        self.ref = nil
    }
    init(snapshot: FIRDataSnapshot){
        let snapShotValue = snapshot.value as! [String: AnyObject]
        key = snapshot.key
        topicName = snapShotValue["topicName"] as? String
        ref = snapshot.ref
    }
    func toAnyObject() -> Any{
        return [
            "topicName" : topicName!
        ]
    }
}

struct Category {
    var key: String
    var categoryName: String?
    var Groups: [Group]?
    
    let ref: FIRDatabaseReference?
    
    init(key: String = "", categoryName: String, Groups: [Group]){
        self.key = key
        self.categoryName = categoryName
        self.Groups = Groups
        self.ref = nil
    }
    init(snapshot: FIRDataSnapshot){
        let snapShotValue = snapshot.value as! [String: AnyObject]
        key = snapshot.key
        categoryName = snapShotValue["categoryName"] as? String
        
        let thisGroup = snapShotValue["Groups"] as? [String: AnyObject]
        
        var newGroups: [Group] = []
        if thisGroup?.values != nil{
            for (k, v) in thisGroup!{
                
                let t = v as! [String: AnyObject]
                
                var members : [String: AnyObject] = ["foo": NSNull.self]
                var meetups : [String: AnyObject] = ["foo": NSNull.self]
                var blockedMembers: [String: AnyObject] = ["foo": NSNull.self]
                
                if t["Members"] != nil{
                    members = t["Members"]! as! [String : AnyObject]
                }else{
                }
                
                
                if t["Meetups"] != nil{
                    meetups = t["Meetups"]! as! [String : AnyObject]
                }else{
                    print("no Meetup Data")
                    //= Meetup(meetupImage: "", meetupName: "", meetupGoingOrNot: false, meetupTime: "", meetupDate: "", meetupLocation: "", meetupHost: "", interested: false, meetupDescription: "", meetupParentName: "", MembersGoing: Member(memberImage: "", memberName: "", memberUID: "", memberLocation: "", memberAge: "", RSVPToCalendar: false, pushNotifications: false, emailNotification: false, showGroupsOnProfilePage: false, showInterestsOnProfilePage: false), fullMeetupDate: "")
                }
                
                if t["blockedMembers"] != nil{
                    members = t["blockedMembers"]! as! [String : AnyObject]
                }else{
                }
                //"\(t["groupName"]!)".lowercased()
                let groupedGroup = Group(key: "\(k)" ,groupName: "\(t["groupName"]!)", groupParent: "\(t["groupParent"]!)", groupLocation: "\(t["groupLocation"]!)", groupImage: "\(t["groupImage"]!)", groupDescription: "\(t["groupDescription"]!)", groupCreatorUID: "\(t["groupCreatorUID"]!)", groupMemberCount: t["groupMemberCount"] as! Int , Members: members, Meetups: meetups, category: "\(t["category"]!)", blockedMembers: blockedMembers)
                newGroups.append(groupedGroup)
                Groups = newGroups
            }
            
        }
        
        
        
        
        ref = snapshot.ref
    }
    func toAnyObject() -> Any{
        return [
            "categoryName" : categoryName!,
            "Groups" : Groups!
        ]
    }
}

class DetailGroup: NSObject {
    
    @objc var groupName: String?
    @objc var groupParent: String?
    @objc var groupLocation: String?
    @objc var groupImage:String?
    @objc var groupDescription: String?
    @objc var groupCreatorUID: String?
    @objc var groupMemberCount = Int()
    @objc var Members: [String: AnyObject]?
    @objc var Meetups: [String: AnyObject]?
    @objc var category: String?
    
}

struct GroupMessage{
    var chatImage: String?
    var chatName: String?
    var chatMessage: String?
    var chatPostTime: String?
    var key: String?
    var ref: FIRDatabaseReference?
    
    init(chatImage: String?, chatName: String?, chatMessage: String?, chatPostTime: String?, key: String? = ""){
        self.chatImage = chatImage
        self.chatName = chatName
        self.chatMessage = chatMessage
        self.chatPostTime = chatPostTime
        self.key = key
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        ref = snapshot.ref
        let snapShotValue = snapshot.value as! [String: AnyObject]
        chatImage = snapShotValue["chatImage"] as? String
        chatName = snapShotValue["chatName"] as? String
        chatMessage = snapShotValue["chatMessage"] as? String
        chatPostTime = snapShotValue["chatPostTime"] as? String
    }
    
    func toAnyObject() -> Any{
        return [
            "chatImage" : chatImage!,
            "chatName" : chatName!,
            "chatMessage" : chatMessage!,
            "chatPostTime" : chatPostTime!
        ]
    }
}
