//
//  GroupIntroViewController.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/17/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MapKit
import EventKitUI

class GroupIntroViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource{
    // Outlets
    //@IBOutlet weak var groupImageBackground: UIView!
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var groupDetailButtonIndecator: UIImageView!
    @IBOutlet weak var peopleGoingIndecator: UIImageView!
    @IBOutlet weak var peopleGoingText: UILabel!
    @IBOutlet weak var groupDetailButton: UIButton!
    @IBOutlet weak var groupName: UILabel!
    
    
    @IBOutlet weak var showMembersButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var groupDateIcon: UIImageView!
    @IBOutlet weak var groupHostIcon: UIImageView!
    @IBOutlet weak var groupLocationIcon: UIImageView!
    @IBOutlet weak var groupLargeImage: UIImageView!
    
    @IBOutlet weak var meetupTitle: UILabel!
    @IBOutlet weak var meetupStartDate: UILabel!
    @IBOutlet weak var meetupStartTime: UILabel!
    
    @IBOutlet weak var meetupLocation: UILabel!
    @IBOutlet weak var meetupHosts: UILabel!
    @IBOutlet weak var meetupDetails: UILabel!
    
    @IBOutlet weak var meetupDetailPad: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var meetupEndDate: UILabel!
    @IBOutlet weak var meetupEndTime: UILabel!
    
    @IBOutlet weak var membersGoingStack: UIStackView!
    
    
    @IBOutlet weak var joinButtonTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var DateTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var infoList: UIStackView!
    @IBOutlet weak var joinTheDiscussionButton: UIButton!
    
    @IBOutlet weak var eventVideoImage: UIImageView!
    
    @IBOutlet weak var meetupVideoButton: UIButton!
    @IBOutlet weak var videoHeight: NSLayoutConstraint!
    
    
    
    
    // var & let
    var group: Group!
    var data = meetupServer()
    var meetup: Meetup!
    var meetupVideo: Video!
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfUid = ""
    
    var peopleGoing : [Member] = []
    var filteredPeopleGoing: [Member] = []
    var creators : [User] = []
    var updatedCount = 0
    var groupMembers : [Member] = []
    var mainMenuMember : Member!
    
    var moreGroupMeetings : [Meetup] = []
    
    var moreGroupMeetingsDates = ["Thu, Aug 23, 7:00 PM", "Thu, Aug 23, 9:00 PM", "Mon, Sep 3, 6:00 PM • Starbucks", "Fri, Sep 13, 7:00 PM", "Wed, Sep 23, 8:00 PM" ]
    
    var moreGroupMeetingsPeopleGoing = ["26", "3", "0", "52", "129"]
    var unwindedData: Meetup!
    
    var blockedMembers: [Member] = []
    var administrator = ""
    var isBlocked = false
    var currentUser = ""
    
    @IBAction func unwindToGroupMeetup(segue: UIStoryboardSegue){
        
        self.view.reloadInputViews()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
    }
    
