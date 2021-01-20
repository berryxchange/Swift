//
//  SocialDetailViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SocialDetailViewController: UIViewController {
    
    @IBOutlet weak var socialDetailScrollView: UIScrollView!
    @IBOutlet weak var userPostImage: UIImageView!
    @IBOutlet weak var socialMediaIcon: UIImageView!
    
    @IBOutlet weak var socialMediaName: UILabel!
    @IBOutlet weak var userPostTime: UILabel!
    
    @IBOutlet weak var userPostTitle: UILabel!
    @IBOutlet weak var userPostPhotoDescription: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var userPostLikes: UILabel!
    @IBOutlet weak var userPostImageShadow: UIView!
    
    @IBOutlet weak var socialMediaIconShadow: UIView!
    @IBOutlet weak var reportPost: UIButton!
    @IBOutlet weak var darkBackground: UIView!
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var reportViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reportText: UITextView!
    @IBOutlet weak var reportItem: UILabel!
    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var data: MinistryData!
    var socialPosts: SocialMediaPost!
    var postImage = ""
    var socialName = ""
    var postTime = ""
    var IndepthTime: String? = ""
    var postTitle = ""
    var photoDescription = ""
    var socialIconImage = ""
    var thisUserPostLikes = 0
    var uid = ""
    var didLike = false
    var administrator = ""
    var associate = ""
    var regular = ""
    var isBySearch = false
    // for firebase
    
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfProfileUid = ""
    var user: Member!
    var currentPostUid: [Member] = []
    var usersRef = FIRDatabase.database().reference(withPath: "users")
    
    
    @IBAction func unwindToSocialDetail(segue: UIStoryboardSegue){
        
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
        self.hideKeyboardWhenTappedAround()
        reportViewTopConstraint.constant = 1000
        darkBackground.isHidden = true
        userPostImage.loadImageUsingCacheWithURLString(urlString: socialPosts.userUploadImage!)
        
        for newUser in currentPostUid{
            if socialPosts.socialUniq == newUser.key{
                socialIconImage = newUser.userImageUrl!
            }
        }
        
        socialName = socialPosts.byUserName
        postTime = socialPosts.timeAndDate
        photoDescription = socialPosts.socialDetails
        postTitle = socialPosts.userPostTitle
        thisUserPostLikes = socialPosts.userPostLikes
        uid = socialPosts.socialUniq
        
        reportView.layer.cornerRadius = 4
        reportText.layer.borderWidth = 1
        reportText.layer.borderColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        
        reportItem.text = socialPosts.userPostTitle
    
        reportButton.layer.cornerRadius = 20
        reportButton.layer.borderWidth = 2
        reportButton.layer.borderColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        
        
        cancelButton.layer.cornerRadius = 20
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        
        if FIRAuth.auth()?.currentUser?.uid == socialPosts.socialUniq {
            self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editSocialPost) ), animated: true)
        }
        
        
        let ref = FIRDatabase.database().reference().child("SocialPosts").child(socialPosts.key)//.child("userPostText")

        let newRef = FIRDatabase.database().reference().child("SocialPosts").child(socialPosts.key).child("userPostLikes")
        
        // Do any additional setup after loading the view.
        // this listens for changes in the values of the database (added, removed, changed)
        //1 - reviews data
        // queryOrdered(byChild:) allows to arrange children in list by "style"
        
        newRef.observe(.value, with: {snapshot in
            
            print("This is the snapshot: \(snapshot)")
            //2 new items are an empty array
            
            var newSocialPosts = 0
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            //}
            
            // 5 - the main "events" are now the adjusted "newEvents"
            //self.events = newEvents
            
            //self.variousItems = newSocialPosts
            //print("the new various Items: \(self.variousItems)")
        
            newSocialPosts = snapshot.value as! Int
            self.thisUserPostLikes = newSocialPosts
            self.userPostLikes.text = "\(self.thisUserPostLikes)"
            print("Your new social likes: \(newSocialPosts)")
            
            self.view.reloadInputViews()
            
            switch self.thisUserPostLikes {
            case 0:
                self.userPostLikes.text = "still waiting..."
            case 1..<1000:
                self.userPostLikes.text = "\(self.thisUserPostLikes) people like this"
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
        
            
        
        socialMediaIcon.loadImageUsingCacheWithURLString(urlString: socialIconImage)
        socialMediaName.text = socialName
        userPostTime.text = postTime
        userPostTitle.text = postTitle
        userPostPhotoDescription.text = photoDescription
       // userPostLikes.text = "\(thisUserPostLikes)"
        socialMediaIcon.layer.borderWidth = 1.5
        socialMediaIcon.layer.borderColor = #colorLiteral(red: 0.3395062974, green: 0.874027315, blue: 0.9768045545, alpha: 1)
        socialMediaIcon.clipsToBounds = true
        socialMediaIcon.layer.cornerRadius = 37.5
        
        socialMediaIconShadow.layer.shadowOpacity = 0.5
        socialMediaIconShadow.layer.shadowOffset = CGSize.zero
        socialMediaIconShadow.layer.shadowRadius = 5.0
        socialMediaIconShadow.layer.masksToBounds = false
        socialMediaIconShadow.layer.cornerRadius = 37.5
        
        
        userPostImageShadow.layer.shadowOpacity = 0.5
        userPostImageShadow.layer.shadowOffset = CGSize.zero
        userPostImageShadow.layer.shadowRadius = 5.0
        userPostImageShadow.layer.masksToBounds = false
        userPostImageShadow.layer.cornerRadius = 5
        
        
        // Do any additional setup after loading the view.
        fetchUserAndSetupNavBarTitle()
    }

    
    @objc func editSocialPost(){
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "EditSocialPost") as!
        AddSocialViewController
        
        destinationController.isEditingSocialPost = true
        destinationController.socialPostDetails = socialPosts
        destinationController.socialPostKey = socialPosts.key
        
        self.navigationController?.show(destinationController, sender: self)
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // reloading the view with constraints and new size based on the eventDetail height
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        contentView.frame.size = CGSize( width:375 , height:300 + userPostPhotoDescription.frame.size.height )
        
        contentView.heightAnchor.constraint(equalToConstant: 410
            + userPostPhotoDescription.frame.size.height ).isActive = true
        
        print(contentView.frame.size.height)
        print("constraint size: \(contentView.heightAnchor.constraint(equalToConstant: 500 + userPostPhotoDescription.frame.size.height ))")
        
        self.reloadInputViews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let newRef = FIRDatabase.database().reference().child("SocialPosts").child(socialPosts.key).child("userPostLikes")
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
                
                let ref = FIRDatabase.database().reference().child("SocialPosts").child(socialPosts.key)
                
                //self.thisUserPostLikes = thisUserPostLikes + 1
                
                userPostLikes.text = "\(thisUserPostLikes)"
                
                
                
                let updateLikes = ["userPostLikes": thisUserPostLikes + 1]
                ref.updateChildValues(updateLikes)
                
               
                UserDefaults.standard.set(true, forKey: "\(ref)didLike")
                
                print(UserDefaults.standard.bool(forKey: "\(ref)didLike"))
                
                self.view.reloadInputViews()
                
                didLike = true
                print(didLike)
                
                //for FirebaseUser
                // adds the whole post to the user for display in user page
                let thisPostItem = SocialMediaPost(socialMediaIcon: self.socialIconImage,
                    byUserName: self.socialName,
                    timeAndDate: self.postTime,
                    userUploadImage: socialPosts.userUploadImage!,  //self.postImage,
                    userPostLikes: self.thisUserPostLikes,
                    userIcon: self.socialIconImage, userPostTitle: self.postTitle,
                    socialDetails: self.photoDescription,
                    socialUniq: self.uid
                    
                    )
                
                //this goes to user set of data not database.
                let nextItemRef = self.usersRef.child(self.stringOfProfileUid).child("SocialLikes").child(socialPosts.key)
                
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
                
                //self.thisUserPostLikes = thisUserPostLikes - 1
                
                userPostLikes.text = "\(thisUserPostLikes)"
                
                let ref = FIRDatabase.database().reference().child("SocialPosts").child(socialPosts.key)
                
                
                let updateLikes = ["userPostLikes": thisUserPostLikes - 1]
                ref.updateChildValues(updateLikes)
                
                didLike = false
                print(didLike)
                
                UserDefaults.standard.set(false, forKey: "\(ref)didLike")
                
                print(UserDefaults.standard.bool(forKey: "\(ref)didLike"))
                
                
                
                //for FirebaseUser
                
                let nextItemRef = self.usersRef.child(stringOfProfileUid).child("SocialLikes").child(socialPosts.key)
                
                nextItemRef.removeValue()
                
                print("successfully removed event from Firebase DB")
                
                self.view.reloadInputViews()
            }
        
        //end-------------
        
    }
    
    
    @IBAction func socialUserProfile(_ sender: Any) {
        var thisUser: Member!
        for mem in currentPostUid{
            if mem.key == uid{
                thisUser = mem
                print("this is the currentUid: \(thisUser.key) this is the postUid: \(uid)" )
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePage") as! userProfileViewController
        
        
                destinationController.isViewingPage = true
                destinationController.stringOfProfileImageView =    self.socialIconImage
                destinationController.stringOfProfileName = self.socialName
                destinationController.stringOfProfileUid = self.uid
        
                self.navigationController?.pushViewController(destinationController, animated: true)
            }
        }
    }
    
    @IBAction func reportPost(_ sender: Any) {
        reportViewTopConstraint.constant = 20
        reportItem.text = socialPosts.userPostTitle
        darkBackground.isHidden = false
        socialDetailScrollView.scrollToTop()
    }
    
    let date = Date()
    let monthFormatter = DateFormatter()
    // for day
    let dayFormatter = DateFormatter()
    //for the full date
    let dateFormatter  = DateFormatter()
    
    @IBAction func sendReportButton(_ sender: Any) {
        // append data to firebase
        
        let complaintRef = FIRDatabase.database().reference().child("Complaints")
        
        //for time format
        monthFormatter.dateFormat = "MM dd, yyyy"
        dayFormatter.dateFormat = "dd"
        dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
        
        // data to send
        let complaintData = Complaint(complaintType: "Social", complaintTitle: socialPosts.userPostTitle, complaintMessage: self.reportText.text, reporterName: stringOfProfileName, reporterUID: stringOfProfileUid, issueCreatorName:socialPosts.byUserName, issueCreatorUID: socialPosts.socialUniq, complaintDate: self.dateFormatter.string(from: Date()), isResolved: "false", complaintNotes: "")
       
        let complaintItemRef = complaintRef.child("Social").childByAutoId()
        complaintItemRef.setValue(complaintData.toAnyObject())
        
        
        reportViewTopConstraint.constant = 1000
        darkBackground.isHidden = true
        reportText.text = "Place your issues here..."
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        reportViewTopConstraint.constant = 1000
         darkBackground.isHidden = true
    }
    
    @IBAction func backButton(){
        if isBySearch == false{
            performSegue(withIdentifier: "unwindToSocialListBasic", sender: self)
        }else if isBySearch == true{
            performSegue(withIdentifier: "unwindToSocialMediaList", sender: self)
        }
       
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowImage"{
          let destinationController = segue.destination as! socialDetailImageViewController
            
            destinationController.image = socialPosts.userUploadImage!
        }
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
