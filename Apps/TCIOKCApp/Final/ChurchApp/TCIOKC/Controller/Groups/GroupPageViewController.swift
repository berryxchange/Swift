//
//  GroupPageViewController.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/18/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MessageUI

class GroupPageViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var groupScrollView: UIScrollView!
    @IBOutlet weak var groupName: UILabel!
    @IBOutlet weak var groupDetails: UILabel!
    @IBOutlet weak var organizerName: UILabel!
    
    @IBOutlet weak var messageOrganizerButton: UIButton!
    
    @IBOutlet weak var groupImage: UIImageView!
    
    @IBOutlet weak var numberOfMembers: UILabel!
    
    
    @IBOutlet weak var memberCollectionView: UICollectionView!
    
    @IBOutlet weak var meetupsCollectionView: UICollectionView!
    
    @IBOutlet weak var joinButton: UIButton!
    
    @IBOutlet weak var joinButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var membersCollectionTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var groupDetailView: UIView!
    
    @IBOutlet weak var organizerImage: UIImageView!
    
    @IBOutlet weak var meetupsCountLabel: UILabel!
    
    // report button
    
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var reportViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reportItem: UILabel!
    @IBOutlet weak var darkBackground: UIView!
    @IBOutlet weak var reportText: UITextView!
    @IBOutlet weak var submitReportButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    
    // var & let
    var group: Group!
    var data = meetupServer()
    var user : ChurchUser!
    var category = ""
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfUid = ""
    var members: [Member] = []
    var meetups: [Meetup] = []
    
    
    var defaultData: [Meetup] = [Meetup(meetupImage: "", meetupName: "No Meetups Happening", meetupGoingOrNot: false, meetupStartTime: "", meetupEndTime: "", meetupStartDate: "", meetupEndDate: "", meetupLocation: "", meetupHost: "", interested: false, meetupDescription: "", meetupParentName: "Your Calendar", MembersGoing: [:], fullMeetupStartDate: "", meetupCancelled: false, videoId: "", videoTitle: "", videoDescription: "",  videoThumbnailUrl: "", videoDate: "")]
    
    var peopleGoing = ["Tony Archer", "Kate Beckansale", "Kevin Backon", "Bruce Willis", "Michael Keaton", "Diane Sawyer", "Diane Keaton", "Westley Snipes"]
    
    
    var moreGroupMeetings = ["Decision Maker vs Action Taker with Jason Groelueschen", "The meeting after the meeting | Dinner with Entrepreneurs", "Women's Self-Improvement Meetup", "The Rules of Engagement", "The Laws of Motion"]
    
    var moreGroupMeetingsDates = ["Thu, Aug 23, 7:00 PM", "Thu, Aug 23, 9:00 PM", "Mon, Sep 3, 6:00 PM • Starbucks", "Fri, Sep 13, 7:00 PM", "Wed, Sep 23, 8:00 PM" ]
    
    var moreGroupMeetingsPeopleGoing = ["26", "3", "0", "52", "129"]
    
    var creators : [Member] = []
    var updatedCount = 0
    
    var blockedMembers: [Member] = []
    var administrator = ""
    
    override func viewWillAppear(_ animated: Bool) {
        
        // groups from firebase
        let ref = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("Members")
        
        
        ref.queryOrdered(byChild: "groupName").observe(.value, with: {snapshot in
            
            //print(snapshot)
            //2 new items are an empty array
            var newMembers: [Member] = []
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                print(item)
                let memberItem = Member(snapshot: item as! FIRDataSnapshot)
                newMembers.append(memberItem)
            }
            self.members = newMembers
            //print(self.members)
            self.memberCollectionView.reloadData()
            self.numberOfMembers.text = "\(self.members.count) Members"
            print(self.members.count)
            self.updatedCount = self.members.count
            self.view.reloadInputViews()
        })
        
        //  for meetups
        let meetupRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("Meetups")
        meetupRef.queryOrdered(byChild: "meetupName").observe(.value, with: {snapshot in
            
            //print(snapshot)
            //2 new items are an empty array
            var newMeetups: [Meetup] = []
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                print(item)
                let meetupItem = Meetup(snapshot: item as! FIRDataSnapshot)
                newMeetups.append(meetupItem)
            }
            self.meetups = newMeetups
            //print(self.members)
            self.meetupsCollectionView.reloadData()
            self.meetupsCountLabel.text = "(\(self.meetups.count))"
        })
        
        // for every app member
        FIRDatabase.database().reference().child("members").observe(.value, with: {(snapshot) in
            
            var thisMember: [Member] = []
            for item in snapshot.children{
                print(item)
                let memberItem = Member(snapshot: item as! FIRDataSnapshot)
                thisMember.append(memberItem)
            }
            self.creators = thisMember
            /*if let thisDictionary = snapshot.value as? [String: AnyObject] {
             let user = User()
             user.id = snapshot.key
             user.setValuesForKeys(thisDictionary)
             
             //print("this userName: \(user.username)")
             print("this userUID: \(user.id!)")
             self.creators.append(user)
             // print("The Creators: \(self.creators)")
             }*/
        }, withCancel: nil)
        fetchUserAndSetupNavBarTitle()
        
        //observes current group members, then updates the member count on the group Universally
        
        FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("Members").observe(.childAdded) { (snapshot) in
            self.updateMemberCount()
        }
        
        FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("blockedMembers").observe(.value) { (snapshot) in
            
            print(snapshot)
            var newBlockedMembers: [Member] = []
            
            for i in snapshot.children{
                let thisBlockedMember = Member(snapshot: i as! FIRDataSnapshot)
                newBlockedMembers.append(thisBlockedMember)
            }
            if self.group.groupCreatorUID == FIRAuth.auth()?.currentUser?.uid || FIRAuth.auth()?.currentUser?.uid == self.administrator {
                self.blockedMembers = newBlockedMembers
                print(self.blockedMembers)
            }else{
                self.blockedMembers = newBlockedMembers
                for i in newBlockedMembers{
                    self.members = self.members.filter{ $0.key != i.key}
                    print(self.members)
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func unwindToGroupPage(segue: UIStoryboardSegue){
        self.view.reloadInputViews()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
    }
    
    @IBAction func unwindToGroupPageFromDelete(segue: UIStoryboardSegue){
        self.view.reloadInputViews()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        meetupsCollectionView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // groupDetailView.frame.size = CGSize( width: groupDetailView.frame.size.width, height: 1050 + groupDetails.frame.size.height )
        //groupDetailView.heightAnchor.constraint(equalToConstant: 1050 +  groupDetails.frame.size.height).isActive = true
        
        print("pad height: \(groupDetailView.frame.size.height) ")
        print("text Detail height: \(groupDetails.frame.size.height) ")
        
        // get the meetupData
        let thisGroupRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)")
        thisGroupRef.observe(.value, with: {snapshot in
            print(self.group.key)
            print(snapshot)
            
            
            let GroupItem = Group(snapshot: snapshot)
            
            self.groupImage.loadImageUsingCacheWithURLString(urlString: GroupItem.groupImage!)
            self.groupImage.layer.masksToBounds = true
            self.groupName.text = GroupItem.groupName
            self.groupDetails.text = GroupItem.groupDescription
            self.category = GroupItem.category!
            self.view.reloadInputViews()
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
            
            
        })
        
        //self.reloadInputViews()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // report view
        self.hideKeyboardWhenTappedAround()
        reportViewTopConstraint.constant = 2000
        darkBackground.isHidden = true
        
        
        reportView.layer.cornerRadius = 4
        reportText.layer.borderWidth = 1
        reportText.layer.borderColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        
        reportItem.text = "\(group.groupName!) Group"
        
        submitReportButton.churchAppButtonRegular()
        
        cancelButton.churchAppButtonRegular()
        // end...
        
        // for header Navigation Bar
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isTranslucent = true
        
        
        
        
        
        organizerImage.image = UIImage(named: "theQ")
        organizerName.text = "Quinton Quaye"
        organizerImage.layer.cornerRadius = 50
        organizerImage.layer.masksToBounds = true
        organizerImage.layer.borderWidth = 1
        organizerImage.layer.borderColor = #colorLiteral(red: 0.5530076101, green: 0.5530076101, blue: 0.5530076101, alpha: 1)
        
        messageOrganizerButton.layer.cornerRadius = 4
        messageOrganizerButton.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        
        
        
        
        
    }
    
    // for tableView
    
    
    
    
    // for collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = Int()
        
        if collectionView == memberCollectionView{
            count = members.count
        }
        if collectionView == meetupsCollectionView{
            if meetups.count > 0 {
                count = meetups.count
            }else {
                count = defaultData.count
            }
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if collectionView == memberCollectionView{
            let thisCell = cell as? GroupMembersCollectionViewCell
            let thisMember = members[indexPath.row]
            thisCell?.getMember(member: thisMember)
            
            cell.layer.cornerRadius = 17.5
            cell.layer.masksToBounds = true
            
            cell.layer.borderWidth = 1
            cell.layer.borderColor = #colorLiteral(red: 0.5530076101, green: 0.5530076101, blue: 0.5530076101, alpha: 1)
            
        }
        if collectionView == meetupsCollectionView{
            let thisCell = cell as? MeetupCollectionViewCell
            if meetups.count  > 0 {
                let thisMeetup = meetups[indexPath.row]
                thisCell?.getMeetup(meetup: thisMeetup)
                thisCell?.meetupDate.text = "\(thisMeetup.meetupStartDate!), \(thisMeetup.meetupStartTime!)"
                if thisMeetup.MembersGoing == nil {
                    thisCell?.peopleAttending.text = "0 People Going"
                }else {
                    thisCell?.peopleAttending.text = "\(thisMeetup.MembersGoing!.count) People Going"
                }
            }else {
                let thisMeetup = defaultData[indexPath.row]
                thisCell?.getMeetup(meetup: thisMeetup)
                thisCell?.meetupDate.text = ""
                thisCell?.peopleAttending.text = ""
                
            }
            cell.layer.cornerRadius = 4
            cell.layer.masksToBounds = true
            cell.layer.borderWidth = 1
            cell.layer.borderColor = #colorLiteral(red: 0.5530076101, green: 0.5530076101, blue: 0.5530076101, alpha: 1)
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if collectionView == meetupsCollectionView{
            if meetups.count  > 0 {
                let controller = storyboard?.instantiateViewController(withIdentifier: "IntroGroupController") as! GroupIntroViewController
                
                controller.administrator = administrator
                controller.meetup = meetups[indexPath.row]
                controller.blockedMembers = blockedMembers
                controller.group = group
                if self.blockedMembers.contains( where: {$0.key == stringOfUid }){
                    print("Got ya B!!!")
                    //controller.isBlocked = true
                }else{
                    
                    print("Aint that a B!!!")
                    // controller.isBlocked = false
                }
                
                
                //controller.groupMembers = members
                //print(group)
                show(controller, sender: self)
                //present(controller, animated: true, completion: nil)
            }else{
                // do nothing
            }
        }
        
    }
    
    //@IBAction func backButton(_ sender: Any) {
    //  dismiss(animated: true, completion: nil)
    //}
    
    
    
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
        
        // if the current user UID is the group creatorUID then take that users UID and load it with the user firebase list and grab their info and display it as the organizer.
        
        
        
        print("This currentUserNow: \(stringOfUid)")
        for mem in members{
            
            if mem.key == stringOfUid || stringOfUid == group.groupCreatorUID{
                print("Found member!")
                // hide join button
                self.joinButton.isHidden = true
                self.joinButton.frame.size = CGSize(width: 200, height: 0)
                self.joinButtonTopConstraint.constant = 0
                self.membersCollectionTopConstraint.constant = -25
                // find the creator in the loaded list and rename organizer and add image
                
            }
        }
        
        for creator in creators{
            print(creator)
            if creator.key == self.group.groupCreatorUID {
                
                organizerName.text = creator.username
                organizerImage.loadImageUsingCacheWithURLString(urlString: creator.userImageUrl!)
                print("is the creator")
            }
        }
        
        if stringOfUid == group.groupCreatorUID || stringOfUid == administrator{
            print("this is the admin: \(administrator)")
            let addMeetupButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeetup))
            
            let editButtonItem: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editGroup))
            
            
            self.navigationItem.setRightBarButtonItems([editButtonItem, addMeetupButtonItem], animated: true)
        }else{
            print("this is the admin: \(administrator)")
        }
        
        if blockedMembers.contains(where: {$0.key == stringOfUid}){
            self.joinButton.isHidden = true
            self.joinButton.frame.size = CGSize(width: 200, height: 0)
            self.joinButtonTopConstraint.constant = 0
            self.membersCollectionTopConstraint.constant = -25
        }
    }
    
    
    func updateMemberCount(){
        let userMemberCountRef = FIRDatabase.database().reference(withPath: "Groups").child("\(self.group.key)")
        let memberCountRef = FIRDatabase.database().reference(withPath: "Categories").child("\(group.category!.lowercased())").child("Groups").child("\(self.group.key)")
        
        let memberCountItem = ["groupMemberCount": self.updatedCount]
        
        userMemberCountRef.updateChildValues(memberCountItem)
        memberCountRef.updateChildValues(memberCountItem)
    }
    
    @IBAction func joinButton(_ sender: Any) {
        
        self.joinButton.isHidden = true
        self.joinButton.frame.size = CGSize(width: 200, height: 0)
        self.joinButtonTopConstraint.constant = 0
        self.membersCollectionTopConstraint.constant = -25
        print("has passed checkpoint 1")
        postMember()
        postGroup()
        // posts the group to the users stored group database under "users/ membersCount"
        
    }
    
    func postMember(){
        // posts in the Group Members section
        let ref = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(group.key)").child("Members")
        
        // for main database
        let churchMembers = FIRDatabase.database().reference(withPath: "members")
        
        var churchUsers: [Member] = []
        churchMembers.queryOrdered(byChild: "lastname").observe(.value, with: {snapshot in
            
            var newMembers: [Member] = []
            
            for member in snapshot.children{
                let thisMember = Member(snapshot: member as! FIRDataSnapshot)
                newMembers.append(thisMember)
            }
            churchUsers = newMembers
            print("got members for check")
            print("has passed checkpoint 2")
            print("cross checking members from current user")
            print("current users: \( churchUsers)")
            for member in churchUsers{
                if member.key == self.stringOfUid{
                    print("Found you Too!")
                    
                    // for main database
                    let memberItem =
                        Member(username: member.username!, userImageUrl: member.userImageUrl!, id: member.id!, firstname: member.firstname!, lastname: member.lastname!, email: member.email!, telephone: member.telephone!, bio: member.bio!, role: member.role!, birthday: member.birthday!, anniversary: member.anniversary!, profession: member.profession!, address: member.address!, gender: member.gender!, status: member.status!, work: member.work!, currentLevelStatus: member.status!, allergies: member.allergies!, hobbies: member.hobbies!, parentName: member.parentName!, parentUserName: member.parentUserName!, parentUid: member.parentUid!, parentImage: member.parentImage!, parentEmail: member.parentEmail!, parentTelephone: member.parentTelephone!, parentWorkTelephone: member.parentWorkTelephone!, studentSelected: member.studentSelected!)
                    
                    //self.blogs.insert(blogItem, at: 0)
                    let memberItemRef = ref.child(self.stringOfUid)
                    memberItemRef.setValue(memberItem.toAnyObject())
                    print("placed User!")
                }
            }
        })
    }
    
    func postGroup(){
        // posts the Group name/key in the users groups section
        let groupItemRef = FIRDatabase.database().reference(withPath: "users").child(self.stringOfUid).child("Groups").child("\(group.key)")
        // for main database
        let groupItem = ["key": group.key, "groupName": "\(self.group.groupName!)", "groupParent": "\(self.group.groupParent!)", "groupLocation": self.group.groupLocation!, "groupImage": "\(self.group.groupImage!)", "groupDescription": self.group.debugDescription, "groupCreatorUID": self.group.groupCreatorUID!, "groupMemberCount": self.group.groupMemberCount!, "category": self.group.category!] as [String : Any]

        //self.blogs.insert(blogItem, at: 0)
        groupItemRef.updateChildValues(groupItem)
        
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func showMembersList(_ sender: Any) {
        if blockedMembers.contains(where: {$0.key == FIRAuth.auth()?.currentUser?.uid}) {
            
            // if is the creator
        }else if self.group.groupCreatorUID == stringOfUid{
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "someClassViewController") as!
            someClassViewController
            
            destinationController.category = group.category!
            destinationController.group = group
            destinationController.thisClassMembers = members
            destinationController.stringOfProfileImageView = stringOfProfileImageView
            destinationController.stringOfProfileName = stringOfProfileName
            destinationController.stringOfUid = stringOfUid
            destinationController.thisGroupKey = group.key
            
            show(destinationController, sender: self)
        }else{
            
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "MembersListController") as!
            GroupMembersViewController
            
            destinationController.isMeetup = false
            destinationController.group = group
            destinationController.blockedMembers = blockedMembers
            if self.group.groupCreatorUID == FIRAuth.auth()?.currentUser?.uid || FIRAuth.auth()?.currentUser?.uid == self.administrator {
                
            }else{
                destinationController.isRegular = true
                destinationController.members = members
                
            }
            self.navigationController?.show(destinationController, sender: self)
        }
    }
    
    @objc func addMeetup(){
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "AddMeetupController") as!
        NewGroupMeetupViewController
        
        destinationController.group = group
        destinationController.categoryName = category
        show(destinationController, sender: self)
    }
    
    @objc func editGroup(){
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "NewGroupController") as!
        NewGroupViewController
        
        destinationController.group = group
        destinationController.isEditingGroup = true
        self.navigationController?.present(destinationController, animated: true, completion: nil)
    }
    
    //sending Message
    @IBAction func messageButton(_ sender: Any) {
        print("I am going to send a mesaage!")
        
        let alert = UIAlertController(title: "How do you want to send your message", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "App Message", style: .default, handler: { _ in
            // function here
            self.internalMessage()
        }))
        /*if Semail == ""{
         }else {
         alert.addAction(UIAlertAction(title: "Email", style: .default, handler: { _ in
         // function here
         self.Email()
         }))
         }
         if Stelephone == ""{
         }else {
         alert.addAction(UIAlertAction(title: "Text Message", style: .default, handler: { _ in
         // function here
         self.TextMessage()
         }))
         }
         */
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func internalMessage(){
        
        let chatLogControllerOne = ChatLogControllerOne(collectionViewLayout: UICollectionViewFlowLayout())
        
        for creator in creators{
            if self.group.groupCreatorUID == creator.key{
                
                organizerName.text = creator.username
                organizerImage.loadImageUsingCacheWithURLString(urlString: creator.userImageUrl!)
            }
        }
        for creator in creators{
            if self.group.groupCreatorUID == creator.key{
                chatLogControllerOne.stringOfProfileUid = creator.key
                chatLogControllerOne.stringOfProfileName = creator.username!
                chatLogControllerOne.stringOfProfileImageView = creator.userImageUrl!
                print(creator.key)
                chatLogControllerOne.kind = 3
            }
        }
        
        
        show(chatLogControllerOne, sender: self)
        
    }
    
    let date = Date()
    let monthFormatter = DateFormatter()
    // for day
    let dayFormatter = DateFormatter()
    //for the full date
    let dateFormatter  = DateFormatter()
    
    @IBAction func reportPost(_ sender: Any) {
        reportViewTopConstraint.constant = 20
        reportItem.text = "\(group.groupName!) Group"
        darkBackground.isHidden = false
        groupScrollView.scrollToTop()
    }
    
    @IBAction func sendReportButton(_ sender: Any) {
        // append data to firebase
        
        let complaintRef = FIRDatabase.database().reference().child("Complaints")
        
        //for time format
        monthFormatter.dateFormat = "MM dd, yyyy"
        dayFormatter.dateFormat = "dd"
        dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
        for creator in creators{
            if self.group.groupCreatorUID == creator.key{
                
                // data to send
                let complaintData = Complaint(complaintType: "Group", complaintTitle: "\(group.groupName!) Group", complaintMessage: self.reportText.text, reporterName: stringOfProfileName, reporterUID: stringOfUid, issueCreatorName: creator.username, issueCreatorUID: group.groupCreatorUID , complaintDate: self.dateFormatter.string(from: Date()), isResolved: "false", complaintNotes: "" )
                
                
                let complaintItemRef = complaintRef.child("Group").childByAutoId()
                complaintItemRef.setValue(complaintData.toAnyObject())
                
                
                reportViewTopConstraint.constant = 2000
                darkBackground.isHidden = true
                reportText.text = "Place your issues here..."
                
            }
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        reportViewTopConstraint.constant = 2000
        darkBackground.isHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let newRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)")
        newRef.removeAllObservers()
        print("listeners removed!")
        
    }
    
    /* email composer
     func Email(){
     //Check if the device is capable to send email
     guard MFMailComposeViewController.canSendMail() else {
     return
     }
     
     let emailTitle = "Untitled"
     let messageBody = "Message: "
     // you can tweak this to send to all members
     let toRecipients = [Semail]
     
     // Initialize the mail composer and populate the mail content
     let mailComposer = MFMailComposeViewController()
     mailComposer.mailComposeDelegate = self
     mailComposer.setSubject(emailTitle)
     mailComposer.setMessageBody(messageBody, isHTML: false)
     mailComposer.setToRecipients(toRecipients)
     
     /*// determine the file and extension
     let fileparts = attachment.components(separatedBy: ".")
     let filename = fileparts[0]
     let fileExtension = fileparts[1]
     
     // Get the resource path and read the file using NSData
     guard let filePath = Bundle.main.path(forResource: filename, ofType: fileExtension) else {
     return
     }
     
     //Get the file data and MIME type
     if let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)), let mimeType = MIMEType(type: fileExtension) {
     
     // Add attachment
     mailComposer.addAttachmentData(fileData, mimeType: mimeType.rawValue, fileName: filename)
     
     // present mail view conroller on screen
     present(mailComposer, animated: true, completion: nil)
     }*/
     // present mail view conroller on screen
     present(mailComposer, animated: true, completion: nil)
     }
     
     func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
     switch result {
     case MFMailComposeResult.cancelled:
     print("Mail Cancelled")
     case MFMailComposeResult.saved:
     print("Mail Saved")
     case MFMailComposeResult.sent:
     print("Mail Sent")
     case MFMailComposeResult.failed:
     print("Mail Failed to Send: \(error!)")
     }
     dismiss(animated: true, completion: nil)
     }
     
     //end -------------
     
     func TextMessage(){
     // Check to see if the device is capable of sending text message
     guard MFMessageComposeViewController.canSendText() else {
     let alertMessage = UIAlertController(title: "SMS Unavailable", message: "Your device is not capable of sending SMS.", preferredStyle: .alert)
     alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
     present(alertMessage, animated: true, completion: nil)
     return
     }
     
     // prefill the SMS
     let messageController = MFMessageComposeViewController()
     messageController.messageComposeDelegate = self
     messageController.recipients = [Stelephone]
     messageController.body = "just sent this text message to you."
     
     // present message view controller on screen
     present(messageController, animated: true, completion: nil)
     }
     
     func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
     
     switch(result) {
     case MessageComposeResult.cancelled:
     print("SMS Cancelled")
     
     case MessageComposeResult.failed:
     let alertMessage = UIAlertController(title: "Failure", message: "Failed to send the message.", preferredStyle: .alert)
     alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
     present(alertMessage, animated: true, completion: nil)
     
     case MessageComposeResult.sent:
     print("SMS Sent!")
     }
     
     dismiss(animated: true, completion: nil)
     }
     //end-------
     */
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMembers"{
            let destinationController = segue.destination as! GroupMembersViewController
            destinationController.group = group
        }
        
    }
    
    
}