    @IBAction func unwindToGroupMeetupRegular(segue: UIStoryboardSegue){
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("blocked members: \(blockedMembers)")
        // members from firebase
        
        let ref = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("Meetups").child(meetup.key).child("MembersGoing")
        ref.queryOrdered(byChild: "memberName").observe(.value, with: {snapshot in
            
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
            
            self.peopleGoing = newMembers
            self.updatedCount = self.peopleGoing.count
            self.peopleGoingText.text = "\(self.peopleGoing.count) People Going"
            //print(self.members)
            self.collectionView.reloadData()
            
        })
        
        FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("blockedMembers").observe(.value) { (snapshot) in
            
            print(snapshot)
            var newBlockedMembers: [Member] = []
            
            for i in snapshot.children{
                let thisBlockedMember = Member(snapshot: i as! FIRDataSnapshot)
                newBlockedMembers.append(thisBlockedMember)
            }
            
            self.blockedMembers = newBlockedMembers
        }
        
        fetchUserAndSetupNavBarTitle()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if meetup.videoTitle == "none"{
            // video height will be 0
            //video button will be 0 and inactive
            videoHeight.constant = 0
            meetupVideoButton.isEnabled = false
            
            
        }else{
            // video height will be video height
            // video button will be video button height and active
            videoHeight.constant = 200
            meetupVideoButton.isEnabled = true
            
        }
        meetupDetailPad.frame.size = CGSize( width: meetupDetailPad.frame.size.width, height: 1124 + meetupDetails.frame.size.height + meetupTitle.frame.size.height )
        meetupDetailPad.heightAnchor.constraint(equalToConstant: 1124 +  meetupDetails.frame.size.height + meetupTitle.frame.size.height).isActive = true
        
        print("pad height: \(meetupDetailPad.frame.size.height) ")
        print("text Detail height: \(meetupDetails.frame.size.height) ")
        
        self.reloadInputViews()
        
        // for adding a new meetup in the group
        
        // if the group has the current member, present available button to join meetup, else present inactive button and display "user must join group to be a part of this meetup"
        
        //if isUnwinding == false{
        
        if blockedMembers.contains( where: {$0.key == stringOfUid }){
            self.joinButton.isEnabled = false
            self.joinButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.joinButton.setTitleColor(.black, for: .normal)
            self.joinButton.setTitle("Sorry, you are blocked", for: .normal)
            self.meetupStartDate.text = "Unavailable"
            self.meetupEndDate.text = "Unavailable"
            self.meetupStartTime.text = "Unavailable"
            self.meetupEndTime.text = "Unavailable"
            self.meetupLocation.text = "Unavailable"
            self.membersGoingStack.isHidden = true
            self.meetupDetails.isHidden = true
            self.mapView.isHidden = true
            self.peopleGoing = []
            self.collectionView.reloadData()
            self.showMembersButton.isEnabled = false
            self.peopleGoingIndecator.isHidden = true
            self.joinTheDiscussionButton.isHidden = true
            self.joinTheDiscussionButton.isEnabled = false
            
        }else{
            for member in groupMembers{
                print(member)
                print("the Key UID: \(stringOfUid)")
                
                if groupMembers.contains(where: {$0.key == self.stringOfUid}) || self.stringOfUid == meetup.meetupHost{
                    print("It's a match!")
                    
                    currentUser = stringOfUid
                    // loads current groups other meetups from firebase
                    //  for meetups
                    
                    
                    let meetupRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("Meetups")
                    meetupRef.observe(.value, with: {snapshot in
                        
                        //print(snapshot)
                        //2 new items are an empty array
                        var newMeetups: [Meetup] = []
                        //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
                        for item in snapshot.children {
                            // 4
                            //print(item)
                            let meetupItem = Meetup(snapshot: item as! FIRDataSnapshot)
                            newMeetups.append(meetupItem)
                        }
                        self.moreGroupMeetings = newMeetups
                        //print(self.members)
                        self.tableView.reloadData()
                        
                        // load the page with this data crossed with the passed data so the page can be updated if edited.
                    })
                    
                    // get the meetupData
                    let thisMeetupRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("Meetups").child(meetup.key)
                    thisMeetupRef.observe(.value, with: {snapshot in
                        print("here is your meetup: \(snapshot)")
                        
                        let meetupItem = Meetup(snapshot: snapshot )
                        if meetupItem.meetupCancelled == true && self.stringOfUid != self.meetup.meetupHost! {
                            // for button
                            self.joinButton.isHidden = true
                            self.joinButton.frame.size = CGSize(width: 200, height: 0)
                            self.joinButtonTopConstraint.constant = 0
                            self.DateTopConstraint.constant = -25
                            // for data
                            self.meetupTitle.text = "Sorry, this event is cancelled.."
                            self.meetupStartDate.text = "Unavailable"
                            self.meetupEndDate.text = "Unavailable"
                            self.meetupStartTime.text = "Unavailable"
                            self.meetupEndTime.text = "Unavailable"
                            self.meetupLocation.text = "Unavailable"
                            self.meetupDetails.isHidden = true
                        }else if meetupItem.meetupCancelled == false{
                            
                            self.meetupTitle.text = meetupItem.meetupName
                            self.meetupStartDate.text = meetupItem.meetupStartDate
                            self.meetupStartTime.text = meetupItem.meetupStartTime
                            self.meetupEndDate.text = meetupItem.meetupEndDate
                            self.meetupEndTime.text = meetupItem.meetupEndTime
                            self.meetupLocation.text = meetupItem.meetupLocation
                            self.meetupDetails.text = meetupItem.meetupDescription
                            if meetupItem.videoThumbnailUrl != nil{
                                self.eventVideoImage.loadImageUsingCacheWithURLString(urlString: meetupItem.videoThumbnailUrl!)
                            }else{
                                // show an image that shows no video is present
                            }
                            
                            self.view.reloadInputViews()
                            self.view.setNeedsLayout()
                            self.view.layoutIfNeeded()
                            
                        }
                    })
                    
                  
                    
                    /* for meetup imported Data
                     meetupStartDate.text = meetup.meetupStartDate
                     meetupStartTime.text = meetup.meetupStartTime
                     meetupEndDate.text = meetup.meetupEndDate
                     meetupEndTime.text = meetup.meetupEndTime
                     meetupLocation.text = meetup.meetupLocation
                     //meetupHosts.text = meetup.meetupHost
                     meetupDetails.text = meetup.meetupDescription
                     */
                    
                    joinButton.layer.cornerRadius = 4
                    self.joinButton.isEnabled = true
                    self.joinButton.backgroundColor = #colorLiteral(red: 0.9758197665, green: 0.08100775629, blue: 0.2590740323, alpha: 1)
                    self.joinButton.setTitleColor(.white, for: .normal)
                    self.joinButton.setTitle("Join and RSVP", for: .normal)
                    //self.mapView.isHidden = true
                    
                    
                    
                }else if self.stringOfUid != member.key ||  self.stringOfUid != meetup.meetupHost {
                    
                    self.joinButton.isEnabled = false
                    self.joinButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
                    self.joinButton.setTitleColor(.black, for: .normal)
                    self.joinButton.setTitle("Please join group first!", for: .normal)
                    self.meetupStartDate.text = "Unavailable"
                    self.meetupEndDate.text = "Unavailable"
                    self.meetupStartTime.text = "Unavailable"
                    self.meetupEndTime.text = "Unavailable"
                    self.meetupLocation.text = "Unavailable"
                    self.meetupLocation.text = "Unavailable"
                    self.membersGoingStack.isHidden = true
                    self.meetupDetails.isHidden = true
                    self.mapView.isHidden = true
                    self.peopleGoing = []
                    self.collectionView.reloadData()
                    self.showMembersButton.isEnabled = false
                    self.peopleGoingIndecator.isHidden = true
                    self.joinTheDiscussionButton.isHidden = true
                    self.joinTheDiscussionButton.isEnabled = false
                    
                }
            }
        }
        
        for i in blockedMembers{
            filteredPeopleGoing = peopleGoing.filter{ $0.key == i.key}
        }
        self.collectionView.reloadData()
        print("String of profile UID: \(stringOfUid), the group members: \(groupMembers) ")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        didCreate()
        
        // for imported Data
        groupImage.loadImageUsingCacheWithURLString(urlString: group.groupImage!)
        groupLargeImage.loadImageUsingCacheWithURLString(urlString: group.groupImage!)
        groupName.text = group.groupName
        
        
        // for meetup imported Data
        meetupTitle.text = meetup.meetupName
        
        
        groupImage.layer.cornerRadius = 4
        groupImage.layer.masksToBounds = true
        groupImage.layer.borderWidth = 1
        groupImage.layer.borderColor = #colorLiteral(red: 0.5530076101, green: 0.5530076101, blue: 0.5530076101, alpha: 1)
        
        eventVideoImage.layer.cornerRadius = 4
        eventVideoImage.layer.masksToBounds = true
        
        meetupDetailPad.layer.shadowOpacity = 0.5
        meetupDetailPad.layer.shadowOffset = CGSize.zero
        meetupDetailPad.layer.shadowRadius = 5.0
        meetupDetailPad.layer.cornerRadius = 4
        
        groupDetailButtonIndecator.tintColor = #colorLiteral(red: 0.5530076101, green: 0.5530076101, blue: 0.5530076101, alpha: 1)
        peopleGoingIndecator.tintColor = #colorLiteral(red: 0.5530076101, green: 0.5530076101, blue: 0.5530076101, alpha: 1)
        // Do any additional setup after loading the view.
        
        mapView.layer.borderWidth = 0.5
        mapView.layer.borderColor = #colorLiteral(red: 0.4364677785, green: 0.4364677785, blue: 0.4364677785, alpha: 1)
        mapView.layer.cornerRadius = 4
        
        
        
        
        // for mapKit
        //let coordinate = placemark.lcation?.coordinate
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(meetup.meetupLocation!, completionHandler: {
            placemarks, error in
            if error != nil {
                print(error!)
                return
            }
            if let placemarks = placemarks {
                // get the first placemark
                let placemark = placemarks[0]
                
                // Add annotation
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    // Display the annotation
                    annotation.coordinate =  location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    // Set the zoom level
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        })
        
        
    }
    
    func didCreate(){
        // for every app member
        FIRDatabase.database().reference().child("members").observe(.childAdded, with: {(snapshot) in
            
            if let thisDictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                user.setValuesForKeys(thisDictionary)
                
                //print("this userName: \(user.username)")
                //print("this userUID: \(user.id)")
                self.creators.append(user)
                // print("The Creators: \(self.creators)")
            }
        }, withCancel: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // the collectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return peopleGoing.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        let thisCell = cell as? MeetupGroupMemberCollectionViewCell
        let thisMember = peopleGoing[indexPath.row]
        
        
        thisCell?.getMember(member: thisMember)
        
        cell.layer.cornerRadius = 17.5
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        cell.layer.borderColor = #colorLiteral(red: 0.5530076101, green: 0.5530076101, blue: 0.5530076101, alpha: 1)
        
        
        return cell
        
    }
    
    
    // the TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var memberCounts = 0
        
            if currentUser == self.stringOfUid{
                memberCounts = moreGroupMeetings.count
            }else {
                // counts = 0
                memberCounts = 1
            }
        return memberCounts
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? GroupIntroTableViewCell
        
        
            if currentUser == self.stringOfUid{
                let thisMeetup = self.moreGroupMeetings[indexPath.row]
                cell?.getMeetup(meetup: thisMeetup)
                
            }else {
                // counts = 0
                cell?.moreMeetingTitle.text = "Something went wrong!"
            }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "IntroGroupController") as! GroupIntroViewController
        
