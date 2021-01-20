//
//  userProfileViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 4/28/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import MessageUI
import SafariServices
import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr()
        zeroAddress.sa_len = UInt8(MemoryLayout<sockaddr>.size)
        zeroAddress.sa_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else { return false }
        
        var flags = SCNetworkReachabilityFlags()
        guard SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) else { return false }
        
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }
    
}


class userProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate  {
    
    var Susername = ""
    var Sfirstname = ""
    var Slastname = ""
    var Semail = ""
    var Stelephone = ""
    var Sbio = ""
    
    
    let paymentLink = "https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=4GZZCSU6KV5R2"
    var sRole = ""
    var thisUser: Member!
    var Spassword = ""
    var currentLevelStatus = ""
    
    @IBOutlet weak var profileScrollView: UIScrollView!
    
    
    @IBOutlet weak var profileImageBackgroundPad: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var othersCollectionView: UICollectionView!
    
    
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var interactionPad: UIView!
    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var messageButtonPad: UIView!
    // for edits to the user
    
    
    @IBOutlet weak var emptyCollectionImage: UIImageView!
    
    
    @IBOutlet weak var participationCollectionView: UICollectionView!
    
    
    //end---------
    
    @IBOutlet weak var titheButton: UIButton!
    @IBOutlet weak var titheButtonPad: UIView!
    
    @IBOutlet weak var eventsButtonPad: UIView!
    @IBOutlet weak var eventInterestCount: UILabel!
    @IBOutlet weak var interestLabel: UILabel!
    @IBOutlet weak var socialPostsPad: UIView!
    @IBOutlet weak var socialPostsCount: UILabel!
    @IBOutlet weak var socialLabel: UILabel!
    @IBOutlet weak var PrayerRequestsPad: UIView!
    @IBOutlet weak var prayerPostsCount: UILabel!
    @IBOutlet weak var prayerLabel: UILabel!
    // @IBOutlet weak var segmentControl: UISegmentedControl!
    
    // report button
    
    @IBOutlet weak var reportView: UIView!
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var reportViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reportItem: UILabel!
    @IBOutlet weak var darkBackground: UIView!
    @IBOutlet weak var reportText: UITextView!
    @IBOutlet weak var submitReportButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    var isViewingPage = false
    var isAdmin = false
    
    
    @IBOutlet weak var involvementTextPad: UIView!
    @IBOutlet weak var involvementPad: UIView!
    
    @IBOutlet weak var othersTextPad: UIView!
    @IBOutlet weak var othersPad: UIView!
    
    @IBOutlet weak var administrativeTextPad: UIView!
    @IBOutlet weak var administrativePad: UIView!
    
    @IBOutlet weak var administrativeTextPadTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var administrativeTextPadHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var administratorPadHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var adminSwitch: UISwitch!
    
    
    @IBAction func unwindToProfile(segue: UIStoryboardSegue){
        self.view.reloadInputViews()
    }
    @IBAction func unwindToProfileSaved(segue: UIStoryboardSegue){
        let receivingDestination = segue.source as!
        AddStudentViewController
        
        // add a username text input
        fullName.text = "\(receivingDestination.firstName) \(receivingDestination.lastName)"
        email.text = receivingDestination.email.text!
        profileImage.image = receivingDestination.userImage.image!
        //userBio.text = Sbio
        self.view.reloadInputViews()
    }
    
    
    
    // counted data that User creates or is attending(1)
    var attending: [Meetup] = []
    var isAttending = false
    var socialCount: [SocialMediaPost] = []
    var isSocial = false
    var prayerCount: [Prayer] = []
    var isPrayer = false
    var participationStyle = [Any]()
    //end--------
    
    // scrolling data
    var prayers : [Prayer] = []
    var socialLikes : [SocialMediaPost] = []
    var pastorialLikes : [Blog] = []
    // end-------
    
    var user: User?
    var theFullUserData: [User] = []
    var displayingData = [Any]()
    var participationData = [Any]()
    
    // for the messageUI
    enum MIMEType: String {
        case jpg = "image/jpeg"
        case png = "image/png"
        case doc = "application/msword"
        case ppt = "application/vnd.ms-powerpoint"
        case html = "text/html"
        case pdf = "application/pdf"
        
        init?(type: String){
            switch type.lowercased(){
            case "jpg": self = .jpg
            case "png": self = .png
            case "doc": self = .doc
            case "ppt": self = .ppt
            case "html": self = .html
            case "pdf": self = .pdf
            default: return nil
            }
        }
    }
    
    
    //end---------
    
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    // for firebase
    
    
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfProfileUid = ""
    
    var reporterStringOfProfileImageView = ""
    var reporterStringOfProfileName = ""
    var reporterStringOfProfileUid = ""
    
    
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    
    var membersRef = FIRDatabase.database().reference().child("members")
    var AdministratorRef = FIRDatabase.database().reference().child("Administrators")
    
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        // Information Button
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(informationButton), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = UIColor.blue
        //end...
        
        
        // for reachability
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        //end...
        
        
        // the counts for each activity
        print("the socialCount: \(socialCount.count)")
        eventInterestCount.text = "\(attending.count)"
        socialPostsCount.text = "\(socialCount.count)"
        prayerPostsCount.text = "\(prayerCount.count)"
        //end
        
