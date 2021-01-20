//
//  socialMediaViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/27/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class socialMediaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate, UISearchResultsUpdating{
    
    //connections
    @IBOutlet weak var tableView: UITableView!
    
    
    //end --------------------------------

    //variables
    var user: ChurchUser!
    var thisSocial: SocialMediaPost!
    
    var data = MinistryData()
    var pendingSocialPosts: [SocialMediaPost] = []
    var socialPosts: [SocialMediaPost] = []
    var thisUser : [Member] = []
    var currentUsers = [Member]()
    
    var administrator = ""
    var associate = ""
    var regular = ""

    //Firebase
    let ref = FIRDatabase.database().reference(withPath: "SocialPosts")
    let blockedRef = FIRDatabase.database().reference(withPath: "BlockedSocialPosts")
    let usersRef = FIRDatabase.database().reference(withPath: "users").child("thisUserInfo")
    
    // firebase string data for current user
    let profileImageView = UIImageView()
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfUid = ""
    var refreshControl: UIRefreshControl!
   
    var searchController: UISearchController!
    var searchResults : [SocialMediaPost] = []
    
    //end --------------------------------
    
    
    
    func getPosts(){
        ref.queryOrdered(byChild: "timeAndDate").observe(.value, with: {snapshot in
            print(snapshot)
            var newSocialPosts: [SocialMediaPost] = []
            
            for item in snapshot.children {
                let socialPostItem = SocialMediaPost(snapshot: item as! FIRDataSnapshot)
                newSocialPosts.insert(socialPostItem, at: 0)
            }
            self.pendingSocialPosts = newSocialPosts
            self.socialPosts = self.pendingSocialPosts
        })
    }
    
    
    
    
    
    
    //unwinds
    @IBAction func unwindToSocialListBasic(segue: UIStoryboardSegue){
        // this is for adding page only
        print("reloading data")
       
        getPosts()
        socialPosts = pendingSocialPosts
        tableView.reloadData()
    }
    
    @IBAction func unwindToSocialMediaList(segue: UIStoryboardSegue){
        let sender = segue.source as? SocialDetailViewController
        if sender?.isBySearch == true{
           
        }else if sender?.isBySearch == false{
            
            //tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    //end --------------------------------
    
    
    override func viewWillAppear(_ animated: Bool) {
        // checks for walkthrough
        if UserDefaults.standard.bool(forKey: "hasViewedSocialWalkthrough"){
            return
        }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            present(pageViewController, animated: true, completion: nil)
            
            pageViewController.viewingSocialWalkthrough = true
        }
        
        // check if offline
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        //socialPosts = []
        //socialPosts = pendingSocialPosts
        //self.tableView.reloadData()
       
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
  
        getPosts()
        
        tableView.reloadData()
    }
    
    //viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FIRAuth.auth()?.currentUser?.uid == self.administrator{
            searchController = UISearchController(searchResultsController: nil)
            tableView.tableHeaderView = searchController.searchBar
            
            searchController.searchResultsUpdater = self
            searchController.dimsBackgroundDuringPresentation = false
        }
        // the information Button
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(informationButton), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
        
        let barButton = UIBarButtonItem.init(customView: button)
        //self.navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = UIColor.blue
        
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSocialPost))
        
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem, barButton], animated: true)
        // --------------
        
        
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
        
        getPosts()
       
        
        fetchUsers()
        fetchUserAndSetupNavBarTitle()
        tableView.reloadData()
        
    }
    
    //end --------------------------------

    
    // Fetching Users
    func fetchUsers(){
        // fetches all the users in the database
        
        FIRDatabase.database().reference().child("members").observe(.value, with: {(snapshot) in
            
            
            var newMembers: [Member] = []
        
            for mem in snapshot.children{
                let thisMember = Member(snapshot: mem as! FIRDataSnapshot)
                newMembers.append(thisMember)
            }
            
            print("the new members: \(newMembers)")
            self.currentUsers = newMembers
            self.tableView.reloadData()
            
        
        }, withCancel: nil)
    }
    
    
    //end------
    
    // for pull to refresh....
    @objc private func refreshOptions(sender: UIRefreshControl) {
        // Perform actions to refresh the content
        // ...
        // and then dismiss the control
     
        getPosts()
      
        self.tableView.reloadData()
        sender.endRefreshing()
    }
    
    
    
    
   
    
    
    //Cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count : Int?
        if FIRAuth.auth()?.currentUser?.uid == self.administrator{
            if searchController.isActive {
                count = searchResults.count
            }else {
                count = socialPosts.count
            }
        }else {
            count = socialPosts.count
        }
        
        return count!
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as?
        SocialTableViewCell
        
        var thisUser: Member!
        
        let social: SocialMediaPost
        
        if FIRAuth.auth()?.currentUser?.uid == self.administrator{
            social = (searchController.isActive) ? searchResults[indexPath.row]: socialPosts[indexPath.row]
        }else {
            social = socialPosts[indexPath.row]
        }
        
        self.thisSocial = social
        cell?.getSocialPost(social: social)
        
        
            if let socialImageUrl = social.userUploadImage {
                cell?.userUploadImage.loadImageUsingCacheWithURLString(urlString: socialImageUrl)
            }
        
        for newUser in currentUsers{
            if social.socialUniq == newUser.key{
                thisUser = newUser
                if let socialIconImageUrl = thisUser.userImageUrl{
                    cell?.socialMediaIcon.loadImageUsingCacheWithURLString(urlString: socialIconImageUrl)
                }
            }
        }
        
       
       
        //cell?.socialMediaIcon.loadImageUsingCacheWithURLString(urlString: currentUserImage)
        
        cell?.socialMediaIcon.layer.borderWidth = 1.5
        cell?.socialMediaIcon.layer.borderColor = #colorLiteral(red: 0.3395062974, green: 0.874027315, blue: 0.9768045545, alpha: 1)
        cell?.socialMediaIcon.clipsToBounds = true
        cell?.socialMediaIcon.layer.cornerRadius = 20
        cell?.cellBackground.layer.shadowOpacity = 0.5
        cell?.cellBackground.layer.shadowOffset = CGSize.zero
        cell?.cellBackground.layer.shadowRadius = 5.0
        cell?.cellBackground.layer.masksToBounds = false
        cell?.cellBackground.layer.cornerRadius = 5
        cell?.socialLikesIcon.tintColor = #colorLiteral(red: 0.9758197665, green: 0.08100775629, blue: 0.2590740323, alpha: 1)
     
        
        return cell!
    }
    
    //end --------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    
        let destinationController = storyboard?.instantiateViewController(withIdentifier: "SocialDetailPage") as!
        SocialDetailViewController
        
        
        if FIRAuth.auth()?.currentUser?.uid == self.administrator{
            if searchController.isActive {
                let social = searchResults[indexPath.row]
                destinationController.socialPosts = social
                destinationController.isBySearch = true
            }else{
                let social = socialPosts[indexPath.row]
                destinationController.socialPosts = social
                destinationController.isBySearch = false
            }
        }else{
            
            destinationController.socialPosts = socialPosts[indexPath.row]
            destinationController.isBySearch = false
        }
        
        destinationController.currentPostUid = currentUsers
        navigationController?.pushViewController(destinationController, animated: true)
        
    }
    
    func filterContent(for searchText: String){
        searchResults = socialPosts.filter({ (post) -> Bool in
            let thisPostName: String? = "\(post.userPostTitle)"
            let thisPostUserUID: String? = "\(post.socialUniq)"
            let thisPostUserName: String? = "\(post.byUserName)"
            //if let name = thisName{
            //  let isMatch = name.localizedCaseInsensitiveContains(searchText)
            // return isMatch
            //}
            if let postName = thisPostName{
                let isMatch = postName.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }else if let userUID = thisPostUserUID{
                let isMatch = userUID.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }else if let userName = thisPostUserName{
                let isMatch = userName.localizedCaseInsensitiveContains(searchText)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        if FIRAuth.auth()?.currentUser?.uid == self.administrator{
            searchController.isActive = false
        }
    }
    
    //FirebaseUser
        // this pulls the user that is currently logged in and posts its name at the top of the navigation bar
    func fetchUserAndSetupNavBarTitle(){
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
    
        //Sets variables with the curent user data
    func setupSocialPostWithUser(user: User){
        print("this is the current user: \(user.username)")
    
        if let profileImageUrl = user.userImageUrl {
            stringOfProfileImageView = profileImageUrl
        }
        print(stringOfProfileImageView)
        
        stringOfProfileName = user.username
        stringOfUid = (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    //end --------------------------------
    
    
    //Action Functions
    
    @objc func addSocialPost() {
        performSegue(withIdentifier: "AddSocialSegue", sender: self)
    }
    
    //end --------------------------------
    
    
    
    
    
    
    
    //Keyboard Actions
        // for adjusting text field distance from bottom
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat = -130
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
        //allows text field to bring up the keyboard
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:true)
    }
    
        //makes keyboard disapear in TextField
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:false)
    }
    
        //for textView
    func animateTextView(textView: UITextView, up: Bool)
    {
        let movementDistance:CGFloat = -260
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        self.animateTextView(textView: textView, up: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        self.animateTextView(textView: textView, up:false)
    }
  
    //end --------------------------------

    
    
    // for deleting personal posts
    
    
    // deleting cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SocialTableViewCell
        
        if self.socialPosts[indexPath.row].socialUniq == FIRAuth.auth()?.currentUser?.uid {
            if editingStyle == .delete{
                self.socialPosts.remove(at: indexPath.row)
                let thisSocialPost = socialPosts[indexPath.row]
                
                let socialRef = FIRDatabase.database().reference(withPath: "SocialPosts").child(thisSocialPost.userPostTitle)
                
                
                socialRef.removeValue()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let thisSocialPost = socialPosts[indexPath.row]
        
        
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: {(action, indexPath)-> Void in
            // Delete the row from the dataSource
           
            
            let socialRef = FIRDatabase.database().reference(withPath: "SocialPosts").child(thisSocialPost.key)
        
            socialRef.removeValue()
            
            self.socialPosts.remove(at: indexPath.row)
            self.tableView.reloadData()
            //self.messages.remove(at: indexPath.row)
            //self.tableView.deleteRows(at: [indexPath], with: .fade)
        
        })
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        var action = [Any]()
        if self.socialPosts[indexPath.row].socialUniq == FIRAuth.auth()?.currentUser?.uid ||  FIRAuth.auth()?.currentUser?.uid == self.administrator{
        action = [deleteAction]
        }else {
            action =  [Any]()
        }
        return action as? [UITableViewRowAction]
    }
    
    //end----
    
    @objc func informationButton() {
        UserDefaults.standard.set(false, forKey: "hasViewedSocialWalkthrough")
        information()
    }
    
    
    func information(){
        print("Calling Information")
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            pageViewController.viewingSocialWalkthrough = true
            present(pageViewController, animated: true, completion: nil)
            
            
        }
    }
    
    // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

//end --------------------------------
