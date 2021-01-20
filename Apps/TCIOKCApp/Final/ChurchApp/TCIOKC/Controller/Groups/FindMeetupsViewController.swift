//
//  FindMeetupsViewController.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/24/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class FindMeetupsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    
    var data = meetupServer()
    var group: Group!
    var allGroups = [Group]()
    var groups = [Group]()
    var searchController: UISearchController!
    //var searchResults : [[Group]] = []
    var categories: [Category] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfUid = ""
    var blockedMembers : [Member] = []
    var administrator = ""
    override func viewWillAppear(_ animated: Bool) {
        fetchUserAndSetupNavBarTitle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        
        //searchController = UISearchController(searchResultsController: nil)
        //AllGroupsTableView.tableHeaderView = searchController.searchBar
        
        //searchController.searchResultsUpdater = self
        //searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.title = "All Groups"
        
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as?
        AllGroupsCollectionViewCell
        
        let thisCategory = categories[indexPath.row]
        cell?.getCategories(category: thisCategory)
        
        cell?.categoryImageOverlay.layer.cornerRadius = 4
        cell?.categoryImageOverlay.layer.masksToBounds = true
        cell?.categoryImageOverlay.layer.borderWidth = 1
        cell?.categoryImageOverlay.layer.borderColor = #colorLiteral(red: 0.5530076101, green: 0.5530076101, blue: 0.5530076101, alpha: 1)
        // Configure the cell...
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "YourMemberGroups") as! YourMemberGroupsTableViewController
        
        controller.administrator = administrator
        controller.category = categories[indexPath.row]
        controller.isCategories = true
        controller.groups = categories[indexPath.row].Groups!
        controller.blockedMembers = blockedMembers
        controller.navigationItem.title = categories[indexPath.row].categoryName
        //print(groups[indexPath.row])
        
        show(controller, sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
       
    }
    
    func loadGroupFromFirebase(UID: String){
        
        var theseCategories: [Category] = []
        // Pulls All groups from firebase
        //let groupsRef = Database.database().reference(withPath: "Groups")
        //groupsRef.queryOrdered(byChild: "groupName").observe(.value, with: {snapshot in
        
        // Loads the groups from firebase
        let ref = FIRDatabase.database().reference()
        ref.child("Categories").observe(.value, with: { categorySnapshot in
            
            for categoryItem in categorySnapshot.children{
                
                let thisCategory = categoryItem as AnyObject
                
                //print(thisCategory.key!)
                //print(thisCategory.value!)
                //self.categories.append("\(thisCategory.key!.capitalizingFirstLetter())")
                
                // format the category
                let thisNewCategory = Category(snapshot: thisCategory as! FIRDataSnapshot)
                print(thisNewCategory)
                if thisNewCategory.Groups != nil{
                    theseCategories.append(thisNewCategory)
                    self.categories = theseCategories
                    print(self.categories.count)
                    self.collectionView.reloadData()
                }
            }
        })
    }
 
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let newRef = FIRDatabase.database().reference().child("Categories")//.child(socialPosts.key).child("userPostLikes")
        newRef.removeAllObservers()
        print("listeners removed!")
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // if segue.identifier == "ShowGroup"{
         //   if let indexPath =  AllGroupsTableView.indexPathForSelectedRow{
           //     let destinationController = segue.destination as!
             //   GroupPageViewController
               // if searchController.isActive {
                //    destinationController.group = searchResults[indexPath.row]
                //}else {
                  //  destinationController.group = allGroups[indexPath.row]
                //}
           // }
        //}
    }
}




extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

