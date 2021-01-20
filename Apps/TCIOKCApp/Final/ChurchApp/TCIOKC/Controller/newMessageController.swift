//
//  newMessageController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/9/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class newMessageController: UITableViewController, UISearchResultsUpdating {
    
    //MARK: Constants
    
    
    //MARK: Properties
    var searchController: UISearchController!
    var searchResults : [Member] = []
    var currentUsers = [Member]()
    var administrators: [Administrator] = []
    var style = ""
    var thisParent : Member!
    var group: Group!
    // unwind to this page
    @IBAction func unwindToUserController(segue: UIStoryboardSegue ){
        
    }
    
    
    
    //MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Style:" + style)
        
        tableView.backgroundColor = .clear
        navigationItem.backBarButtonItem?.isEnabled = true
        
        fetchUsers()
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        print("there are \(currentUsers.count) users")
        
       if style == "addStudent"{
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goToEditStudent))
        }
        
        if style == "chooseStudent"{
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goToChooseStudent))
        }
        
        if style == "editStudent"{
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goToEditStudent))
        }
        
        if style == "addNewUser"{
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(goToAddUser))
        }
    }
    
    @objc func goToAddStudent() {
        
        performSegue(withIdentifier: "unwindToAddNewStudentBasic", sender: self)
    }
    
    @objc func goToChooseStudent() {
        
        performSegue(withIdentifier: "unwindToStudentSelection", sender: self)
    }
    
    @objc func goToEditStudent() {
        
        performSegue(withIdentifier: "unwindToEditStudentBasic", sender: self)
    }
    
    @objc func goToAddUser() {
        
        performSegue(withIdentifier: "unwindToAddNewUser", sender: self)
    }
    
    func fetchUsers(){
        // fetches all the users in the database
        
        let churchMembers = FIRDatabase.database().reference(withPath: "members")
        churchMembers.queryOrdered(byChild: "lastname").observe(.value, with: {snapshot in
            
            var newMembers: [Member] = []
            for member in snapshot.children{
                let thisMember = Member(snapshot: member as! FIRDataSnapshot)
                newMembers.append(thisMember)
            }
            
            self.currentUsers = newMembers
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            self.currentUsers = self.currentUsers.sorted(by: { $0.username!.compare($1.username!) == .orderedAscending
            })
        }, withCancel: nil)
    }
    
    
    @objc func showChatController(){
        print("123")
    }
    
    @objc func handleLogout(){
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count : Int?
        if searchController.isActive {
            count = searchResults.count
        }else {
            count = currentUsers.count
        }
        
        return count!
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as!
        NewMessageControllerTableViewCell
        
        let onlineUsers = (searchController.isActive) ? searchResults[indexPath.row]: currentUsers[indexPath.row]
        
        cell.username.text = onlineUsers.username
        cell.userImage.image = UIImage(named: "pastor")
        cell.layer.masksToBounds = true
        cell.userImage.layer.cornerRadius = 50
        //cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
        //cell.viewBackground.layer.cornerRadius = 50
        //cell.viewBackground.layer.masksToBounds = true
        cell.occupation.text = "\(onlineUsers.firstname!) \(onlineUsers.lastname!)"
        
        
        
        if let userImageUrl = onlineUsers.userImageUrl {
            cell.userImage.loadImageUsingCacheWithURLString(urlString: userImageUrl)
        }
        
        if cell.userImage == nil {
            cell.userImage.image = UIImage(named: "pastor")
        }
        
        print (currentUsers.count)
        
        return cell
    }
    
    func filterContent(for searchText: String){
        searchResults = currentUsers.filter({ (user) -> Bool in
            //let thisName: String? = "\(user.firstname!) \(user.lastname!)"
            //let thisUserName: String? = user.username!
            
            //let thisEmail: String? = user.email!
            
            let thisLastName: String? = user.lastname!
            
            //if let userName = thisUserName{
                //let isMatch = userName.localizedCaseInsensitiveContains(searchText)
                //return isMatch
            //}else if let email = thisEmail{
               // let isMatch = email.localizedCaseInsensitiveContains(searchText)
                //return isMatch
            //}
            if let lastName = thisLastName{
                let isMatch = lastName.localizedCaseInsensitiveContains(searchText)
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
    
    
    var messagesController = MessagesController()

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if style == "chat"{
        let chatLogControllerOne = ChatLogControllerOne(collectionViewLayout: UICollectionViewFlowLayout())
       
        chatLogControllerOne.kind = 1
            if searchController.isActive {
        chatLogControllerOne.user = searchResults[indexPath.row]
        
            }else{
                chatLogControllerOne.user = currentUsers[indexPath.row]
            }
        
        self.navigationController?.show(chatLogControllerOne, sender: self)
        //performSegue(withIdentifier: "ShowMessage", sender: self)
            
        } else if style == "addStudent"{
            if searchController.isActive {
                thisParent = searchResults[indexPath.row] // this is the full array of the parent info
                thisParent.id = searchResults[indexPath.row].key
            }else{
                thisParent = currentUsers[indexPath.row] // this is the full array of the parent info
                thisParent.id = currentUsers[indexPath.row].key
            }
            
            performSegue(withIdentifier: "unwindToAddNewStudent", sender: self)
            
        }else if style == "chooseStudent"{
            // first prompt if this is the correct user, then push to class.
            if searchController.isActive {
                // present with alert
                let alert = UIAlertController(title: "Selecting User", message: "Are you sure you want this member?", preferredStyle: .alert)
                
                let selectAction = UIAlertAction(title: "Confrim", style: .default) { action in
                    
                    self.thisParent = self.searchResults[indexPath.row] // this is the full array of the parent info
                    self.thisParent.id = self.searchResults[indexPath.row].key
                    
                    self.setUser(user: self.thisParent)
                    self.postGroup(user: self.thisParent)
                    self.performSegue(withIdentifier: "unwindToClass", sender: self)
                }
                let returnAction = UIAlertAction(title: "Cancel", style: .default) { action in
                }
                
                // actions of the alert controller
                alert.addAction(selectAction)
                alert.addAction(returnAction)
                
                // action to present the alert controller
                present(alert, animated: true, completion: nil)
                //...
                
                
            }else{
                // present with alert
                let alert = UIAlertController(title: "Selecting User", message: "Are you sure you want this student?", preferredStyle: .alert)
                
                let selectAction = UIAlertAction(title: "Confrim", style: .default) { action in
                    
                    self.thisParent = self.currentUsers[indexPath.row] // this is the full array of the parent info
                    self.thisParent.id = self.currentUsers[indexPath.row].key
                    
                    self.setUser(user: self.thisParent)
                    self.postGroup(user: self.thisParent)
                    self.performSegue(withIdentifier: "unwindToClass", sender: self)
                }
                let returnAction = UIAlertAction(title: "Cancel", style: .default) { action in
                }
                
                // actions of the alert controller
                alert.addAction(selectAction)
                alert.addAction(returnAction)
                
                // action to present the alert controller
                present(alert, animated: true, completion: nil)
                
                //...
                
            }
            
            
        } else if style == "editStudent"{
            if searchController.isActive {
                thisParent = searchResults[indexPath.row] // this is the full array of the parent info
                thisParent.id = searchResults[indexPath.row].key
            }else{
                thisParent = currentUsers[indexPath.row] // this is the full array of the parent info
                thisParent.id = currentUsers[indexPath.row].key
            }
            performSegue(withIdentifier: "unwindToEditStudent", sender: self)
        } else if style == "addNewUser"{
            if searchController.isActive {
                thisParent = searchResults[indexPath.row] // this is the full array of the parent info
                thisParent.id = searchResults[indexPath.row].key
            }else{
                thisParent = currentUsers[indexPath.row] // this is the full array of the parent info
                thisParent.id = currentUsers[indexPath.row].key
            }
            performSegue(withIdentifier: "unwindToAddNewUser", sender: self)
        }
        
    }

    
    @objc func cancelButton(_ sender: Any) {
        if style == "editStudent"{
            performSegue(withIdentifier: "unwindToEditStudentBasic", sender: self)
            
        }
    }
    
    
    func setUser(user: Member){
        
        // where your values come from
        
        let values = ["username": user.email!, "userImageUrl": user.userImageUrl!, "id": user.key, "firstname": user.firstname!, "lastname": user.lastname!, "email": user.email!, "telephone": user.telephone!, "bio": user.bio!, "role": user.role!, "birthday": user.birthday!, "anniversary": user.anniversary!, "profession": user.profession!, "address": user.address!, "gender": user.gender!, "status": user.status!, "work": user.work!, "currentLevelStatus": user.currentLevelStatus!, "allergies": user.allergies!, "hobbies": user.hobbies!, "parentName": user.parentName!, "parentUserName": user.parentUserName!, "parentUid": user.parentUid!, "parentImage": user.parentImage!, "parentEmail": user.parentEmail!, "parentTelephone": user.parentTelephone!, "parentWorkTelephone": user.parentWorkTelephone!, "studentSelected": false] as [String : AnyObject]
      
        let studentChildRef = FIRDatabase.database().reference().child("Categories").child(self.group.category!.lowercased()).child("Groups").child(self.group.key).child("Members")
        
        // stores the values in the usersChildRef path
        let thisStudent = studentChildRef.child(user.key)
        thisStudent.setValue(values)
        
    }
    
    func postGroup(user: Member){
        // posts the Group name/key in the users groups section
        let groupItemRef = FIRDatabase.database().reference(withPath: "users").child(user.key).child("Groups").child("\(group.key)")
        // for main database
        let groupItem = ["key": group.key]
        
        //self.blogs.insert(blogItem, at: 0)
        groupItemRef.updateChildValues(groupItem)
        
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMessage"{
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let destinationController = segue.destination as! ChatLogControllerOne
                if searchController.isActive {
                    destinationController.user = self.searchResults[indexPath.row]
                }else{
                    destinationController.user = self.currentUsers[indexPath.row]
                }
                
                
                destinationController.kind = 1
                
                if style == "addStudent"{
                    if searchController.isActive {
                        thisParent = searchResults[indexPath.row] // this is the full array of the parent info
                        thisParent.id = searchResults[indexPath.row].key
                    }else{
                        thisParent = currentUsers[indexPath.row] // this is the full array of the parent info
                        thisParent.id = currentUsers[indexPath.row].key
                    }
                    
                    
                }
                if style == "chooseStudent"{
                    if searchController.isActive {
                        thisParent = searchResults[indexPath.row] // this is the full array of the parent info
                        thisParent.id = searchResults[indexPath.row].key
                    }else{
                        thisParent = currentUsers[indexPath.row] // this is the full array of the parent info
                        thisParent.id = currentUsers[indexPath.row].key
                    }
                }
                
                if style == "addNewUser"{
                    if searchController.isActive {
                        thisParent = searchResults[indexPath.row] // this is the full array of the parent info
                        thisParent.id = searchResults[indexPath.row].key
                    }else{
                        thisParent = currentUsers[indexPath.row] // this is the full array of the parent info
                        thisParent.id = currentUsers[indexPath.row].key
                    }
                }
            }
        }
    }
}