        // the user info
        userName.text = Susername
        fullName.text = "\(Sfirstname) \(Slastname)"
        email.text = Semail
        //end
        
        // the others activity
        othersCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
        if prayers.isEmpty{
            emptyCollectionImage.isHidden = false
            othersCollectionView.isHidden = true
        }else{
            emptyCollectionImage.isHidden = true
            othersCollectionView.isHidden = false
            self.view.reloadInputViews()
            self.othersCollectionView.reloadData()
            print(displayingData)
        }
        //end...
        
        // buttons
        deleteAccountButton.churchAppButtonImportant()
        
        
        // UIViews as backgrounds
        
        interactionPad.layer.cornerRadius = 4
        interactionPad.layer.shadowOpacity = 0.4
        interactionPad.layer.shadowOffset = CGSize(width: 2, height: 1)
        interactionPad.layer.shadowRadius = 4.0
        interactionPad.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //switch for viewed walkthrough
        if UserDefaults.standard.bool(forKey: "hasViewedProfileWalkthrough"){
            return
        }
        if isViewingPage == true{
            // do something
        }else{
            if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
                present(pageViewController, animated: true, completion: nil)
                
                pageViewController.viewingProfileWalkthrough = true
            }
        }
        
        //reloads page input
        view.reloadInputViews()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // report view
        self.hideKeyboardWhenTappedAround()
        reportViewTopConstraint.constant = 2000
        darkBackground.isHidden = true
        
        
        reportView.layer.cornerRadius = 4
        reportText.layer.borderWidth = 1
        reportText.layer.borderColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        
        
        
        involvementTextPad.layer.cornerRadius = 4
        
        involvementPad.layer.cornerRadius = 4
        
        involvementPad.layer.shadowOpacity = 0.4
        involvementPad.layer.shadowOffset = CGSize(width: 2, height: 1)
        involvementPad.layer.shadowRadius = 4.0
        
        othersTextPad.layer.cornerRadius = 4
        othersPad.layer.cornerRadius = 4
        
        othersPad.layer.shadowOpacity = 0.4
        othersPad.layer.shadowOffset = CGSize(width: 2, height: 1)
        othersPad.layer.shadowRadius = 4.0
        
        administrativeTextPad.layer.cornerRadius = 4
        administrativePad.layer.cornerRadius = 4
        
        administrativePad.layer.shadowOpacity = 0.4
        administrativePad.layer.shadowOffset = CGSize(width: 2, height: 1)
        administrativePad.layer.shadowRadius = 4.0
        
        reportItem.text = "\(Susername)'s Profile"
        
        submitReportButton.churchAppButtonRegular()
        
        
        cancelButton.churchAppButtonRegular()
        // end...
        
        
        //Delegates
        imagePicker.delegate = self
        
        self.hideKeyboardWhenTappedAround()
        
        //styling page
        
        
        
        //end...
        
        // permissions
        //1 - is the admin
        if isAdmin == true{
            messageButton.isHidden = false
            messageButton.churchAppButtonRegular()
            titheButton.isEnabled = false
            titheButton.isHidden = true
            titheButtonPad.isHidden = true
            
            deleteAccountButton.isEnabled = true
            deleteAccountButton.isHidden = false
            
            administrativePad.isHidden = false
            administrativeTextPad.isHidden = false
            administrativeTextPadTopConstraint.constant = 40
            administrativeTextPadHeightConstraint.constant = 30
            administratorPadHeightConstraint.constant = 87
            
            
            profileImage.loadImageUsingCacheWithURLString(urlString: stringOfProfileImageView)
            
            
            reportButton.isEnabled = false
            reportButton.isHidden = true
            //2 is the admin and not viewing the page (the current user)
        }else if isViewingPage == false && isAdmin == false{
            
            administrativePad.isHidden = true
            administrativeTextPad.isHidden = true
            administrativeTextPadTopConstraint.constant = 0
            administrativeTextPadHeightConstraint.constant = 0
            administrativeTextPadHeightConstraint.constant = 0
            
            let button = UIButton.init(type: .system)
            button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
            button.addTarget(self, action:#selector(informationButton), for:.touchUpInside)
            button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
            let barButton = UIBarButtonItem.init(customView: button)
            //self.navigationItem.rightBarButtonItem = barButton
            barButton.tintColor = UIColor.blue
            
            let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editInfo))
            self.navigationItem.setRightBarButtonItems([barButton, editButton], animated: true)
            
            messageButton.isHidden = true
            
            reportButton.isEnabled = false
            reportButton.isHidden = true
            //3 is viewing the page and not an admin (another user)
        }else{
            
            administrativePad.isHidden = true
            administrativeTextPad.isHidden = true
            administrativeTextPadTopConstraint.constant = 0
            administrativeTextPadHeightConstraint.constant = 0
            administrativeTextPadHeightConstraint.constant = 0
            
            
            userName.text = stringOfProfileName
            titheButton.isEnabled = false
            titheButton.isHidden = true
            titheButtonPad.isHidden = true
            
            print("this is the ref key " + usersRef.key)
            profileImage.loadImageUsingCacheWithURLString(urlString: stringOfProfileImageView)
            
            
            deleteAccountButton.isEnabled = false
            deleteAccountButton.isHidden = true
        }
        
        print(" this is the status of the page: \(isViewingPage)")
        
        
        
        
        
        
        // for the user data
        
        //let userDataRef = usersRef.child(self.stringOfProfileUid).child("thisUserInfo")
        
        let thisMemberRef = FIRDatabase.database().reference(withPath: "members")
        
        thisMemberRef.observe(.value, with: {snapshot in
            
            
            var newMembers: [Member] = []
            
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                print(item)
                let memberItem = Member(snapshot: item as! FIRDataSnapshot)
                newMembers.append(memberItem)
            }
            for i in newMembers{
                if i.key == self.stringOfProfileUid{
                    self.userSetup(user: i)
                    self.thisUser = i
                    self.view.reloadInputViews()
                }
            }
            
        })
        
        //Firebase getting data
        // preloads the data
        
        // this listens for changes in the values of the database (added, removed, changed)
        //1 is the admin
        if isAdmin == true{
            print("uid: \(stringOfProfileUid)")
            print("name: \(stringOfProfileName)")
            print("imageView : \(stringOfProfileImageView)")
            
            reporterStringOfProfileName = (FIRAuth.auth()?.currentUser?.email)!
            reporterStringOfProfileUid = (FIRAuth.auth()?.currentUser?.uid)!
            //2 is the current user
        }else if isViewingPage == false && isAdmin == false{
            
            stringOfProfileUid = (FIRAuth.auth()?.currentUser?.uid)!
            userName.text = Susername
            fullName.text = "\(Sfirstname) \(Slastname)"
            email.text = Semail
            
            
            //3 is another user
        }else{
            reporterStringOfProfileName = (FIRAuth.auth()?.currentUser?.email)!
            reporterStringOfProfileUid = (FIRAuth.auth()?.currentUser?.uid)!
            
            print("uid: \(stringOfProfileUid)")
            print("name: \(stringOfProfileName)")
            print("imageView : \(stringOfProfileImageView)")
            
        }
        
        
        //end-----------
        
        //end-------
        
        
        // for attending and self created data
        
        //  Attending array
        let eventsAttendingItemRef = usersRef.child(self.stringOfProfileUid).child("Meetups")
        
        eventsAttendingItemRef.queryOrdered(byChild: "meetupStartDate").observe(.value, with: {snapshot in
            
            print(snapshot)
            //2 new items are an empty array
            var newAttendance: [Meetup] = []
            
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                
                let AttendanceItem = Meetup(snapshot: item as! FIRDataSnapshot)
                newAttendance.insert(AttendanceItem, at: 0)
                
                
                self.attending = newAttendance
                self.participationData = self.attending
                self.participationCollectionView.reloadData()
            }
        })
        
        //end-----------
        
        //  Social created array
        let socialCreatedItemRef = usersRef.child(self.stringOfProfileUid).child("MyParticipation").child("Social")
        
        socialCreatedItemRef.queryOrdered(byChild: "timeAndDate").observe(.value, with: {snapshot in
            
            print(snapshot)
            //2 new items are an empty array
            var newCreatedSocial: [SocialMediaPost] = []
            
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                
                let createdSocialItem = SocialMediaPost(snapshot: item as! FIRDataSnapshot)
                newCreatedSocial.insert(createdSocialItem, at: 0)
                
                
                self.socialCount = newCreatedSocial
                
            }
        })
        
        //end-----------
        
        //  Prayers created array
        let prayersCreatedItemRef = usersRef.child(self.stringOfProfileUid).child("MyParticipation").child("Prayers")
        
        prayersCreatedItemRef.queryOrdered(byChild: "prayerFullDate").observe(.value, with: {snapshot in
            
            print(snapshot)
            //2 new items are an empty array
            var newCreatedPrayer: [Prayer] = []
            
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                
                let createdPrayerItem = Prayer(snapshot: item as! FIRDataSnapshot)
                newCreatedPrayer.insert(createdPrayerItem, at: 0)
                
                
                self.prayerCount = newCreatedPrayer
                
            }
        })
        
        //end-----------
        
        // end------------------------------
        
        // for prayer array
        let prayerAgreementsItemRef = usersRef.child(self.stringOfProfileUid).child("PrayerAgreements")
        
        prayerAgreementsItemRef.queryOrdered(byChild: "prayerFullDate").observe(.value, with: {snapshot in
            
            print(snapshot)
            //2 new items are an empty array
            var newPrayerAgreements: [Prayer] = []
            
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                
                let prayerAgreementItem = Prayer(snapshot: item as! FIRDataSnapshot)
                newPrayerAgreements.insert(prayerAgreementItem, at: 0)
                
                
                self.prayers = newPrayerAgreements
                
            }
            
            
            
            // here is where you call the first loads for the footer scroller
            self.displayingData = self.prayers
            print("here is the first data: \(self.displayingData)")
            self.othersCollectionView.reloadData()
        })
        
        //end-----------
        
        // for socialLikes array
        let socialLikesAgreementsItemRef = self.usersRef.child(self.stringOfProfileUid).child("SocialLikes")
        
        socialLikesAgreementsItemRef.queryOrdered(byChild: "timeAndDate").observe(.value, with: {snapshot in
            
            print(snapshot)
            //2 new items are an empty array
            var newSocialLikesAgreements: [SocialMediaPost] = []
            
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                
                let socialLikesAgreementItem = SocialMediaPost(snapshot: item as! FIRDataSnapshot)
                newSocialLikesAgreements.insert(socialLikesAgreementItem, at: 0)
                
                
                self.socialLikes = newSocialLikesAgreements
                
            }
        })
        
        
        //end-----------
        
        // for pastorialLikes array
        let pastorialLikesAgreementsItemRef = self.usersRef.child(self.stringOfProfileUid).child("blog-items")
        
        pastorialLikesAgreementsItemRef.queryOrdered(byChild: "timeAndDate").observe(.value, with: {snapshot in
            
            print(snapshot)
            //2 new items are an empty array
            var newPastorialLikesAgreements: [Blog] = []
            
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                
                let pastorialLikesAgreementItem = Blog(snapshot: item as! FIRDataSnapshot)
                newPastorialLikesAgreements.insert(pastorialLikesAgreementItem, at: 0)
                
                
                self.pastorialLikes = newPastorialLikesAgreements
                
            }
        })
        
        
        
        //end-----------
        
        if isViewingPage == false && isAdmin == false{
            fetchUserAndSetupNavBarTitle()
        }
        
        
        profileImageBackgroundPad.layer.shadowOpacity = 0.5
        profileImageBackgroundPad.layer.shadowOffset = CGSize.zero
        profileImageBackgroundPad.layer.shadowRadius = 5.0
        profileImageBackgroundPad.layer.masksToBounds = false
        
        profileImageBackgroundPad.layer.cornerRadius = 55
        self.profileImage.layer.cornerRadius = 50
        
        messageButton.churchAppButtonRegular()
        //messageButtonPad.layer.cornerRadius = 22.5
        
        
        
        titheButton.churchAppButtonRegular()
        
        
        
        // the 3 tabs
        eventsButtonPad.layer.borderWidth = 0.5
        eventsButtonPad.layer.borderColor = UIColor.gray.cgColor
        
        socialPostsPad.layer.borderWidth = 0.5
        socialPostsPad.layer.borderColor = UIColor.gray.cgColor
        
        PrayerRequestsPad.layer.borderWidth = 0.5
        PrayerRequestsPad.layer.borderColor = UIColor.gray.cgColor
        
        participationCollectionView.reloadData()
        participationData = attending
        isAttending = true
        isPrayer = false
        isSocial = false
        eventInterestCount.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        interestLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        eventsButtonPad.layer.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        participationCollectionView.reloadData()
        print(participationData)
        
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
                self.setupPrayerPostWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    
    //2 sets up the user data
    func setupPrayerPostWithUser(user: User){
        
        print("this is the current user: \(user.username)")
        
        if let profileImageUrl = user.userImageUrl {
            stringOfProfileImageView = profileImageUrl
        }
        print(stringOfProfileImageView)
        //userName
        stringOfProfileName = user.username
        stringOfProfileUid = (FIRAuth.auth()?.currentUser?.uid)!
        userName.text = stringOfProfileName
        
        profileImage.loadImageUsingCacheWithURLString(urlString: stringOfProfileImageView)
    }
    
    //end-----------------
    
    
    func userSetup(user: Member){
        Susername = user.username!
        Sfirstname = user.firstname!
        Slastname = user.lastname!
        Semail = user.email!
        Stelephone = user.telephone!
        Sbio = user.bio!
        
        if user.role == "admin"{
            self.adminSwitch.setOn(true, animated: true)
        }else{
            self.adminSwitch.setOn(false, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if collectionView == othersCollectionView{
            count = displayingData.count
        }
        if collectionView == participationCollectionView{
            count = participationData.count
        }
        return count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        
        if collectionView == othersCollectionView {
            let thisCell = cell as?
            profileCollectionViewCell
            
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                
                let thisPrayer = prayers[indexPath.row]
                thisCell?.getPrayer(prayer:thisPrayer)
                
            case 1:
                let socialMedia = socialLikes[indexPath.row]
                thisCell?.getSocialLikes(social: socialMedia)
                if let socialImageUrl = socialMedia.userUploadImage{
                    thisCell?.collectionImage.loadImageUsingCacheWithURLString(urlString: socialImageUrl)
                }
                
            case 2:
                let pastorialMedia = pastorialLikes[indexPath.row]
                thisCell?.getPastorialBlogLikes(blog: pastorialMedia)
                if let pastorialImageUrl = pastorialMedia.blogImage{
                    thisCell?.collectionImage.loadImageUsingCacheWithURLString(urlString: pastorialImageUrl)
                }
                
            default:
                break
                
            }
        }
        
        // for participation loads
        if collectionView == participationCollectionView {
            let thisCell = cell as?
            participationPostsCollectionViewCell
            
            if isAttending == true{
                let thisParticipation = participationData[indexPath.row] as! Meetup
                thisCell?.participationImage.image = UIImage(named: "")
                thisCell?.participationTitle.text = thisParticipation.meetupName
            }else if isSocial == true{
                let thisParticipation = participationData[indexPath.row] as! SocialMediaPost
                thisCell?.participationImage.loadImageUsingCacheWithURLString(urlString: thisParticipation.userUploadImage!)
                thisCell?.participationTitle.text = thisParticipation.userPostTitle
            }else if isPrayer == true{
                let thisParticipation = participationData[indexPath.row] as! Prayer
                thisCell?.participationImage.image = UIImage(named:"")
                thisCell?.participationTitle.text = thisParticipation.prayerPostTitle
            }
            
        }
        
        cell.layer.cornerRadius = 5
        
        return cell
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
    
    
    /* //MARK: - Saving Image here
     @IBAction func save(_ sender: AnyObject) {
     
     UIImageWriteToSavedPhotosAlbum(profileImage.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
     
     }
     
     //MARK: - Add image to Library
     @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
     if let error = error {
     // we got back an error!
     let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
     ac.addAction(UIAlertAction(title: "OK", style: .default))
     present(ac, animated: true)
     } else {
     let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
     ac.addAction(UIAlertAction(title: "OK", style: .default))
     present(ac, animated: true)
     }
     
     
     }
     
     */
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        profileImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        let thisRef = usersRef.child(stringOfProfileUid).child("thisUserInfo")
        
        //updating the image
        let imageName = NSUUID().uuidString
        
        let storageRef = FIRStorage.storage().reference().child("Users").child(stringOfProfileUid).child("Profile Image").child(imageName)
        
        if let thisUserImage = self.profileImage.image, let uploadData = UIImageJPEGRepresentation(thisUserImage, 0.1){
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                guard let metadata = metadata else{
                    
                    print(error!)
                    return
                }
                
                let downloadURL = metadata.downloadURL()
                print(downloadURL!)
                
                let post = ["userImageUrl":"\(downloadURL!)"]
                thisRef.updateChildValues(post)
                print("the UID: \(self.stringOfProfileUid)")
                
                // for the users section of members
                let membersRef = FIRDatabase.database().reference(withPath: "members").child(self.stringOfProfileUid)
                membersRef.updateChildValues(post)
                
                
                // for FIRAuth User update
                
                let thisAuthUser = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                thisAuthUser?.photoURL = downloadURL!
            })
        }
    }
    
    //sending Message
    @IBAction func messageButton(_ sender: Any) {
        print("I am going to send a mesaage!")
        
        let alert = UIAlertController(title: "How do you want to send your message", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "App Message", style: .default, handler: { _ in
            // function here
            self.internalMessage()
        }))
        if Semail == ""{
        }else {
            alert.addAction(UIAlertAction(title: "Email", style: .default, handler: { _ in
                // function here
                self.Email()
            }))
        }
        if Stelephone == ""{
        }else {
            alert.addAction(UIAlertAction(title: "Text Message", style: .default, handler: { _ in
                // function here
                self.TextMessage()
            }))
        }
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func internalMessage(){
        
        let chatLogControllerOne = ChatLogControllerOne(collectionViewLayout: UICollectionViewFlowLayout())
        
        
        //let thisuser = FIRAuth.auth()?.currentUser
        
        //chatLogControllerOne.user = user
        
        chatLogControllerOne.stringOfProfileUid = stringOfProfileUid
        chatLogControllerOne.stringOfProfileName = stringOfProfileName
        chatLogControllerOne.stringOfProfileImageView = stringOfProfileImageView
        print(stringOfProfileUid)
        chatLogControllerOne.kind = 3
        
        self.navigationController?.show(chatLogControllerOne, sender: self)
        
    }
    
    // email composer
    func Email(){
        //Check if the device is capable to send email
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let emailTitle = "Untitled"
        let messageBody = "Message: "
        // you can tweak this to send to all members
        let toRecipients = [Semail]
        
        // Initialize the mail composer and populate the mail content
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipients)
        
        /*// determine the file and extension
         let fileparts = attachment.components(separatedBy: ".")
         let filename = fileparts[0]
         let fileExtension = fileparts[1]
         
         // Get the resource path and read the file using NSData
         guard let filePath = Bundle.main.path(forResource: filename, ofType: fileExtension) else {
         return
         }
         
         //Get the file data and MIME type
         if let fileData = try? Data(contentsOf: URL(fileURLWithPath: filePath)), let mimeType = MIMEType(type: fileExtension) {
         
         // Add attachment
         mailComposer.addAttachmentData(fileData, mimeType: mimeType.rawValue, fileName: filename)
         
         // present mail view conroller on screen
         present(mailComposer, animated: true, completion: nil)
         }*/
        // present mail view conroller on screen
        present(mailComposer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail Cancelled")
        case MFMailComposeResult.saved:
            print("Mail Saved")
        case MFMailComposeResult.sent:
            print("Mail Sent")
        case MFMailComposeResult.failed:
            print("Mail Failed to Send: \(error!)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    //end -------------
    
    func TextMessage(){
        // Check to see if the device is capable of sending text message
        guard MFMessageComposeViewController.canSendText() else {
            let alertMessage = UIAlertController(title: "SMS Unavailable", message: "Your device is not capable of sending SMS.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
            return
        }
        
        // prefill the SMS
        let messageController = MFMessageComposeViewController()
        messageController.messageComposeDelegate = self
        messageController.recipients = [Stelephone]
        messageController.body = "just sent this text message to you."
        
        // present message view controller on screen
        present(messageController, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
        switch(result) {
        case MessageComposeResult.cancelled:
            print("SMS Cancelled")
            
        case MessageComposeResult.failed:
            let alertMessage = UIAlertController(title: "Failure", message: "Failed to send the message.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
            
        case MessageComposeResult.sent:
            print("SMS Sent!")
        }
        
        dismiss(animated: true, completion: nil)
    }
    //end-------
    
    
    @IBAction func titheButton(_ sender: Any) {
        
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ChoosePayment") as!
            
        PaymentCollectionViewController
        
        destinationController.title = "Payment Services"
        
        self.navigationController?.show(destinationController, sender: self)
        
        
        
        //if let url = URL(string: paymentLink){
        //  UIApplication.shared.open(url)
        //}
        
        /* this views within the app, not solely in safari ** Apple does not like payments this way.
         print("I am going to pay my tithes!")
         
         if let url = URL(string: paymentLink){
         let safariController = SFSafariViewController(url:url)
         present(safariController, animated: true, completion: nil)
         }
         
         */
    }
    
    @IBAction func eventsButton(_ sender: Any) {
        print("event button pushed!")
        participationData = [Any]()
        
        participationCollectionView.reloadData()
        participationData = attending
        isAttending = true
        isPrayer = false
        isSocial = false
        eventInterestCount.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        interestLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        eventsButtonPad.layer.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        socialPostsPad.layer.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        socialPostsCount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        socialLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        PrayerRequestsPad.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        prayerPostsCount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        prayerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        participationCollectionView.reloadData()
        print(participationData)
    }
    @IBAction func socialButton(_ sender: Any) {
        print("social button pushed!")
        participationData = [Any]()
        participationCollectionView.reloadData()
        participationData = socialCount
        isAttending = false
        isPrayer = false
        isSocial = true
        eventInterestCount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        interestLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        eventsButtonPad.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        socialPostsPad.layer.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        socialPostsCount.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        socialLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        PrayerRequestsPad.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        prayerPostsCount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        prayerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        participationCollectionView.reloadData()
        print(participationData)
    }
    @IBAction func prayerButton(_ sender: Any) {
        print("prayer button pushed!")
        participationData = [Any]()
        participationCollectionView.reloadData()
        participationData = prayerCount
        isAttending = false
        isPrayer = true
        isSocial = false
        eventInterestCount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        interestLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        eventsButtonPad.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        socialPostsPad.layer.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        socialPostsCount.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        socialLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        PrayerRequestsPad.layer.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
        prayerPostsCount.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        prayerLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        participationCollectionView.reloadData()
        print(participationData)
    }
    
    @objc func editInfo() {
        
        let pageViewController = storyboard?.instantiateViewController(withIdentifier: "AddStudentController") as! AddStudentViewController
        
        pageViewController.isProfile = true
        pageViewController.thisParent = thisUser
        
        present(pageViewController, animated: true, completion: nil)
        
        
        /*inputBio.text  = Sbio
         inputTelephone.text = Stelephone
         inputFirstName.text = Sfirstname
         inputLastName.text = Slastname
         inputEmail.text = Semail
         inputUserName.text = ""
         inputBirthday.text = SinputBirthday
         inputGender.text = SinputGender
         inputWorkTelephoneNumber.text = SinputWorkTelephoneNumber
         inputProfession.text = SinputProfession
         inputMaritalStatus.text = SinputMaritalStatus
         inputAnniversaryDate.text = SinputAnniversaryDate
         editingViewTopConstraint.constant = 0
         editButton.isHidden = true
         */
    }
    
    
    
    @objc func informationButton() {
        UserDefaults.standard.set(false, forKey: "hasViewedProfileWalkthrough")
        information()
    }
    
    
    func information(){
        print("Calling Information")
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            pageViewController.viewingProfileWalkthrough = true
            present(pageViewController, animated: true, completion: nil)
            
            
        }
    }
    
    
    
    
    
    
    //end---------------------
    
    @IBAction func deleteAccount(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete this account?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Close", style: .default) { action in
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { action in
            
            // for meetups
            let groupRef = FIRDatabase.database().reference(withPath: "Categories")
            let thisUserGroup = FIRDatabase.database().reference(withPath: "users").child(self.thisUser.key).child("Groups")
            let thisUserMeetup = FIRDatabase.database().reference(withPath: "users").child(self.thisUser.key).child("Meetups")
            
            //list all groups
            thisUserGroup.observe(.value, with: { snapshot in
                //for every group the user is in, append the group ref with the.child(of that group)
                //var thisUserNewGroup: [Group] = []
                for group in snapshot.children{
                    let thisGroup = Group(snapshot: group as! FIRDataSnapshot)
                    //thisUserNewGroup.append(thisGroup)
                    // the group key
                    let groupKey = thisGroup.key
                    let groupCategory = thisGroup.category
                    //list all meetups
                    
                    thisUserMeetup.observe(.value, with: { snapshot in
                        //for every meetup the user is in
                        for meetup in snapshot.children{
                            let thisMeetup = Meetup(snapshot: meetup as! FIRDataSnapshot)
                            // meetup Key
                            let meetupKey = thisMeetup.key
                            print("meetup key: \(meetupKey)")
                            print("stringOfProfileUid: \(self.stringOfProfileUid)")
                            //list main firDataSnapshot of categories for meetups
                            // find / compare if the user is there to delete
                            // delete the user associated with the meetups
                            let meetupsMembersWithMemberRef = groupRef.child("\(groupCategory!.lowercased())").child("Groups").child("\(groupKey)").child("Meetups").child("\(meetupKey)").child("MembersGoing").child(self.stringOfProfileUid)
                            
                            meetupsMembersWithMemberRef.removeValue()
                            
                        }// end of meetup For-loop
                    }) // end of meetup observable
                    
                    // then remove the member from the group
                    print("group key: \(groupKey)")
                    print("group category: \(groupCategory!)")
                    
                    let groupsMembersWithMemberRef = groupRef.child("\(groupCategory!.lowercased())").child("Groups").child("\(groupKey)").child("Members").child(self.stringOfProfileUid)
                    
                    groupsMembersWithMemberRef.removeValue()
                }//end of for loop
                
                // for users
                let usersRef = FIRDatabase.database().reference(withPath: "users").child(self.stringOfProfileUid)
                usersRef.removeValue()
                
                // for user-messages
                let userMessagesRef = FIRDatabase.database().reference(withPath: "user-messages").child(self.stringOfProfileUid)
                userMessagesRef.removeValue()
                
                // for members
                let membersRef = FIRDatabase.database().reference(withPath: "\(self.thisUser.currentLevelStatus!)").child(self.stringOfProfileUid)
                membersRef.removeValue()
                
            })// end of group observable
            
            if self.isAdmin == true{
                //****        fund out how to delete the specified user
                // for social wall
                let socialRef = FIRDatabase.database().reference(withPath: "SocialPosts")
                
                var socialList: [SocialMediaPost] = []
                
                socialRef.queryOrdered(byChild: "timeAndDate").observe(.value, with: {snapshot in
                    print(snapshot)
                    
                    for item in snapshot.children {
                        let socialPostItem = SocialMediaPost(snapshot: item as! FIRDataSnapshot)
                        socialList.insert(socialPostItem, at: 0)
                    }
                    
                    // do deletions
                    for post in socialList{
                        if post.socialUniq == self.stringOfProfileUid{
                            let thisSocialPost = socialRef.child(post.key)
                            thisSocialPost.removeValue()
                        }
                    }
                })
                
                //end
                
                //user?.delete { error in
                //  if error != nil {
                // An error happened.
                //} else {
                // Account deleted.
                //}
                //}
            }else if self.isAdmin == false{
                let user = FIRAuth.auth()?.currentUser
                
                // for social wall
                let socialRef = FIRDatabase.database().reference(withPath: "SocialPosts")
                
                var socialList: [SocialMediaPost] = []
                
                socialRef.queryOrdered(byChild: "timeAndDate").observe(.value, with: {snapshot in
                    print(snapshot)
                    
                    for item in snapshot.children {
                        let socialPostItem = SocialMediaPost(snapshot: item as! FIRDataSnapshot)
                        socialList.insert(socialPostItem, at: 0)
                    }
                    
                    // do deletions
                    for post in socialList{
                        if post.socialUniq == user?.uid{
                            let thisSocialPost = socialRef.child(post.key)
                            thisSocialPost.removeValue()
                        }
                    }
                })
                
                //end
                
                user?.delete { error in
                    if error != nil {
                        // An error happened.
                    } else {
                        // Account deleted.
                    }
                }
            }
            
            // then signs out
            if self.isAdmin == true{
                self.performSegue(withIdentifier: "unwindToAdminControl", sender: self)
            }else {
                do {
                    
                    try FIRAuth.auth()?.signOut()
                    self.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            
        }
        
        // actions of the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        // action to present the alert controller
        present(alert, animated: true, completion: nil)
    }
    
    func thankYou(){
        let alert = UIAlertController(title: "Church", message: "We thank you for being a part of our community, Be Blessed!", preferredStyle: .alert)
        
        let closeAction = UIAlertAction(title: "Close", style: .default) { action in
        }
        
        // actions of the alert controller
        alert.addAction(closeAction)
        
        // action to present the alert controller
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func indexChanged(_ sender: Any) {
        // tell the view to relaod then laod the new tableView data & populate the tableView.
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            displayingData = []
            displayingData = prayers
            if prayers.isEmpty{
                emptyCollectionImage.isHidden = false
                othersCollectionView.isHidden = true
                othersCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
            }else{
                emptyCollectionImage.isHidden = true
                othersCollectionView.isHidden = false
                
                self.view.reloadInputViews()
                self.othersCollectionView.reloadData()
                print(displayingData)
            }
        case 1:
            displayingData = []
            displayingData = socialLikes
            if socialLikes.isEmpty{
                emptyCollectionImage.isHidden = false
                othersCollectionView.isHidden = true
                othersCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
            }else{
                emptyCollectionImage.isHidden = true
                othersCollectionView.isHidden = false
                self.view.reloadInputViews()
                self.othersCollectionView.reloadData()
                print(displayingData)
            }
        case 2:
            displayingData = []
            displayingData = pastorialLikes
            if pastorialLikes.isEmpty{
                emptyCollectionImage.isHidden = false
                othersCollectionView.isHidden = true
                othersCollectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
            }else{
                emptyCollectionImage.isHidden = true
                othersCollectionView.isHidden = false
                self.view.reloadInputViews()
                self.othersCollectionView.reloadData()
                print(displayingData)
            }
        default:
            break
        }
    }
    
    let date = Date()
    let monthFormatter = DateFormatter()
    // for day
    let dayFormatter = DateFormatter()
    //for the full date
    let dateFormatter  = DateFormatter()
    
    @IBAction func reportPost(_ sender: Any) {
        reportViewTopConstraint.constant = 20
        reportItem.text = "\(Susername)'s Profile"
        darkBackground.isHidden = false
        profileScrollView.scrollToTop()
    }
    
    @IBAction func sendReportButton(_ sender: Any) {
        // append data to firebase
        
        let complaintRef = FIRDatabase.database().reference().child("Complaints")
        
        //for time format
        monthFormatter.dateFormat = "MM dd, yyyy"
        dayFormatter.dateFormat = "dd"
        dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
        
        
        
        if isAdmin == true{
            // data to send
            let complaintData = Complaint(complaintType: "Profile", complaintTitle: "\(Susername)'s Profile", complaintMessage: self.reportText.text, reporterName: stringOfProfileName, reporterUID: stringOfProfileUid, issueCreatorName:Susername, issueCreatorUID: stringOfProfileUid, complaintDate: self.dateFormatter.string(from: Date()), isResolved: "false", complaintNotes: "" )
            
            let complaintItemRef = complaintRef.child("Profile").childByAutoId()
            complaintItemRef.setValue(complaintData.toAnyObject())
            
            
            reportViewTopConstraint.constant = 2000
            darkBackground.isHidden = true
            reportText.text = "Place your issues here..."
            
            
            //2 is the current user
        }else if isViewingPage == false && isAdmin == false{
            
            
            //3 is another user
        }else{
            
            // data to send
            let complaintData = Complaint(complaintType: "Profile", complaintTitle: "\(Susername)'s Profile", complaintMessage: self.reportText.text, reporterName: self.reporterStringOfProfileName, reporterUID: self.reporterStringOfProfileUid, issueCreatorName:Susername, issueCreatorUID: stringOfProfileUid , complaintDate: self.dateFormatter.string(from: Date()), isResolved: "false", complaintNotes: "" )
            
            let complaintItemRef = complaintRef.child("Profile").childByAutoId()
            complaintItemRef.setValue(complaintData.toAnyObject())
            
            
            reportViewTopConstraint.constant = 2000
            darkBackground.isHidden = true
            reportText.text = "Place your issues here..."
            
        }
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        reportViewTopConstraint.constant = 2000
        darkBackground.isHidden = true
    }
    
    
    
    
    
    
    // for adjusting text field distance from bottom
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat = -100
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
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:false)
    }
    
    
    
    
    // for making admin
    @IBAction func adminSelected(adminSwitch: UISwitch){
        
        //if currentUsers[adminSwitch.tag].role == "admin" {
        if adminSwitch.isOn{
            
            adminSwitch.setOn(false, animated: true)
            print(stringOfProfileUid)
            
            let adminToRemove = AdministratorRef.child(stringOfProfileUid)
            adminToRemove.removeValue()
            
            let postUpdate = ["role": "regular"]
            
            let userAdminRemove = usersRef.child(stringOfProfileUid).child("thisUserInfo")
            userAdminRemove.updateChildValues(postUpdate)
            
            let memberAdminRemove = membersRef.child(stringOfProfileUid)
            memberAdminRemove.updateChildValues(postUpdate)
            
            print("this user is now a regular person")
            
            
        }else{
            
            //if associateSwitch.isOn{
            //  associateControlSwitch.setOn(false, animated: true)
            //}
            adminSwitch.setOn(true, animated: true)
            print("this user is now an admin")
            
            let post = ["\(stringOfProfileUid)": "\(stringOfProfileUid)" ]
            AdministratorRef.updateChildValues(post)
            
            let postUpdate = ["role": "admin"]
            
            
            let userAdminAdd = usersRef.child(stringOfProfileUid).child("thisUserInfo")
            userAdminAdd.updateChildValues(postUpdate)
            
            let memberAdminAdd = membersRef.child(stringOfProfileUid)
            memberAdminAdd.updateChildValues(postUpdate)
            
            print("\(stringOfProfileName)' is now an administrator... yay!")
            
        }
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
extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
}
