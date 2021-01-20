//
//  NewGroupMeetupViewController.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/24/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class NewGroupMeetupViewController: UIViewController, UITextFieldDelegate {
    var isEditingMeetup = false
    var categoryName = ""
    var group: Group!
    var meetup: Meetup!
    var hasVideo = false
    var video: Video!
    
    @IBOutlet weak var meetupTitle: UITextField!
    
    @IBOutlet weak var meetupStartDate: UITextField!
    @IBOutlet weak var meetupEndDate: UITextField!
    @IBOutlet weak var meetupLocation: UITextField!
    @IBOutlet weak var meetupDescription: UITextView!
    @IBOutlet weak var meetupStartTime: UITextField!
    @IBOutlet weak var meetupEndTime: UITextField!
    @IBOutlet weak var currentUserImage: UIImageView!
    @IBOutlet weak var currentUserImageBackground: UIView!
    @IBOutlet weak var currentUserIcon: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var eventVieoButton: UIButton!
    
    
    @IBOutlet weak var eventVideoText: UILabel!
    
    @IBOutlet weak var eventVideoDetailText: UILabel!
    
    @IBOutlet weak var finishedButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var cancelEventButton: UIButton!
    
   
    @IBOutlet weak var eventVideoSwitch: UISwitch!
    
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfUid = ""
    
    var eEditMeetupStartDate = ""
    var thisMeetupStartDate: String? = ""
    var thisMeetupRegularStartDate: String? = ""
    var regularMeetupStartDate = ""
    
    var eEditMeetupEndDate = ""
    var thisMeetupEndDate: String? = ""
    var thisMeetupRegularEndDate: String? = ""
    var regularMeetupEndDate = ""
    var administrator = ""
    var videoId: String?
    var videoTitle: String?
    var videoDescription: String?
    var videoThumbnailUrl: String?
    var videoDate: String?
    
    
    @IBAction func unwindVideoToMeetup(segue: UIStoryboardSegue){
        let videoSource = segue.source as! MediaTableViewController
        
        
        hasVideo = true
        videoId = videoSource.selectedVideo?.videoId
        videoTitle = videoSource.selectedVideo?.videoTitle
        videoDescription = videoSource.selectedVideo?.videoDescription
        videoThumbnailUrl = videoSource.selectedVideo?.videoThumbnailUrl
        videoDate = videoSource.selectedVideo?.videoDate
        eventVideoText.text = videoSource.selectedVideo?.videoTitle
        eventVideoDetailText.text = "Change video..."
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        eventVideoDetailText.textColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        eventVieoButton.isEnabled = false
        
        meetupStartDate.delegate = self
        meetupEndDate.delegate = self
        currentUserImage.layer.cornerRadius = 32.5
        currentUserImage.layer.masksToBounds = true
        currentUserImageBackground.layer.cornerRadius = 37.5
        currentUserIcon.tintColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        meetupDescription.layer.borderWidth = 0.5
        meetupDescription.layer.borderColor = #colorLiteral(red: 0.5530076101, green: 0.5530076101, blue: 0.5530076101, alpha: 1)
        meetupDescription.layer.cornerRadius = 4
        finishedButton.churchAppButtonRegular()
        cancelButton.churchAppButtonRegular()
        
        fetchUserAndSetupNavBarTitle()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
        let startDatePickerView: UIDatePicker = UIDatePicker()
        meetupStartDate.inputView = startDatePickerView
        
        
        
        // start date picker
        startDatePickerView.addTarget(self, action: #selector(self.startDatePickerValueChanged), for: UIControlEvents.valueChanged)
        
        
        // end date picker
        let endDatePickerView: UIDatePicker = UIDatePicker()
        meetupEndDate.inputView = endDatePickerView
        
        
        endDatePickerView.addTarget(self, action: #selector(self.endDatePickerValueChanged), for: UIControlEvents.valueChanged)
        
        
        
        
        if isEditingMeetup == true{
            if meetup.meetupCancelled == false{
                deleteButton.churchAppButtonEventCancel()
                deleteButton.setTitle("Cancel This Event", for: .normal)
                
            }else{
                deleteButton.churchAppButtonEventReinstate()
                deleteButton.setTitle("Reinstate This Event", for: .normal)
            }
            meetupTitle.text = meetup.meetupName
            meetupStartDate.text = meetup.meetupStartDate
            meetupEndDate.text = meetup.meetupEndDate
            meetupStartTime.text = meetup.meetupStartTime
            meetupEndTime.text = meetup.meetupEndTime
            meetupLocation.text = meetup.meetupLocation
            meetupDescription.text = meetup.meetupDescription
            eventVideoText.text = meetup.videoTitle
            if eventVideoText.text != ""{
                eventVideoDetailText.text = "Change video..."
            }else{
                
            }
            deleteButton.isHidden = false
            deleteButton.isEnabled = true
        }else{
            deleteButton.isHidden = true
            deleteButton.isEnabled = false
        }
        
    }
    
    
    
    // for start date
    @objc func startDatePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        meetupStartDate.text = DateFormatter.localizedString(from: sender.date, dateStyle: .full, timeStyle: .short)
        
        //for the date
        let thisDateFormatter = DateFormatter()
        let thisTimeFormatter = DateFormatter()
        let thisEntireDateFormatter = DateFormatter()
        thisDateFormatter.dateFormat = "MM/dd/yyyy"
        thisEntireDateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        
        meetupStartDate.text = thisEntireDateFormatter.string(from: sender.date)
        
        
        
        thisMeetupStartDate = thisDateFormatter.string(from: sender.date)
        print(thisMeetupStartDate!)
        
        let regularDateFormatter = DateFormatter()
        regularDateFormatter.dateStyle = .medium
        
        eEditMeetupStartDate = regularDateFormatter.string(from: sender.date)
        regularMeetupStartDate = regularDateFormatter.string(from: sender.date)
        thisMeetupRegularStartDate = regularDateFormatter.string(from: sender.date)
        meetupStartDate.text = thisDateFormatter.string(from: sender.date)
        
        // for the time
        thisTimeFormatter.timeStyle = .short
        meetupStartTime.text = thisTimeFormatter.string(from: sender.date)
        
        
        
    }
    
    
    // for end date
    @objc func endDatePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        meetupEndDate.text = DateFormatter.localizedString(from: sender.date, dateStyle: .full, timeStyle: .short)
        
        //for the date
        let thisDateFormatter = DateFormatter()
        let thisTimeFormatter = DateFormatter()
        let thisEntireDateFormatter = DateFormatter()
        thisDateFormatter.dateFormat = "MM/dd/yyyy"
        thisEntireDateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        
        meetupEndDate.text = thisEntireDateFormatter.string(from: sender.date)
        
        
        
        thisMeetupEndDate = thisDateFormatter.string(from: sender.date)
        print(thisMeetupStartDate!)
        
        let regularDateFormatter = DateFormatter()
        regularDateFormatter.dateStyle = .medium
        
        eEditMeetupEndDate = regularDateFormatter.string(from: sender.date)
        regularMeetupEndDate = regularDateFormatter.string(from: sender.date)
        thisMeetupRegularEndDate = regularDateFormatter.string(from: sender.date)
        meetupEndDate.text = thisDateFormatter.string(from: sender.date)
        
        // for the time
        thisTimeFormatter.timeStyle = .short
        meetupEndTime.text = thisTimeFormatter.string(from: sender.date)
        
        
        
    }
    
    @IBAction func finishButton(_ sender: Any) {
        let ref = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child(group.key).child("Meetups")
        
        let usersMeetupItemRef = FIRDatabase.database().reference(withPath: "users").child(self.stringOfUid).child("Meetups")
        
        
        
        if isEditingMeetup == true{
            // for the editing data
            if meetupTitle.text == "" || meetupStartDate.text == "" || meetupLocation.text == "" || meetupDescription.text == ""{
                let alert = UIAlertController(title: "Error", message: "Please fill in the blanks", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            } else {
                
                print("has passed checkpoint 1")
                
                
                //blog formatted items needed for the array
                var meetupItem: [String: String] = [:]
                
                if videoId == ""{
                    meetupItem = ["meetupName": "\(self.meetupTitle.text!)","meetupStartTime": "\(self.meetupStartTime.text!)", "meetupEndTime": "\(self.meetupEndTime.text!)", "meetupStartDate": "\(meetupStartDate.text!)", "meetupEndDate": "\(meetupEndDate.text!)", "meetupLocation": "\(meetupLocation.text!)","meetupDescription": "\(self.meetupDescription.text!)", "fullMeetupStartDate": "\(meetupStartDate.text!), \(meetupStartTime.text!)", "videoId": "\(meetup.videoId!)", "videoTitle": "\(meetup.videoTitle!)", "videoDescription": "\(meetup.videoDescription!)",  "videoThumbnailUrl": "\(meetup.videoThumbnailUrl!)", "videoDate": "\(meetup.videoDate!)"]
                }else if videoId != ""{
                    meetupItem = ["meetupName": "\(self.meetupTitle.text!)","meetupStartTime": "\(self.meetupStartTime.text!)", "meetupEndTime": "\(self.meetupEndTime.text!)", "meetupStartDate": "\(meetupStartDate.text!)", "meetupEndDate": "\(meetupEndDate.text!)", "meetupLocation": "\(meetupLocation.text!)","meetupDescription": "\(self.meetupDescription.text!)", "fullMeetupStartDate": "\(meetupStartDate.text!), \(meetupStartTime.text!)", "videoId": "\(videoId!)", "videoTitle": "\(videoTitle!)", "videoDescription": "\(videoDescription!)",  "videoThumbnailUrl": "\(videoThumbnailUrl!)", "videoDate": "\(videoDate!)"]
                }
                
                //self.blogs.insert(blogItem, at: 0)
                // for categories
                let meetupItemRef = ref.child(self.meetup.key)
                meetupItemRef.updateChildValues(meetupItem)
                
                // for the users data
                usersMeetupItemRef.child(self.meetup.key).updateChildValues(meetupItem)
                
                //postMeetupUpdate()
                self.performSegue(withIdentifier: "unwindToGroupMeetup", sender: self)
                
                
                print("has passed checkpoint 3")
                
                print("successfully stored event into Firebase DB")
                
            }
        }else{
            // not editing data but creating new
            if meetupTitle.text == "" || meetupStartDate.text == "" || meetupLocation.text == "" || meetupDescription.text == ""{
                let alert = UIAlertController(title: "Error", message: "Please fill in the blanks", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            } else {
                
                print("has passed checkpoint 1")
                
                if hasVideo == false{
                    let meetupItem = Meetup(meetupImage: "", meetupName: "\(self.meetupTitle.text!)", meetupGoingOrNot: true, meetupStartTime: "\(self.meetupStartTime.text!)", meetupEndTime: "\(self.meetupEndTime.text!)", meetupStartDate: "\(meetupStartDate.text!)", meetupEndDate: "\(meetupEndDate.text!)", meetupLocation: "\(meetupLocation.text!)", meetupHost: stringOfUid, interested: false, meetupDescription: "\(self.meetupDescription.text!)", meetupParentName: group.groupName!, MembersGoing: [:], fullMeetupStartDate: "\(meetupStartDate.text!), \(meetupStartTime.text!)", meetupCancelled: false, videoId: "none", videoTitle: "none", videoDescription: "none",  videoThumbnailUrl: "none", videoDate: "none")
                    
                    //self.blogs.insert(blogItem, at: 0)
                    let meetupItemRef = ref.child(self.meetupTitle.text!.lowercased())
                    meetupItemRef.setValue(meetupItem.toAnyObject())
                    
                    // for the users data
                    usersMeetupItemRef.child("\(self.meetupTitle.text!.lowercased())").setValue(meetupItem.toAnyObject())
                    
                    
                    
                    postMember()
                    //postMeetup()
                    postUsersMember()
                    
                    
                    self.performSegue(withIdentifier: "unwindToGroupPage", sender: self)
                    
                    
                    print("has passed checkpoint 3")
                    
                    print("successfully stored event into Firebase DB")
                }else{
                    let meetupItem = Meetup(meetupImage: "", meetupName: "\(self.meetupTitle.text!)", meetupGoingOrNot: true, meetupStartTime: "\(self.meetupStartTime.text!)", meetupEndTime: "\(self.meetupEndTime.text!)", meetupStartDate: "\(meetupStartDate.text!)", meetupEndDate: "\(meetupEndDate.text!)", meetupLocation: "\(meetupLocation.text!)", meetupHost: stringOfUid, interested: false, meetupDescription: "\(self.meetupDescription.text!)", meetupParentName: group.groupName!, MembersGoing: [:], fullMeetupStartDate: "\(meetupStartDate.text!), \(meetupStartTime.text!)", meetupCancelled: false, videoId: "\(videoId!)", videoTitle: "\(videoTitle!)", videoDescription: "\(videoDescription!)",  videoThumbnailUrl: "\(videoThumbnailUrl!)", videoDate: "\(videoDate!)")
                    
                    //self.blogs.insert(blogItem, at: 0)
                    let meetupItemRef = ref.child(self.meetupTitle.text!.lowercased())
                    meetupItemRef.setValue(meetupItem.toAnyObject())
                    
                    // for the users data
                    usersMeetupItemRef.child("\(self.meetupTitle.text!.lowercased())").setValue(meetupItem.toAnyObject())
                    
                    
                    
                    postMember()
                    //postMeetup()
                    postUsersMember()
                    
                    
                    self.performSegue(withIdentifier: "unwindToGroupPage", sender: self)
                    
                    
                    print("has passed checkpoint 3")
                    
                    print("successfully stored event into Firebase DB")
                }
            }
        }
    }
    
    func postMember(){
        // posts in the Group Members section
        let ref = FIRDatabase.database().reference(withPath: "Groups").child(self.group.key).child("Meetups").child(meetupTitle.text!.lowercased()).child("MembersGoing")
        // for main database
        
        let churchMembers = FIRDatabase.database().reference(withPath: "members")
        
        // posts in the Group Members section
        let usersRef = FIRDatabase.database().reference(withPath: "users").child(self.stringOfUid).child("Meetups").child("\(self.meetupTitle.text!.lowercased())").child("MembersGoing")
        
        // posts in the Categories Members section
        let categoryRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child(group.key).child("Meetups").child("\(self.meetupTitle.text!.lowercased())").child("MembersGoing")
        
        
        var churchUsers: [Member] = []
        churchMembers.queryOrdered(byChild: "lastname").observe(.value, with: {snapshot in
            
            var newMembers: [Member] = []
            
            for member in snapshot.children{
                let thisMember = Member(snapshot: member as! FIRDataSnapshot)
                newMembers.append(thisMember)
            }
            
            churchUsers = newMembers
            
            for member in churchUsers{
                if member.key == self.stringOfUid{
                    // for main database
                    let memberItem =
                        Member(username: member.username!, userImageUrl: member.userImageUrl!, id: member.id!, firstname: member.firstname!, lastname: member.lastname!, email: member.email!, telephone: member.telephone!, bio: member.bio!, role: member.role!, birthday: member.birthday!, anniversary: member.anniversary!, profession: member.profession!, address: member.address!, gender: member.gender!, status: member.status!, work: member.work!, currentLevelStatus: member.status!, allergies: member.allergies!, hobbies: member.hobbies!, parentName: member.parentName!, parentUserName: member.parentUserName!, parentUid: member.parentUid!, parentImage: member.parentImage!, parentEmail: member.parentEmail!, parentTelephone: member.parentTelephone!, parentWorkTelephone: member.parentWorkTelephone!, studentSelected: member.studentSelected!)
                    
                    //self.blogs.insert(blogItem, at: 0)
                    let memberItemRef = ref.child(self.stringOfUid)
                    memberItemRef.setValue(memberItem.toAnyObject())
                    
                    //secondary Items
                    let categoryMemberItemRef = categoryRef.child(self.stringOfUid)
                    
                    // for the meetup users data
                    let userMemberItemRef = usersRef.child(self.stringOfUid)
                    categoryMemberItemRef.setValue(memberItem.toAnyObject())
                    userMemberItemRef.setValue(memberItem.toAnyObject())
                    
                }
            }
        })
    }
    
    func postMeetup(){
        // posts the Group name/key in the users groups section
        //let usersMeetupItemRef = FIRDatabase.database().reference(withPath: "users").child(self.stringOfUid).child("Meetups").child("\(self.meetupTitle.text!.lowercased())")
        
        //let meetupItemRef = FIRDatabase.database().reference(withPath: "Categories").child(categoryName.lowercased()).child("Groups").child(group.key).child("Meetups").child("\(self.meetupTitle.text!.lowercased())")
        
        
        // for main database
        //let meetupItem = Meetup(meetupImage: "", meetupName: "\(self.meetupTitle.text!)", meetupGoingOrNot: true, meetupStartTime: "\(self.meetupStartTime.text!)", meetupEndTime: "\(self.meetupEndTime.text!)", meetupStartDate: "\(meetupStartDate.text!)", meetupEndDate: "\(meetupEndDate.text!)", meetupLocation: "\(meetupLocation.text!)", meetupHost: stringOfUid, interested: false, meetupDescription: "\(self.meetupDescription.text!)", meetupParentName
        //: group.groupName!, MembersGoing: [:], fullMeetupStartDate: "\(meetupStartDate.text!), \(meetupStartTime.text!)", meetupCancelled: false)
        
        //self.blogs.insert(blogItem, at: 0)
        //usersMeetupItemRef.setValue(meetupItem.toAnyObject())
        //meetupItemRef.setValue(meetupItem.toAnyObject())
        
        
    }
    
    
    @IBAction func eventVideoButton(_ sender: Any) {
        let destinationController = storyboard?.instantiateViewController(withIdentifier: "MediaTable") as! MediaTableViewController
        
        destinationController.isClass = true
        
        show(destinationController, sender: self)
        
    }
    
    @IBAction func postMeetupDelete(){
        let usersMeetupItemRef = FIRDatabase.database().reference(withPath: "users").child(self.stringOfUid).child("Meetups").child("\(self.meetup.key)")
        
        let meetupItemRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child(group.key).child("Meetups").child("\(self.meetup.key)")
        
        if meetup.meetupCancelled == false{
            // posts the Group name/key in the users groups section
            
            
            let alert = UIAlertController(title: "Cancel Event", message: "Are you sure you want to cancel this event?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .default) { action in
            }
            let deleteAction = UIAlertAction(title: "Yes", style: .default) { action in
                
                let eventCancelled = ["meetupCancelled": true]
                usersMeetupItemRef.updateChildValues(eventCancelled)
                meetupItemRef.updateChildValues(eventCancelled)
                self.performSegue(withIdentifier: "unwindToGroupMeetup", sender: self)
            }
            
            // actions of the alert controller
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            // action to present the alert controller
            present(alert, animated: true, completion: nil)
            
        }else if meetup.meetupCancelled == true{
            let alert = UIAlertController(title: "Reinstate Event", message: "Are you sure you want to reinstate this event?", preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "No", style: .default) { action in
            }
            let deleteAction = UIAlertAction(title: "Yes", style: .default) { action in
                
                let eventCancelled = ["meetupCancelled": false]
                usersMeetupItemRef.updateChildValues(eventCancelled)
                meetupItemRef.updateChildValues(eventCancelled)
                self.performSegue(withIdentifier: "unwindToGroupMeetup", sender: self)
            }
            
            // actions of the alert controller
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            
            // action to present the alert controller
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func postMeetupUpdate(){
        // posts the Group name/key in the users groups section
        //let usersMeetupItemRef = FIRDatabase.database().reference(withPath: "users").child(self.stringOfUid).child("Meetups").child("\(self.meetup.key)")
        
        //let meetupItemRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child(group.key).child("Meetups").child("\(self.meetup.key)")
        
        // for main database
        //let meetupItem = ["meetupName": "\(self.meetupTitle.text!)",  "meetupStartTime": "\(self.meetupStartTime.text!)", "meetupEndTime": "\(self.meetupEndTime.text!)", "meetupStartDate": "\(meetupStartDate.text!)", "meetupEndDate": "\(meetupEndDate.text!)", "meetupLocation": "\(meetupLocation.text!)", "meetupDescription": "\(meetupDescription.text!)", "fullMeetupStartDate": "\(meetupStartDate.text!), \(meetupStartTime.text!)"]
        
        //self.blogs.insert(blogItem, at: 0)
        //usersMeetupItemRef.updateChildValues(meetupItem)
        //meetupItemRef.updateChildValues(meetupItem)
        
        
    }
    
    
    func postUsersMember(){
        /* posts in the Group Members section
         /let usersRef = FIRDatabase.database().reference(withPath: "users").child(self.stringOfUid).child("Meetups").child("\(self.meetupTitle.text!.lowercased())").child("MembersGoing")
         
         // posts in the Categories Members section
         let ref = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child(group.key).child("Meetups").child("\(self.meetupTitle.text!.lowercased())").child("MembersGoing")
         
         // for main database
         let churchMembers = FIRDatabase.database().reference(withPath: "users")
         
         var churchUsers: [Member] = []
         churchMembers.queryOrdered(byChild: "lastname").observe(.value, with: {snapshot in
         
         var newMembers: [Member] = []
         
         for member in snapshot.children{
         let thisMember = Member(snapshot: member as! FIRDataSnapshot)
         newMembers.append(thisMember)
         }
         churchUsers = newMembers
         
         })
         
         for member in churchUsers{
         if member.key == self.stringOfUid{
         // for main database
         let memberItem =
         Member(username: member.username!, userImageUrl: member.userImageUrl!, id: member.id!, firstname: member.firstname!, lastname: member.lastname!, email: member.email!, telephone: member.telephone!, bio: member.bio!, role: member.role!, birthday: member.birthday!, anniversary: member.anniversary!, profession: member.profession!, address: member.address!, gender: member.gender!, status: member.status!, work: member.work!, currentLevelStatus: member.status!, allergies: member.allergies!, hobbies: member.hobbies!, parentName: member.parentName!, parentUserName: member.parentUserName!, parentUid: member.parentUid!, parentImage: member.parentImage!, parentEmail: member.parentEmail!, parentTelephone: member.parentTelephone!, parentWorkTelephone: member.parentWorkTelephone!, studentSelected: member.studentSelected!)
         
         
         
         //self.blogs.insert(blogItem, at: 0)
         let memberItemRef = ref.child(self.stringOfUid)
         let userMemberItemRef = usersRef.child(self.stringOfUid)
         memberItemRef.setValue(memberItem.toAnyObject())
         userMemberItemRef.setValue(memberItem.toAnyObject())
         
         }
         }
         */
    }
    
    
    
    
    
    func fetchUserAndSetupNavBarTitle(){
        // this pulls the user that is currently logged in and posts its name at the top of the navigation bar
        
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).child("thisUserInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //self.navigationItem.title = dictionary["username"] as? String
                
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupSocialPostWithUser(user: user)
            }
            
        }, withCancel: nil)
        
    }
    
    
    
    
    func setupSocialPostWithUser(user: User){
        
        print("this is the current user: \(user.username)")
        
        if let profileImageUrl = user.userImageUrl {
            stringOfProfileImageView = profileImageUrl
        }
        
        print(stringOfProfileImageView)
        
        stringOfProfileName = user.username
        stringOfUid = (FIRAuth.auth()?.currentUser?.uid)!
        //print("Image: \(stringOfProfileImageView), Name: \(stringOfProfileName), UID: \(stringOfUid)")
        
        
        // for adding a new meetup in the group
        
        currentUserImage.loadImageUsingCacheWithURLString(urlString: stringOfProfileImageView)
    }
    
    
    
    @IBAction func cancelButton(_ sender: Any) {
        // if is editing
        if isEditingMeetup == true{
            self.performSegue(withIdentifier: "unwindToGroupMeetupRegular", sender: self)
        }else if isEditingMeetup == false{
            // if is not editing
            self.performSegue(withIdentifier: "unwindToGroupPage", sender: self)
        }
    }
    
    
    
    @IBAction func isEventVideo(videoSwitch: UISwitch){
        
        if videoSwitch.isOn{
            eventVideoDetailText.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
            eventVieoButton.isEnabled = true
            
            
        }else{
            hasVideo = false
            eventVideoDetailText.textColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
            eventVieoButton.isEnabled = false
            eventVideoText.text = "None"
            eventVideoDetailText.text = "Select a video..."
        }
    }
    
    
    
    
    // MARK: - Navigation
    
    /* In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     }
     */
    
}
