//
//  YourMemberGroupsTableViewController.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/16/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class YourMemberGroupsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    var data = meetupServer()
    var group: Group!
    // find a way to get the key to be the name rather than ""
    var groups: [Group] = []
    var objGroups: [DetailGroup] = []
    var category: Category!
    var isCategories = false
    
    // for group members
    //var members :
    //end
    
    var oldMembers : [String] = ["25", "89", "234", "459", "1,403", "7K.9"]
    
    var members: [Member] = []
    var searchController: UISearchController!
    var searchResults : [Group] = []
    
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfUid = ""
    var blockedMembers: [Member] = []
    var administrator = ""
    
    override func viewWillAppear(_ animated: Bool) {
        fetchUserAndSetupNavBarTitle()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        self.groups = self.groups.sorted(by: {
            $0.groupName?.compare($1.groupName!) == .orderedAscending
        })
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
        
        
        loadGroupFromFirebase(UID: stringOfUid)
        
       
        
        
    }
    
    func loadGroupFromFirebase(UID: String){
        
        if isCategories == false{
            
        }else if isCategories == true{
          
        }
    }
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count : Int?
        if searchController.isActive {
            count = searchResults.count
        }else {
            count = groups.count
        }
        
        return count!
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? YourMemberGroupsTableViewCell

        let group = (searchController.isActive) ? searchResults[indexPath.row]: groups[indexPath.row]
        
        
        cell?.getGroups(group: group)
        
        //cell?.groupMembers.text = "\(members[indexPath.row]) Members"
        cell?.groupImage.layer.cornerRadius = 4
        cell?.groupImage.layer.masksToBounds = true
        cell?.groupImage.layer.borderWidth = 1
        cell?.groupImage.layer.borderColor = #colorLiteral(red: 0.5530076101, green: 0.5530076101, blue: 0.5530076101, alpha: 1)
        // Configure the cell...

        return cell!
    }
    
    
    func filterContent(for searchText: String){
        searchResults = groups.filter({ (group) -> Bool in
            if let name = group.groupName{
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(groups[indexPath.row])
        performSegue(withIdentifier: "ShowGroup", sender: self)
        
    }
    
    @IBAction func goBackButton(_ sender: Any) {
        if isCategories == false{
            dismiss(animated: true, completion: nil)
        }else {
            // dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchController.isActive = false
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGroup"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as!
                GroupPageViewController
                
                if searchController.isActive {
                    destinationController.administrator = administrator
                    destinationController.group = searchResults[indexPath.row]
                    destinationController.blockedMembers = blockedMembers
                }else {
                    destinationController.administrator = administrator
                    destinationController.group = groups[indexPath.row]
                    destinationController.blockedMembers = blockedMembers
                }
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
