//
//  AdministratorControlViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/24/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase

class AdministratorControlViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var currentSalvations: [Member] = []
    var currentGuests: [Member] = []
    var currentMiracles: [Member] = []
    var currentMembers: [Member] = []
    var currentUsers : [Member] = []
    var thisSpecificUser: Member!
    var searchController: UISearchController!
    var searchResults : [Member] = []
    var currentTab = ""
    
    
    
    @IBAction func unwindToAdminControl(segue: UIStoryboardSegue){
        fetchUsers()
        callMembers()
        self.tableView.reloadData()
        
        //self.navigationController?.navigationBar.topItem?.title = "(\(self.currentUsers.count)) Users"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      callMembers()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure Refresh Control
        if #available(iOS 10.0, *) {
            let refreshControl = UIRefreshControl()
            let title = NSLocalizedString("PullToRefresh", comment: "Pull to refresh")
            refreshControl.attributedTitle = NSAttributedString(string: title)
            refreshControl.addTarget(self,
                                     action: #selector(refreshOptions(sender:)),
                                     for: .valueChanged)
            
            tableView.refreshControl = refreshControl
        }
        // --------------
        
        addBackButton()
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
        fetchUsers()
        segmentedControl.selectedSegmentIndex = 0
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        currentUsers = currentSalvations
        tableView.reloadData()
        
    }
    
    // for pull to refresh....
    @objc private func refreshOptions(sender: UIRefreshControl) {
        // Perform actions to refresh the content
        // ...
        // and then dismiss the control
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            currentUsers = []
            currentUsers = currentSalvations
            self.view.reloadInputViews()
            self.tableView.reloadData()
            self.navigationController?.navigationBar.topItem?.title = "(\(self.currentUsers.count)) Users"
            
        case 1:
            callMembers()
            self.navigationController?.navigationBar.topItem?.title = "(\(self.currentUsers.count)) Users"
            
        case 2:
            currentUsers = []
            currentUsers = currentGuests
            self.view.reloadInputViews()
            self.tableView.reloadData()
            self.navigationController?.navigationBar.topItem?.title = "(\(self.currentUsers.count)) Users"
            
        case 3:
            currentUsers = []
            currentUsers = currentMiracles
            self.view.reloadInputViews()
            self.tableView.reloadData()
            self.navigationController?.navigationBar.topItem?.title = "(\(self.currentUsers.count)) Users"
            
        default:
            break
        }
        
        sender.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // the information Button
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(information), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
        
        let barButton = UIBarButtonItem.init(customView: button)
        //self.navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = UIColor.blue
        
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUser))
        
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem, barButton], animated: true)
        
        self.tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchUsers(){
        // fetches all the users in the database
        
        // for Salvations
        FIRDatabase.database().reference().child("salvations").observe(.value, with: {(snapshot) in
            var someMembers: [Member] = []
            for item in snapshot.children{
                print(item)
                let memberItem = Member(snapshot: item as! FIRDataSnapshot)
                someMembers.append(memberItem)
            }
            self.currentSalvations = someMembers
            
            //...
            self.currentSalvations = self.currentSalvations.sorted(by: { $0.username!.compare($1.username!) == .orderedAscending
                
            })
            DispatchQueue.main.async {
                self.currentUsers = self.currentSalvations
                self.navigationController?.navigationBar.topItem?.title = "(\(self.currentUsers.count)) Users"
                self.tableView.reloadData()
            }
        }, withCancel: nil)
        
        
        // for Members
        FIRDatabase.database().reference().child("members").observe(.value, with: {(snapshot) in
            
            //self.currentMembers = []
            var someMembers: [Member] = []
            for item in snapshot.children{
                print(item)
                let memberItem = Member(snapshot: item as! FIRDataSnapshot)
               someMembers.append(memberItem)
            }
            self.currentMembers = someMembers
            
            self.currentMembers = self.currentMembers.sorted(by: { $0.username!.compare($1.username!) == .orderedAscending
            })
            
            //DispatchQueue.main.async {
              //  self.tableView.reloadData()
            //}
        }, withCancel: nil)
        
        // for Guests
        FIRDatabase.database().reference().child("guests").observe(.value, with: {(snapshot) in
            var someMembers: [Member] = []
            for item in snapshot.children{
                print(item)
                let memberItem = Member(snapshot: item as! FIRDataSnapshot)
                someMembers.append(memberItem)
            }
            self.currentGuests = someMembers
            
            self.currentGuests = self.currentGuests.sorted(by: { $0.username!.compare($1.username!) == .orderedAscending
            })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, withCancel: nil)
        
        // for Miracles
        FIRDatabase.database().reference().child("miracles").observe(.value, with: {(snapshot) in
            var someMembers: [Member] = []
            for item in snapshot.children{
                print(item)
                let memberItem = Member(snapshot: item as! FIRDataSnapshot)
               someMembers.append(memberItem)
            }
            self.currentMiracles = someMembers
            
            self.currentMiracles = self.currentMiracles.sorted(by: { $0.username!.compare($1.username!) == .orderedAscending
            })
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }, withCancel: nil)
        
        // the information Button
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(self.information), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
        
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        //self.navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = UIColor.blue
        
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addUser))
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem, barButton], animated: true)
        
        self.navigationController?.navigationBar.topItem?.title = "(\(self.currentUsers.count)) Users"
        
        currentTab = "Salvations"
        //currentUsers = currentSalvations
        print(currentUsers)
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count : Int?
        if searchController.isActive {
            count = searchResults.count
        }else {
            count = currentUsers.count
        }
        
        return count!
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as?
        AdministratorControlTableViewCell
        
        let thisUser = (searchController.isActive) ? searchResults[indexPath.row]: currentUsers[indexPath.row]
        
        cell?.getUser(user: thisUser)
        
        print("\(thisUser.username!)'s role: \(String(describing: thisUser.role))")
        
        // for control switch
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("salvations")
            
        // salvations
        case 1:
            //members
             print("members")
        case 2:
            // guests
            print("guests")
          
        case 3:
            // miracles
            print("miracles")
            
        default:
            break
        }
        
        
        func viewWillDisappear(_ animated: Bool) {
            unfetchUsers()
        }
        
        func unfetchUsers(){
            // unfetches all the users in the database
            
            // for Salvations
            let salvation = FIRDatabase.database().reference().child("salvations")
            salvation.removeAllObservers()
            
            // for Members
            let member = FIRDatabase.database().reference().child("members")
            member.removeAllObservers()
            
            // for Guests
            let guest = FIRDatabase.database().reference().child("guests")
            guest.removeAllObservers()
            
            // for Miracles
            let miracle = FIRDatabase.database().reference().child("miracles")
            miracle.removeAllObservers()
            
            
            
        }
        
        if let userImageUrl = thisUser.userImageUrl {
            cell?.userImage.loadImageUsingCacheWithURLString(urlString: userImageUrl)
        }
        
        cell?.userImage.layer.cornerRadius = 50
        cell?.userImage.layer.masksToBounds = true
        cell?.userImagePad.layer.cornerRadius = 55
        cell?.userImagePad.layer.shadowOpacity = 0.5
        cell?.userImagePad.layer.shadowOffset = CGSize.zero
        cell?.userImagePad.layer.shadowRadius = 5.0
        cell?.userImagePad.layer.masksToBounds = false
        
        thisSpecificUser = thisUser
        
        return cell!
        
    }
    
    func filterContent(for searchText: String){
        searchResults = currentUsers.filter({ (user) -> Bool in
            //let thisName: String? = "\(user.firstname!) \(user.lastname!)"
            let thisUserName: String? = "\(user.username!)"
            let thisEmail: String? = "\(user.email!)"
            
            //if let name = thisName{
            //  let isMatch = name.localizedCaseInsensitiveContains(searchText)
            // return isMatch
            //}
            if let userName = thisUserName{
                let isMatch = userName.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }else if let email = thisEmail{
                let isMatch = email.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    func callMembers(){
        
        currentUsers = []
        currentUsers = currentMembers
        self.view.reloadInputViews()
        self.tableView.reloadData()
        self.navigationController?.navigationBar.topItem?.title = "(\(self.currentUsers.count)) Users"
        
        /*self.tableView.reloadData()
        currentUsers = currentMembers
        print("currentUsers count: \(currentMembers.count)")
        //self.tableView.reloadData()
        //self.view.reloadInputViews()
 */
    }
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContent(for: searchText)
            tableView.reloadData()
        }
        
    }
    
    var usersRef = FIRDatabase.database().reference().child("users")
    var membersRef = FIRDatabase.database().reference().child("members")
    var AdministratorRef = FIRDatabase.database().reference().child("Administrators")
    var AssociateRef = FIRDatabase.database().reference().child("Associates")
    
    
    @objc func adminSelected(adminSwitch: UISwitch){
        
        //if currentUsers[adminSwitch.tag].role == "admin" {
        if adminSwitch.isOn{
            
            adminSwitch.setOn(false, animated: true)
            print(currentUsers[adminSwitch.tag])
            
            let adminToRemove = AdministratorRef.child(currentUsers[adminSwitch.tag].key)
            adminToRemove.removeValue()
            
            let postUpdate = ["role": "regular"]
            
            let userAdminRemove = usersRef.child(currentUsers[adminSwitch.tag].key).child("thisUserInfo")
            userAdminRemove.updateChildValues(postUpdate)
            
            let memberAdminRemove = membersRef.child(currentUsers[adminSwitch.tag].key)
            memberAdminRemove.updateChildValues(postUpdate)
            
            print("this user is now a regular person")
            callMembers()
            
        }else{
            
            //if associateSwitch.isOn{
            //  associateControlSwitch.setOn(false, animated: true)
            //}
            adminSwitch.setOn(true, animated: true)
            print("this user is now an admin")
            
            let post = ["\(currentUsers[adminSwitch.tag].key)": "\(currentUsers[adminSwitch.tag].key)" ]
            AdministratorRef.updateChildValues(post)
            
            let postUpdate = ["role": "admin"]
            
            let associateToRemove = AssociateRef.child(currentUsers[adminSwitch.tag].key)
            associateToRemove.removeValue()
            
            let userAdminAdd = usersRef.child(currentUsers[adminSwitch.tag].key).child("thisUserInfo")
            userAdminAdd.updateChildValues(postUpdate)
            
            let memberAdminAdd = membersRef.child(currentUsers[adminSwitch.tag].key)
            memberAdminAdd.updateChildValues(postUpdate)
            
            print("\(currentUsers[adminSwitch.tag].username!)' is now an administrator... yay!")
            
            callMembers()
            
        }
    }
    
    @objc func associateSelected(associateSwitch: UISwitch){
        
        //if currentUsers[associateSwitch.tag].role == "associate" {
        
        if associateSwitch.isOn{
            
            associateSwitch.setOn(false, animated: true)
            print(currentUsers[associateSwitch.tag])
            
            let associateToRemove = AssociateRef.child(currentUsers[associateSwitch.tag].key)
            associateToRemove.removeValue()
            
            let postUpdate = ["role": "regular"]
            
            let userAssociateRemove = usersRef.child(currentUsers[associateSwitch.tag].key).child("thisUserInfo")
            userAssociateRemove.updateChildValues(postUpdate)
            
            let memberAssociateRemove = membersRef.child(currentUsers[associateSwitch.tag].key)
            memberAssociateRemove.updateChildValues(postUpdate)
            
            print("this user is now a regular person")
            tableView.reloadInputViews()
            
        }else{
            
            //if associateSwitch.isOn{
            //  associateControlSwitch.setOn(false, animated: true)
            //}
            associateSwitch.setOn(true, animated: true)
            print("this user is now an associate")
            
            let post = ["\(currentUsers[associateSwitch.tag].key)": "\(currentUsers[associateSwitch.tag].key)" ]
            AssociateRef.updateChildValues(post)
            
            let postUpdate = ["role": "associate"]
            
            let adminToRemove = AdministratorRef.child(currentUsers[associateSwitch.tag].key)
            adminToRemove.removeValue()
            
            let userAssociateAdd = usersRef.child(currentUsers[associateSwitch.tag].key).child("thisUserInfo")
            userAssociateAdd.updateChildValues(postUpdate)
            
            let memberAssociateAdd = membersRef.child(currentUsers[associateSwitch.tag].key)
            memberAssociateAdd.updateChildValues(postUpdate)
            
            print("\(currentUsers[associateSwitch.tag].username!)' is now an administrator... yay!")
            tableView.reloadInputViews()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //if currentPostUid.contains(where:{$0.id == uid}){
        //print("this is the currentUid: \(currentPostUid.key) this is the postUid: \(uid)" )
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePage") as! userProfileViewController
        
        if searchController.isActive {
            destinationController.isAdmin = true
            destinationController.stringOfProfileImageView = searchResults[indexPath.row].userImageUrl!
            destinationController.stringOfProfileName = searchResults[indexPath.row].username!
            destinationController.stringOfProfileUid = searchResults[indexPath.row].key
            
            self.navigationController?.pushViewController(destinationController, animated: true)
        }else{
            destinationController.isAdmin = true
            destinationController.stringOfProfileImageView = currentUsers[indexPath.row].userImageUrl!
            destinationController.stringOfProfileName = currentUsers[indexPath.row].username!
            destinationController.stringOfProfileUid = currentUsers[indexPath.row].key
            
            self.navigationController?.pushViewController(destinationController, animated: true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchController.isActive = false
        
    }
    
    @objc func information(){
        print("Calling Information")
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            pageViewController.viewingDashboardWalkthrough = true
            present(pageViewController, animated: true, completion: nil)
            
            
        }
    }
    
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "Back Button"), for: .normal) // Image can be downloaded from here below link
        
        backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        //let _ = self.navigationController?.popViewController(animated: true)
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    @IBAction func indexChanged(_ sender: Any) {
        // tell the view to relaod then laod the new tableView data & populate the tableView.
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            currentUsers = []
            currentUsers = currentSalvations
            self.view.reloadInputViews()
            self.tableView.reloadData()
            self.navigationController?.navigationBar.topItem?.title = "(\(self.currentUsers.count)) Users"
            
        case 1:
            currentUsers = []
            currentUsers = currentMembers
            self.view.reloadInputViews()
            self.tableView.reloadData()
            self.navigationController?.navigationBar.topItem?.title = "(\(self.currentUsers.count)) Users"
            
        case 2:
            currentUsers = []
            currentUsers = currentGuests
            self.view.reloadInputViews()
            self.tableView.reloadData()
            self.navigationController?.navigationBar.topItem?.title = "(\(self.currentUsers.count)) Users"
            
        case 3:
            currentUsers = []
            currentUsers = currentMiracles
            self.view.reloadInputViews()
            self.tableView.reloadData()
            self.navigationController?.navigationBar.topItem?.title = "(\(self.currentUsers.count)) Users"
            
        default:
            break
        }
    }
    
    
    
    @objc func addUser(){
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            userData(currentSelection: "Salvations")
        case 1:
            userData(currentSelection: "Members")
        case 2:
            userData(currentSelection: "Guests")
        case 3:
            userData(currentSelection: "Miracles")
        default:
            break
        }
    }
    
    func userData(currentSelection: String){
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "addUserData") as! addUserViewController
        
        destinationController.currentSelection = currentSelection
        self.navigationController?.present(destinationController, animated: true, completion: nil)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
