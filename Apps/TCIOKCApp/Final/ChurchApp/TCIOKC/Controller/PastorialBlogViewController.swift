//
//  PastorialBlogViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


class PastorialBlogViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var pastorPic: UIImageView!
    
    @IBOutlet weak var pastorBackgroundImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var pastorialTitle: UILabel!
    @IBOutlet weak var pastorName: UILabel!
    @IBOutlet weak var camera: UIButton!
    
    @IBOutlet weak var addPastorialBlog: UIBarButtonItem!
   
    // adding blog to blog list
    
    
    // add post constraints
    
 
    
    
 
    
    
    @IBOutlet weak var postViewTopConstraint: NSLayoutConstraint!
    
    
    var data = MinistryData()
    var blogs: [Blog] = []
    var user: ChurchUser!
    var pastor: Pastor!
   
    
    let ref = FIRDatabase.database().reference(withPath: "blog-items")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    
    var administrator = ""
    var associate = ""
    var regular = ""
    var imagePicker = UIImagePickerController()
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "hasViewedPastoralWalkthrough"){
            return
        }
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            present(pageViewController, animated: true, completion: nil)
            
            pageViewController.viewingPastoralWalkthrough = true
        }
    }
   
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        
        imagePicker.delegate = self
        print("This is the Admin: \(administrator)")
        print("This is the Associate: \(associate)")
        
        title = "Pastorial Blog"
        pastorPic.layer.cornerRadius = 75
        pastorPic.layer.masksToBounds = true
        
        pastorName.text = "\(pastor.firstName!) \(pastor.lastName!)"
        pastorialTitle.text = pastor.pastorTitle
        pastorPic.loadImageUsingCacheWithURLString(urlString: pastor.pastorImage!)
        
        
        print(blogs)
        
        // for the dismissal of keyboard//
        self.hideKeyboardWhenTappedAround()
        
        getBlogs()

    
        tableView.allowsSelectionDuringEditing = false
       
        FIRAuth.auth()!.addStateDidChangeListener { auth, user in
            guard let user = user else { return }
            self.user = ChurchUser(authData: user)
            
            // for users
            //1 - creates a child reference using the uid
            let currentUserRef = self.usersRef.child(self.user.uid)
            
            //2 - use this reference to save to the current users email / username
            currentUserRef.setValue(self.user.userName)
 
            
            //3 - removes the value at the references location after the connection to firebase closes
            currentUserRef.onDisconnectRemoveValue()
        }
    }
    
    
    func getBlogs(){
        // Firebase Auth//
        
        // this listens for changes in the values of the database (added, removed, changed)
        //1 - reviews data
        // queryOrdered(byChild:) allows to arrange children in list by "style"
        ref.child("pastors").child("\(pastor.firstName!)\(pastor.lastName!)").child("blogs").observe(.value, with: {snapshot in
            
            //2 new items are an empty array
            var newBlogs: [Blog] = []
            
            //3 - for every item in snapshot as a child, the groceryItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                let blogItem = Blog(snapshot: item as! FIRDataSnapshot)
                newBlogs.insert(blogItem, at: 0)
                
            }
            
            // 5 - the main "blogss" are now the adjusted "newBlogs"
            self.blogs = newBlogs
            self.tableView.reloadData()
            
            self.checkIfUserIsLoggedIn()
            
        })
    }

func checkIfUserIsLoggedIn(){
    
    if FIRAuth.auth()?.currentUser?.uid == self.administrator || FIRAuth.auth()?.currentUser?.uid == pastor.creatorId{
        
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(informationButton), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        //self.navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = UIColor.blue
        
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(PastorialBlogViewController.addEvent))
        
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem, barButton], animated: true)
        
        
        camera.isHidden = false
        camera.isEnabled = true
        
    } else {
        camera.isHidden = true
        camera.isEnabled = false
        return
    }
}

