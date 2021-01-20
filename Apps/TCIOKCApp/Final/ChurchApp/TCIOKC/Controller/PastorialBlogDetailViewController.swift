//
//  PastorialBlogDetailViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MapKit
class PastorialBlogDetailViewController: UIViewController {
  
    @IBOutlet weak var blogImage: UIImageView!
    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogDate: UILabel!
    
    @IBOutlet weak var blogText: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var blogImageShadow: UIView!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var userPostLikes: UILabel!
    
    
    var blogData: [Blog]!
    
    var blogPost: Blog!
    var urlImage = ""
    var image = ""
    var titleName = ""
    var date = ""
    var message = ""
    var likes = 0
    var didLike = false
    var uid = ""
    var administrator = ""
    var pastor: Pastor!
    
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfProfileUid = ""
    var blogKey = ""
    var usersRef = FIRDatabase.database().reference(withPath: "users")
    
    
    
    @IBAction func unwindToPastoralBlogDetail(segue: UIStoryboardSegue){
    
    }
    
    // getting user
    func fetchUserAndSetupNavBarTitle(){
        //1 this pulls the user that is currently logged in's info
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).child("thisUserInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupWorkoutPostWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    //2 sets up the user data
    func setupWorkoutPostWithUser(user: User){
        
        print("this is the current user: \(user.username)")
        
        if let profileImageUrl = user.userImageUrl {
            stringOfProfileImageView = profileImageUrl
        }
        print(stringOfProfileImageView)
        
        stringOfProfileName = user.username
        stringOfProfileUid = (FIRAuth.auth()?.currentUser?.uid)!
        
    }
    //end-----------------
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FIRAuth.auth()?.currentUser?.uid == self.administrator {
            self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editPastoralPost) ), animated: true)
        }
            
        
        print(" this is the blog key: \(blogKey)")
        
        let ref = FIRDatabase.database().reference().child("blog-items").child("pastors").child("\(pastor.firstName!)\(pastor.lastName!)").child("blogs").child(blogKey)
        
        
        let newRef = FIRDatabase.database().reference().child("blog-items").child("pastors").child("\(pastor.firstName!)\(pastor.lastName!)").child("blogs").child(blogKey).child("blogLikes")
        
        // Do any additional setup after loading the view.
        // this listens for changes in the values of the database (added, removed, changed)
        //1 - reviews data
        // queryOrdered(byChild:) allows to arrange children in list by "style"
        
        newRef.observe(.value, with: {snapshot in
            
            print("This is the snapshot: \(snapshot)")
            //2 new items are an empty array
            
            var newBlogLikes = 0
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            //}
            
            // 5 - the main "events" are now the adjusted "newEvents"
            //self.events = newEvents
            
            //self.variousItems = newSocialPosts
            //print("the new various Items: \(self.variousItems)")
            
            newBlogLikes = snapshot.value as! Int
            self.likes = newBlogLikes
            self.userPostLikes.text = "\(self.likes)"
            print("Your new social likes: \(newBlogLikes)")
            
            self.view.reloadInputViews()
            
            switch self.likes {
            case 0:
                self.userPostLikes.text = "still waiting..."
            case 1..<1000:
                self.userPostLikes.text = "\(self.likes) people like this"
            case 1000..<1500:
                self.userPostLikes.text = "1K+ people like this"
            case 1500..<2000:
                self.userPostLikes.text = "1.5K+ people like this"
            case 2000..<2500:
                self.userPostLikes.text = "2K+ people like this"
            case 2500..<3000:
                self.userPostLikes.text = "2.5K+ people like this"
            case 3000..<3500:
                self.userPostLikes.text = "3K+ people like this"
            case 3500..<4000:
                self.userPostLikes.text = "3.5K+ people like this"
            case 4000..<4500:
                self.userPostLikes.text = "4K+ people like this"
            case 4500..<5000:
                self.userPostLikes.text = "4.5K+ people like this"
            case 5000..<5500:
                self.userPostLikes.text = "5K+ people like this"
            case 5500..<6000:
                self.userPostLikes.text = "5.5K+ people like this"
            case 6000..<6500:
                self.userPostLikes.text = "6K+ people like this"
            case 6500..<7000:
                self.userPostLikes.text = "6.5K+ people like this"
            case 7000..<7500:
                self.userPostLikes.text = "7K+ people like this"
            case 7500..<8000:
                self.userPostLikes.text = "7.5K+ people like this"
            case 8000..<8500:
                self.userPostLikes.text = "8K+ people like this"
            case 8500..<9000:
                self.userPostLikes.text = "8.5K+ people like this"
            case 9000..<9500:
                self.userPostLikes.text = "9K+ people like this"
            case 9500..<10000:
                self.userPostLikes.text = "9.5K+ people like this"
            case 10000..<100000:
                self.userPostLikes.text = "10K+ people like this"
            default:
                break
                
            }
            
        })
        
        if UserDefaults.standard.bool(forKey: "\(ref)didLike") {
            likeButton.isSelected = true
            
            let originalButtonImage = UIImage(named: "Like Button Icon")
            
            let tintedButtonImage = originalButtonImage?.withRenderingMode(.alwaysTemplate)
            
            likeButton.setImage(tintedButtonImage, for: .normal)
            
            likeButton.tintColor = #colorLiteral(red: 0.9758197665, green: 0.08100775629, blue: 0.2590740323, alpha: 1)
        }else {
            likeButton.isSelected = false
            
            let originalButtonImage = UIImage(named: "Like Button Icon")
            
            let tintedButtonImage = originalButtonImage?.withRenderingMode(.alwaysTemplate)
            
            likeButton.setImage(tintedButtonImage, for: .normal)
            
            likeButton.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        
        

        print(blogData)
        if image == ""{
        blogImage.loadImageUsingCacheWithURLString(urlString: urlImage)
        }else{
            blogImage.image = UIImage(named: image)
        }
        
        blogImageShadow.layer.shadowOpacity = 0.5
        blogImageShadow.layer.shadowOffset = CGSize.zero
        blogImageShadow.layer.shadowRadius = 5.0
        blogImageShadow.layer.masksToBounds = false
        
        blogTitle.text = titleName
        blogText.text = message
        blogDate.text = date
        
        
        // Do any additional setup after loading the view.
        fetchUserAndSetupNavBarTitle()
    }

    @objc func editPastoralPost(){
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "EditPastoralPost") as!
        AddPastorialBlogViewController
        
        destinationController.isEditingPastoralPost = true
        destinationController.pastoralPost = blogPost
        destinationController.pastoralPostKey = self.blogKey
        destinationController.pastor = pastor
        self.navigationController?.show(destinationController, sender: self)
    }
    
    
    // reloading the view with constraints and new size based on the eventDetail height
    override func viewDidAppear(_ animated: Bool) {
        
        contentView.frame.size = CGSize( width:375 , height:510 + blogText.frame.size.height )
        
        contentView.heightAnchor.constraint(equalToConstant: 400 + blogText.frame.size.height ).isActive = true
        
        print("the updated ContentView size: \(contentView.frame.size.height)")
        print("constraint size: \(contentView.heightAnchor.constraint(equalToConstant: 500 + blogText.frame.size.height ))")
        
        self.reloadInputViews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let newRef = FIRDatabase.database().reference().child("blog-items").child("pastors").child("\(pastor.firstName!)\(pastor.lastName!)").child("blogs").child(blogKey)
        newRef.removeAllObservers()
        print("listeners removed!")
        
    }

    
    
    @IBAction func likeButton(_ sender: Any) {
        
        if likeButton.isSelected == false {
            
            let originalButtonImage = UIImage(named: "Like Button Icon")
            
            let tintedButtonImage = originalButtonImage?.withRenderingMode(.alwaysTemplate)
            
            likeButton.setImage(tintedButtonImage, for: .normal)
            
            likeButton.tintColor = #colorLiteral(red: 0.9758197665, green: 0.08100775629, blue: 0.2590740323, alpha: 1)
            
            self.likeButton.isSelected = true
            
            let ref = FIRDatabase.database().reference().child("blog-items").child("pastors").child("\(pastor.firstName!)\(pastor.lastName!)").child("blogs").child(blogKey)
            
            //self.likes = likes + 1
            
            userPostLikes.text = "\(likes)"
            
            let updateLikes = ["blogLikes": likes + 1]
            ref.updateChildValues(updateLikes)
            
            
            
            UserDefaults.standard.set(true, forKey: "\(ref)didLike")
            
            print(UserDefaults.standard.bool(forKey: "\(ref)didLike"))
            
            self.view.reloadInputViews()
            
            didLike = true
            print(didLike)
            
            //for FirebaseUser
            // adds the whole post to the user for display in user page
            let thisPostItem = Blog(blogTitle: self.titleName, blogMesage: self.message, blogDate: self.date, blogImage: self.urlImage, blogLikes: self.likes, blogUniq: self.uid)
            
            //this goes to user set of data not database.
            let nextItemRef = self.usersRef.child(self.stringOfProfileUid).child("blog-items").child(blogKey)
            
            nextItemRef.setValue(thisPostItem.toAnyObject())
            
            print("successfully stored event into Firebase DB")
            
            self.view.endEditing(true)
            
            //end-------------
            
        } else {
            let originalButtonImage = UIImage(named: "Like Button Icon")
            
            let tintedButtonImage = originalButtonImage?.withRenderingMode(.alwaysTemplate)
            
            likeButton.setImage(tintedButtonImage, for: .normal)
            
            likeButton.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            
            self.likeButton.isSelected = false
            
            //self.likes = likes - 1
            
            userPostLikes.text = "\(likes)"
            
            let ref = FIRDatabase.database().reference().child("blog-items").child("pastors").child("\(pastor.firstName!)\(pastor.lastName!)").child("blogs").child(blogKey)
            
            let updateLikes = ["blogLikes": likes - 1]
            ref.updateChildValues(updateLikes)
            
            didLike = false
            print(didLike)
            
            UserDefaults.standard.set(false, forKey: "\(ref)didLike")
            
            print(UserDefaults.standard.bool(forKey: "\(ref)didLike"))
            
            
            
            //for FirebaseUser
            
            let nextItemRef = self.usersRef.child(stringOfProfileUid).child("blog-items").child(blogKey)
            
            nextItemRef.removeValue()
            
            print("successfully removed event from Firebase DB")
            
            self.view.reloadInputViews()
        }
        
        //end-------------
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
