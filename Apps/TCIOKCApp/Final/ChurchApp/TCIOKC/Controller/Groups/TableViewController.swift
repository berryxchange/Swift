//
//  TableViewController.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/16/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth



class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var groupsTableView: UITableView!
    
    @IBOutlet weak var seeAllMemberGroupsButton: UIButton!
    
    @IBOutlet weak var seeAllArrowButton: UIImageView!
    
    @IBOutlet weak var addNewGroup: UIButton!
    
    
    
    @IBOutlet weak var calendarTableView: UITableView!
    
    @IBOutlet weak var yourGroupsPad: UIView!
    
    @IBOutlet weak var yourCalendar: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var data = meetupServer()
    var group: Group!
    var groups = [Group]()
    var limitedGroups = [Group]()
    var newNewGroups = [[Group]?]()
    var newNewMeetup = [Meetup?]()
    var members: [Member] = []
    var meetups: [Meetup] = []
    var goingTo: [Meetup] = []
    var wentTo: [Meetup] = []
    
    var defaultGroupData: [Group] = [Group(groupName: "", groupParent: "", groupLocation: "", groupImage: "", groupDescription: "", groupCreatorUID: "", groupMemberCount: 0, Members: [ : ], Meetups: [:], category: "", blockedMembers: [:])]
    
    var defaultData: [Meetup] = [Meetup(meetupImage: "", meetupName: "No Data Available", meetupGoingOrNot: false, meetupStartTime: "", meetupEndTime: "", meetupStartDate: "", meetupEndDate: "", meetupLocation: "", meetupHost: "", interested: false, meetupDescription: "", meetupParentName: "Your Calendar", MembersGoing: [:], fullMeetupStartDate: "", meetupCancelled: false, videoId: "", videoTitle: "", videoDescription: "", videoThumbnailUrl: "", videoDate: "")]
    var arrangedMeetups: [Meetup] = []
    
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfUid = ""
    
    var administrator = ""
    var associate = ""
    var blockedMembers : [Member] = []
    
    @IBAction func unwindToMainDashboard(segue: UIStoryboardSegue){
        self.groupsTableView.reloadData()
        self.view.reloadInputViews()
        self.calendarTableView.reloadData()
    }
    
    @IBAction func unwindToMainDashboardFromDelete(segue: UIStoryboardSegue){
        self.groupsTableView.reloadData()
        self.calendarTableView.reloadData()
        self.wentTo.removeAll()
        self.goingTo.removeAll()
        self.meetups.removeAll()
        self.calendarTableView.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.calendarTableView.reloadData()
        
        if UserDefaults.standard.bool(forKey: "hasViewedEventsWalkthrough"){
            return
        }
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            present(pageViewController, animated: true, completion: nil)
            
            pageViewController.viewingEventsWalkthrough = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchUserAndSetupNavBarTitle()
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        seeAllArrowButton.tintColor = #colorLiteral(red: 0.5530076101, green: 0.5530076101, blue: 0.5530076101, alpha: 1)
        // for your Groups
        yourGroupsPad.layer.cornerRadius = 4
        yourGroupsPad.layer.masksToBounds = true
        
        
        // for your Calendar
        yourCalendar.layer.cornerRadius = 4
        yourCalendar.layer.masksToBounds = true
        
        
    }
    
    
    
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count : Int?
        if tableView == groupsTableView{
            count = 1
        }
        
        if tableView == calendarTableView{
            if arrangedMeetups.count > 0{
                count = arrangedMeetups.count
            }else if arrangedMeetups.count == 0 {
                count = defaultData.count
            }
        }
        
        return count!
    }
    
    // this sets the collectionviews data right before the tableviews data
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? TableViewCell else {return}
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        //tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // for the Groups tableView
        if tableView == groupsTableView{
            // Do something
            let thisCell = cell as? TableViewCell
            thisCell?.collectionView.reloadData()
            
        }
        
        // for the Calendar tableView
        if tableView == calendarTableView{
            let thisCell = cell as? CalendarMeetupsTableViewCell
            
            if arrangedMeetups.count > 0{
                let thisCalendar = arrangedMeetups[indexPath.row]
                thisCell?.getMeetup(meetup: thisCalendar)
                thisCell?.meetupDate.text = "\(thisCalendar.meetupStartDate!), \(thisCalendar.meetupStartTime!)"
                
            }else if arrangedMeetups.count == 0 {
                //display empty cell data
                print("No Data!")
                
                let thisCalendar = defaultData[indexPath.row]
                thisCell?.getMeetup(meetup: thisCalendar)
                thisCell?.meetupDate.text = ""
                
                //thisCell?.parentGroup.text = "Your Calendar"
                //thisCell?.meetupTitle.text = "No Data Available"
                //thisCell?.meetupDate.text = ""
                //thisCell?.meetupAttendance.text = ""
                //thisCell?.selectionStyle = .none
            }
        }
        return cell
    }
    
    
    @IBAction func indexChanged(_ sender: Any) {
        // tell the view to relaod then laod the new tableView data & populate the tableView.
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print(goingTo)
            arrangedMeetups.removeAll()
            self.calendarTableView.reloadData()
            arrangedMeetups = goingTo
            if goingTo.isEmpty{
                
                calendarTableView.isHidden = false
                self.view.reloadInputViews()
                self.calendarTableView.reloadData()
                print(arrangedMeetups)
                //calendarTableView.backgroundColor = UIColor.clear.withAlphaComponent(0)
            }else{
                
                calendarTableView.isHidden = false
                
                self.view.reloadInputViews()
                self.calendarTableView.reloadData()
                print(arrangedMeetups)
            }
        case 1:
            print(wentTo)
            arrangedMeetups.removeAll()
            self.calendarTableView.reloadData()
            arrangedMeetups = wentTo
            if wentTo.isEmpty{
                
                self.view.reloadInputViews()
                self.calendarTableView.reloadData()
            }else{
                
                calendarTableView.isHidden = false
                
                self.view.reloadInputViews()
                self.calendarTableView.reloadData()
                print(arrangedMeetups)
            }
        case 2:
            print(meetups)
            arrangedMeetups.removeAll()
            self.calendarTableView.reloadData()
            arrangedMeetups = meetups
            if meetups.isEmpty{
                
                self.view.reloadInputViews()
                self.calendarTableView.reloadData()
            }else{
                
                calendarTableView.isHidden = false
                
                self.view.reloadInputViews()
                self.calendarTableView.reloadData()
                print(arrangedMeetups)
            }
        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == calendarTableView{
            let controller = storyboard?.instantiateViewController(withIdentifier: "IntroGroupController") as! GroupIntroViewController
            
            if arrangedMeetups.count > 0{
                for I in groups{
                    if arrangedMeetups[indexPath.row].meetupParentName == I.groupName{
                        controller.group = I
                        print(I.groupName!)
                        print(I)
                    }
                }
                
                controller.administrator = administrator
                controller.meetup = arrangedMeetups[indexPath.row]
                
                //print(groups[indexPath.row])
                show(controller, sender: self)
                
            }else if arrangedMeetups.count == 0 {
                // do nothing
            }
        }
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
        
        //setup of user header image
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //titleView.backgroundColor = UIColor.red
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode  = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        profileImageView.loadImageUsingCacheWithURLString(urlString: self.stringOfProfileImageView)
        
        containerView.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.text = self.stringOfProfileName
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        nameLabel.font = nameLabel.font.withSize(12)
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        //end
        
        
        let adminRef = FIRDatabase.database().reference().child("Administrators")
        
        
        //test for the admin
        adminRef.observe(.childAdded, with: {snapshot in
            // first compare the currrent user with the array of admins
            // if the current id is in that group then the current user id will be added to the administrator string
            //else if not in that group, the name will be tried in the associates array
            // else if not in that group, the user will just be a plain user.
            //print("the snapshot \(snapshot.value!)")
            var adminsArray = [String]()
            
            adminsArray.append("\(snapshot.value!)")
            for array in adminsArray{
                print(self.stringOfUid)
                print(array)
                if self.stringOfUid == array{
                    self.administrator = self.stringOfUid
                    print("The admin name: \(self.administrator)")
                }
            }
        })
        loadGroupFromFirebase(UID: stringOfUid)
        checkIfUserIsLoggedIn()
    }
    
    
    
    func checkIfUserIsLoggedIn(){
        
        if FIRAuth.auth()?.currentUser?.uid == self.administrator {
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
            button.addTarget(self, action:#selector(informationButton), for:.touchUpInside)
            button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
            let barButton = UIBarButtonItem.init(customView: button)
            //self.navigationItem.rightBarButtonItem = barButton
            barButton.tintColor = UIColor.blue
            
            self.navigationItem.setRightBarButtonItems([barButton], animated: true)
            
        } else {
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
            button.addTarget(self, action:#selector(informationButton), for:.touchUpInside)
            button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
            let barButton = UIBarButtonItem.init(customView: button)
            self.navigationItem.rightBarButtonItem = barButton
            barButton.tintColor = UIColor.blue
            
        }
        
        
    }
    
    
    @objc func informationButton() {
        UserDefaults.standard.set(false, forKey: "hasViewedEventsWalkthrough")
        information()
    }
    
    
    func information(){
        print("Calling Information")
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            pageViewController.viewingEventsWalkthrough = true
            present(pageViewController, animated: true, completion: nil)
            
            
        }
    }
    
    func loadGroupFromFirebase(UID: String){
        
        // pulls the user groups
        
        FIRDatabase.database().reference().child("users").child(stringOfUid).child("Groups").observeSingleEvent(of: .value, with: { (userSnapshot) in
            
            // pulls the userGroups
            var userGroups: [String] = []
            var newGroups: [Group] = []
            var newLimitedGroups: [Group] = []
            for i in userSnapshot.children{
                let groupItem = "\((i as AnyObject).key!)"
                userGroups.append(groupItem)
                print(userGroups)
            }
            
            // Loads the groups from firebase
            let ref = FIRDatabase.database().reference()
            ref.child("Categories").observe(.value, with: { categorySnapshot in
                
                var groupCount = 0
                for categoryItem in categorySnapshot.children{
                    
                    let thisCategory = categoryItem as AnyObject
                    
                    
                    let groupRef = ref.child("Categories").child("\(thisCategory.key!)").child("Groups")
                    groupRef.observe(.value, with: { groupSnapshot in
                        
                        // Solved!!! cross reference the Firebase users/groups group.key with the snapshot.children key. just make sure when you post to the users/groups that its made in lowercase as the key.
                        for i in groupSnapshot.children{
                            
                            //unformattedGroups.append(i as AnyObject)
                            
                            let test = i as AnyObject
                            //print(test)
                            
                            //loads the userGroups
                            for G in userGroups{
                                if test.key! == G{
                                    let groupItem = Group(snapshot: i as! FIRDataSnapshot )
                                    
                                    
                                    
                                    if newGroups.contains(where: {$0.groupName == groupItem.groupName}){
                                        //print("Nothing to add")
                                        
                                    }else{
                                        newGroups.append(groupItem)
                                        if groupCount != 6{
                                            newLimitedGroups.append(groupItem)
                                            groupCount += 1
                                        }
                                        
                                    }
                                    
                                    
                                    // meetups
                                    
                                    
                                    //print(self.groups)
                                    self.callForMeetups()
                                    
                                }
                            }
                            
                            self.limitedGroups = newLimitedGroups
                            self.groups = newGroups
                        }
                        
                        self.groupsTableView.reloadData()
                    })
                }
                
            })
            
            //end...
            
        })
        
    }
    
    func callForMeetups(){
        // Loads the groups from firebase
        FIRDatabase.database().reference().child("users").child(stringOfUid).child("Meetups").queryOrdered(byChild: "meetupStartDate").observe(.value, with: { (userSnapshot) in
            
            
            var newMeets: [Meetup] = []
            var newGoto: [Meetup] = []
            var newWentTo: [Meetup] = []
            for i in userSnapshot.children{
                //print(i)
                
                //print(i)
                let meetupItem = Meetup(snapshot: i as! FIRDataSnapshot )
                
                // formatted Time
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                
                //let nowFormatted = formatter.string(from: Date())
                let date2 = meetupItem.meetupStartDate
                //print("date 1: \(nowFormatted)")
                print("date 2: \(date2!)")
                
                let dateFormatOfDate2 = formatter.date(from: date2!)
                
                let now = Date()
                
                let dateToCheck = Calendar.current.dateComponents([.year, .month, .day], from: dateFormatOfDate2!)
                
                let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: now)
                
                
                
                // for all meetups
                newMeets.append(meetupItem)
                self.meetups = newMeets
                self.meetups = self.meetups.sorted(by: {
                    $0.meetupStartDate?.compare($1.meetupStartDate!) == .orderedDescending
                })
                //end
                
                if now > dateFormatOfDate2! {
                    // for went to
                    print("Its Old!")
                    // if the event has passed
                    //do something
                    
                    newWentTo.append(meetupItem)
                    //print(newWentTo)
                    
                    print(newWentTo.count)
                    print(self.wentTo.count)
                    self.wentTo = newWentTo
                    
                    self.wentTo = self.wentTo.sorted(by: {
                        $0.meetupStartDate?.compare($1.meetupStartDate!) == .orderedDescending
                    })
                    self.calendarTableView.reloadData()
                    
                }else  {
                    print("no data here")
                    
                    if newWentTo.count == 0{
                        //newGoto = []
                        self.wentTo = []
                    }else{
                        self.calendarTableView.reloadData()
                    }
                }
                
                // for going to
                if now < dateFormatOfDate2! { //|| currentDate.year == dateToCheck.year && currentDate.month == dateToCheck.month && currentDate.day == dateToCheck.day  {
                    // if the event hasnt come yet
                    //do something
                    print("the event has not come yet")
                    newGoto.append(meetupItem)
                    print(newGoto)
                    print("NewGoto: \(newGoto.count)")
                    self.goingTo = newGoto
                    print("goingTo: \(self.goingTo.count)")
                    self.goingTo = self.goingTo.sorted(by: {
                        $0.meetupStartDate?.compare($1.meetupStartDate!) == .orderedDescending
                    })
                    self.calendarTableView.reloadData()
                    
                    
                }else {
                    print("no data here")
                    if newGoto.count == 0{
                        //newGoto = []
                        self.goingTo = []
                    }else{
                        self.calendarTableView.reloadData()
                    }
                }
                
                //DispatchQueue.main.async {
                //print(newWentTo)
                self.getCalendarItem()
                self.calendarTableView.reloadData()
                
                //}
                
            }
        })
        
    }
    
    func getCalendarItem(){
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            arrangedMeetups = goingTo
            self.calendarTableView.reloadData()
            
        case 1:
            
            arrangedMeetups = wentTo
            self.calendarTableView.reloadData()
        case 2:
            arrangedMeetups = meetups
            self.calendarTableView.reloadData()
            
        default:
            break
        }
    }
    
    
    @IBAction func seeAllMemberGroupsButton(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "YourMemberGroups") as! YourMemberGroupsTableViewController
        
        controller.administrator = administrator
        controller.groups = groups
        controller.navigationItem.title = "Your Groups"
        show(controller, sender: self)
        
    }
    
    @IBAction func addNewGroup(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "NewGroupController") as! NewGroupViewController
        
        controller.isEditingGroup = false
        
        self.show(controller, sender: self)
        //self.present(controller, animated: true, completion: nil)
        
        
        
        //performSegue(withIdentifier: "showAddNewGroup", sender: self)
    }
    
    
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            
            dismiss(animated: true, completion: nil)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let newRef = FIRDatabase.database().reference().child("Groups")//.child(socialPosts.key).child("userPostLikes")
        newRef.removeAllObservers()
        print("listeners removed!")
        
    }
    
    
    
    // MARK: - Navigation
    
    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMemberGroups"{
            let destinationController = segue.destination as!
            YourMemberGroupsTableViewController
            
            destinationController.groups = groups
            
        }
        
        if segue.identifier == "ShowGroupIntro"{
            if let indexPath = calendarTableView.indexPathForSelectedRow{
                let destinationController = segue.destination as!
                GroupIntroViewController
                
                switch meetups[indexPath.row].meetupParentName{
                case data.groups[indexPath.row].groupName:
                    destinationController.group = data.groups[indexPath.row]
                    print(data.groups[indexPath.row])
                default:
                    break
                }
                destinationController.meetup = meetups[indexPath.row]
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}



extension TableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                      for: indexPath) as? CollectionViewCell
        
        if limitedGroups.count > 0{
            let lastRowIndex = collectionView.numberOfItems(inSection: collectionView.numberOfSections - 1)
            
            if (indexPath.row == lastRowIndex - 1) {
                print("last row selected")
                
                cell?.layer.cornerRadius = 62.5
                cell?.layer.masksToBounds = true
                
                cell?.groupImage.image = UIImage(named: "")
                cell?.collectionText.text = "Show All Groups"
            }else{
                
                let thisGroup = limitedGroups[indexPath.item]
                
                cell?.getGroups(group: thisGroup)
                
                cell?.layer.cornerRadius = 4
                cell?.layer.masksToBounds = true
                /*cell?.layer.borderWidth = 1
                 cell?.layer.borderColor = #colorLiteral(red: 0.5530076101, green: 0.5530076101, blue: 0.5530076101, alpha: 1)
                 */
                
                cell?.groupImage.loadImageUsingCacheWithURLString(urlString: thisGroup.groupImage!)
            }
        }else if limitedGroups.count == 0 {
            cell?.groupImage.image = UIImage(named: "")
            cell?.collectionText.text = "Find A Group"
            
            cell?.layer.cornerRadius = 4
            cell?.layer.masksToBounds = true
            
        }
        
        return cell!
    }
    
    
    @IBAction func MainPageSegue(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    // collectionView
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        var count = 0
        
        if limitedGroups.count > 0{
            count = limitedGroups.count
        }else if limitedGroups.count == 0 {
            count = defaultGroupData.count
        }
        
        
        return count
    }
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didTouch")
        
        if limitedGroups.count > 0{
            let lastRowIndex = collectionView.numberOfItems(inSection: collectionView.numberOfSections - 1)
            
            if (indexPath.row == lastRowIndex - 1) {
                print("last row selected")
                let controller = storyboard?.instantiateViewController(withIdentifier: "YourMemberGroups") as! YourMemberGroupsTableViewController
                controller.administrator = administrator
                controller.groups = groups
                
                controller.navigationItem.title = "Your Groups"
                show(controller, sender: self)
            }else{
                
                let controller = storyboard?.instantiateViewController(withIdentifier: "GroupController") as! GroupPageViewController
                
                controller.administrator = administrator
                controller.group = limitedGroups[indexPath.row]
                controller.blockedMembers = blockedMembers
                print(limitedGroups[indexPath.row])
                show(controller, sender: self)
                //present(controller, animated: true, completion: nil)
                //performSegue(withIdentifier: "ShowGroupIntro", sender: self)
            }
        }else if limitedGroups.count == 0 {
            let controller = storyboard?.instantiateViewController(withIdentifier: "FindGroups") as! FindMeetupsViewController
            
            controller.administrator = administrator
            
            show(controller, sender: self)
        }
    }
}