@objc func addEvent(){
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: "EditPastoralPost") as! AddPastorialBlogViewController
    
    controller.pastor = self.pastor
    //self.present(controller, animated: true, completion: nil)
    show(controller, sender: self)
}

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let newRef = ref.child("pastors").child("\(pastor.firstName!)\(pastor.lastName!)").child("blogs")
        newRef.removeAllObservers()
        print("listeners removed!")
        
    }

    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as?
        PastorialBlogTableViewCell
        let thisBlog = blogs[indexPath.row]
        cell?.getBlog(blog: thisBlog)
        
        
        let pastorialImageUrl = thisBlog.blogImage
            if pastorialImageUrl == ""{
                cell?.blogImage.image = UIImage(named: "nature")
            }else{
        cell?.blogImage.loadImageUsingCacheWithURLString(urlString: pastorialImageUrl!)
            }
        
        return cell!
    }
    
    
    // Actions
    
    
    // take image by camera
    @IBAction func camera(_ sender: UIButton) {
        print("taking a picture!")
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            take()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
        func take(){
            imagePicker.allowsEditing = true
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // for photo gallery
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        pastorPic.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        let pastorRef = FIRDatabase.database().reference().child("blog-items")
        
        //updating the image
        //let imageName = NSUUID().uuidString
        
        let storageRef = FIRStorage.storage().reference().child("PastorialBlog").child("PastorialImage")
        
        if let thisUserImage = self.pastorPic.image, let uploadData = UIImageJPEGRepresentation(thisUserImage, 0.1){
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                guard let metadata = metadata else{
                    
                    print(error!)
                    return
                }
                
                let downloadURL = metadata.downloadURL()
                print(downloadURL!)
                
                let post = ["pastorImage":"\(downloadURL!)"]
                pastorRef.child("pastors").child("\(self.pastor.firstName!)\(self.pastor.lastName!)").child("info").updateChildValues(post)
                
            })
        }
    }
    
    
    // deleting cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SocialTableViewCell
        
        //let thisClass = blogs[indexPath.row]
        
        if FIRAuth.auth()?.currentUser?.uid == administrator {
            if editingStyle == .delete{
                self.blogs.remove(at: indexPath.row)
                let thisBlog = blogs[indexPath.row]
                
                let blogRef = FIRDatabase.database().reference(withPath: "blog-items").child("pastors").child("\(self.pastor.firstName!)\(self.pastor.lastName!)").child("blogs").child(thisBlog.key)
                
                blogRef.removeValue()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let thisBlog = blogs[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: {(action, indexPath)-> Void in
            // Delete the row from the dataSource
            
            
            let blogRef = FIRDatabase.database().reference(withPath: "blog-items").child("pastors").child("\(self.pastor.firstName!)\(self.pastor.lastName!)").child("blogs").child(thisBlog.key)
            
            blogRef.removeValue()
            
            self.blogs.remove(at: indexPath.row)
            self.tableView.reloadData()
            //self.messages.remove(at: indexPath.row)
            //self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        })
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        var action = [Any]()
        if FIRAuth.auth()?.currentUser?.uid == self.administrator {
            action = [deleteAction]
        }else {
            action =  [Any]()
        }
        return action as? [UITableViewRowAction]
    }
    
    //end----

    
    //func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // performSegue(withIdentifier: "ShowBlogDetail", sender: self)
    //}
    
    

    
    @objc func informationButton() {
        UserDefaults.standard.set(false, forKey: "hasViewedPastoralWalkthrough")
        information()
    }
    
    
    func information(){
        print("Calling Information")
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            pageViewController.viewingPastoralWalkthrough = true
            present(pageViewController, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func unwindToPastorialBlog(segue: UIStoryboardSegue){
    
        getBlogs()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "ShowBlogDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as!
                PastorialBlogDetailViewController
                
                destinationController.blogData = [blogs[indexPath.row]]
                
                let pastorialImageUrl = blogs[indexPath.row].blogImage!
                    if pastorialImageUrl == ""{
                        destinationController.image = "nature"
                    }else{
                destinationController.urlImage = blogs[indexPath.row].blogImage!
                    
                }
                destinationController.titleName = blogs[indexPath.row].blogTitle!
                destinationController.date = blogs[indexPath.row].blogDate!
                destinationController.message = blogs[indexPath.row].blogMessage!
                destinationController.uid = blogs[indexPath.row].blogUniq!
                destinationController.likes = blogs[indexPath.row].blogLikes!
                destinationController.blogKey = blogs[indexPath.row].key
                destinationController.administrator = administrator
                destinationController.blogPost = blogs[indexPath.row]
                destinationController.pastor = pastor
                
            }
        }
    }
}




extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