        controller.administrator = administrator
        controller.group = group
        controller.meetup = moreGroupMeetings[indexPath.row]
        controller.groupMembers = groupMembers
        //print(data.groups[indexPath.row])
        
        show(controller, sender: self)
        //present(controller, animated: true, completion: nil)
        
        //performSegue(withIdentifier: "ShowMainGroup", sender: self)
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
        
        
        // this meetup group Members from firebase
        
        let thisGroupMembersRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("Members")
        thisGroupMembersRef.queryOrdered(byChild: "groupName").observe(.value, with: {snapshot in
            
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
            self.groupMembers = newMembers
        })
        
        
        
        
        
        // for making join button dissapear
        for mem in peopleGoing{
            print("Counting Members")
            
            if mem.key == stringOfUid{
                print("Found member!")
                // hide join button
                if blockedMembers.contains(where: {$0.key == stringOfUid}){
                    self.joinButton.isHidden = false
                }else{
                    self.joinButton.isHidden = true
                    self.joinButton.frame.size = CGSize(width: 200, height: 0)
                    self.joinButtonTopConstraint.constant = 0
                    self.DateTopConstraint.constant = -25
                    // find the creator in the loaded list and rename organizer and add image
                }
            }
        }
        
        for creator in creators{
            if self.group.groupCreatorUID == creator.id{
                
                meetupHosts.text = creator.username
                //organizerImage.loadImageUsingCacheWithURLString(urlString: creator.userImageUrl!)
            }
        }
        
        if stringOfUid == group.groupCreatorUID || stringOfUid == administrator {
            self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMeetup) ), animated: true)
            
        }else{
            
        }
        
        self.tableView.reloadData()
        
    }
    
    
    @IBAction func showGroupButton(_ sender: Any) {
        performSegue(withIdentifier: "ShowMainGroup", sender: self)
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func joinMeetupButton(_ sender: Any) {
        postMember()
        postMeetup()
        attending()
    }
    
    
    
    func postMember(){
        // posts in the Group Members section
        let ref = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child(group.key).child("Meetups").child(meetup.key).child("MembersGoing")
        
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
            for member in churchUsers{
                if member.key == self.stringOfUid{
                    // for main database
                    let memberItem =
                        Member(username: member.username!, userImageUrl: member.userImageUrl!, id: member.id!, firstname: member.firstname!, lastname: member.lastname!, email: member.email!, telephone: member.telephone!, bio: member.bio!, role: member.role!, birthday: member.birthday!, anniversary: member.anniversary!, profession: member.profession!, address: member.address!, gender: member.gender!, status: member.status!, work: member.work!, currentLevelStatus: member.status!, allergies: member.allergies!, hobbies: member.hobbies!, parentName: member.parentName!, parentUserName: member.parentUserName!, parentUid: member.parentUid!, parentImage: member.parentImage!, parentEmail: member.parentEmail!, parentTelephone: member.parentTelephone!, parentWorkTelephone: member.parentWorkTelephone!, studentSelected: member.studentSelected!)
                    
                    //self.blogs.insert(blogItem, at: 0)
                    let memberItemRef = ref.child(self.stringOfUid)
                    memberItemRef.setValue(memberItem.toAnyObject())
                }
            }
        })
        self.joinButton.isHidden = true
        self.joinButton.frame.size = CGSize(width: 200, height: 0)
        self.joinButtonTopConstraint.constant = 0
        self.DateTopConstraint.constant = -25
        self.tableView.reloadData()
        
    }
    
    func postMeetup(){
        // posts the Group name/key in the users groups section
        let meetupItemRef = FIRDatabase.database().reference(withPath: "users").child(self.stringOfUid).child("Meetups").child("\(meetup.key)")
        
        // for main database
        let meetupItem = Meetup(meetupImage: meetup.meetupImage!, meetupName: meetup.meetupName!, meetupGoingOrNot: meetup.meetupGoingOrNot, meetupStartTime: meetup.meetupStartTime!, meetupEndTime: meetup.meetupEndTime!, meetupStartDate: meetup.meetupStartDate!, meetupEndDate: meetup.meetupEndDate!, meetupLocation: meetup.meetupLocation!, meetupHost: meetup.meetupHost!, interested: meetup.interested, meetupDescription: meetup.meetupDescription!, meetupParentName
            : meetup.meetupParentName!, MembersGoing: meetup.MembersGoing!, fullMeetupStartDate: meetup.fullMeetupStartDate!, meetupCancelled: meetup.meetupCancelled!, videoId: meetup.videoId, videoTitle: meetup.videoTitle, videoDescription: meetup.videoDescription,  videoThumbnailUrl: meetup.videoThumbnailUrl, videoDate: meetup.videoDate)
        
        //self.blogs.insert(blogItem, at: 0)
        meetupItemRef.setValue(meetupItem.toAnyObject())
        
    }
    
    func attending() {
        
        let isoStartDate = "\(meetup.meetupStartDate!), \(meetup.meetupStartTime!)"
        let isoEndDate = "\(meetup.meetupEndDate!), \(meetup.meetupEndTime!)"
        
        // date converter...
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
        
        let startDate = dateFormatter.date(from:isoStartDate)!
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: startDate)
        
        
        let thisStartDate = calendar.date(from:startComponents)
        
        
        let endDate = dateFormatter.date(from:isoEndDate)!
        let endComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: endDate)
        let thisEndDate = calendar.date(from:endComponents)
        
        // end....
        addEventToCalendar(title: meetupTitle.text!, description: meetupDetails.text!, startDate: thisStartDate!, endDate: thisEndDate!, location: meetupLocation.text!, hosts: meetupHosts.text! )
        print("title: \(meetupTitle.text!), description: \(meetupDetails.text!), startDate: \(thisStartDate!), endDate: \(thisEndDate!), Location: \(meetupLocation.text!)")
        
        let alert = UIAlertController(title: "Events Notification", message: "This event has been added to your calendar.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Close", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    // call to calendar
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, location: String, hosts: String, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = "Hosted by: \(hosts) \n\n StartTime: \(self.meetup.meetupStartTime!) \n\n EndTime: \(self.meetup.meetupEndTime!) \n\n  \(description!)"
                event.location = location
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                event.addAlarm(EKAlarm(relativeOffset: 0 ))
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    
    
    
    func updateMemberCount(){
        let userMemberCountRef = FIRDatabase.database().reference(withPath: "Groups").child("\(self.group.key)")
        
        let memberCountRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!).child("Groups").child("\(self.group.key)")
        
        let memberCountItem = ["groupMemberCount": self.updatedCount]
        
        userMemberCountRef.updateChildValues(memberCountItem)
        memberCountRef.updateChildValues(memberCountItem)
    }
    
    @objc func editMeetup(){
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "AddMeetupController") as!
        NewGroupMeetupViewController
        
        destinationController.isEditingMeetup = true
        destinationController.group = group
        destinationController.meetup = meetup
        self.navigationController?.present(destinationController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func showMembersAttendingMeetup(_ sender: Any) {
        if self.group.groupCreatorUID == stringOfUid{
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "someClassViewController") as!
            someClassViewController
            
            destinationController.category = group.category!
            destinationController.group = group
            destinationController.thisClassMembers = groupMembers
            destinationController.stringOfProfileImageView = stringOfProfileImageView
            destinationController.stringOfProfileName = stringOfProfileName
            destinationController.stringOfUid = stringOfUid
            destinationController.thisGroupKey = group.key
            
            show(destinationController, sender: self)
        }else{
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "MembersListController") as!
            GroupMembersViewController
            
            destinationController.isMeetup = true
            destinationController.group = group
            destinationController.meetup = meetup
            self.navigationController?.show(destinationController, sender: self)
            //present(destinationController, animated: true, completion: nil)
            //performSegue(withIdentifier: "ShowMembers", sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let newMeetupRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("Meetups").child(meetup.key)
        
        newMeetupRef.removeAllObservers()
        
        print("listeners removed!")
        
    }
    
    
    @IBAction func joinTheDiscussionButton(_ sender: Any) {
        
        let destinationController = storyboard?.instantiateViewController(withIdentifier: "GroupDiscussionController") as!
        GroupDiscussionViewController
        
        destinationController.group = group
        destinationController.meetup = meetup
        destinationController.stringOfUID = stringOfUid
        
        show(destinationController, sender: self)
    }
    
    @IBAction func meetupVideoButton(_ sender: Any) {
        if meetup.videoId != nil{
            
            let destinationController = storyboard?.instantiateViewController(withIdentifier: "ShowMediaDetail") as!
            MediaDetailViewController
            
            destinationController.isClass = true
            //destinationController.videos = videos
            destinationController.mediaTitle = meetup.videoTitle!
            
            destinationController.videoEmbedString = "\(meetup.videoId!)"
            
            
            AppUtility.lockOrientation(.landscape)
            show(destinationController, sender: self)
        }
    }
    
    
    // MARK: - Navigation
    
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMainGroup"{
            let destinationController = segue.destination as!
            GroupPageViewController
            destinationController.group = group
        }
        
        if segue.identifier == "ShowMap" {
            //let destinationController = segue.destination as! EventMapViewViewController
            //destinationController.eventTitle = self.eTitle
            //destinationController.eventLocation = self.eLocation
            //destinationController.eventAttendees = self.eCount
            //destinationController.eventImage = self.eImage
            
        }
    }
}
