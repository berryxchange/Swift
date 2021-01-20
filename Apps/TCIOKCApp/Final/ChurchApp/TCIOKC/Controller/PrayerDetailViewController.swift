//
//  PrayerDetailViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class PrayerDetailViewController: UIViewController {

    @IBOutlet weak var prayerTitle: UILabel!
    
    @IBOutlet weak var prayerMessage: UILabel!
    
    @IBOutlet weak var prayerAgreementButton: UIButton!
    
    @IBOutlet weak var prayerAgreementNumber: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    var didAgree = false
    var agreements = 0
    
    var pTitle = ""
    var pMessage = ""
    var prayerDatabase: Prayer!
    var prayerPersonName = ""
    var postDateMonth = ""
    var postDateDay = ""
    var postFullDate = ""
    var byUser = ""
    var prayers : [Prayer] = []
    var prayerKey = ""
    
    // for firebase
    
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfProfileUid = ""
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    
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
    
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(" this is the prayer key: \(prayerKey)")
        
        let ref = FIRDatabase.database().reference().child("prayer-items").child(prayerKey)
        
        
        let newRef = FIRDatabase.database().reference().child("prayer-items").child(prayerKey).child("prayerPostAgreements")
        
        // Do any additional setup after loading the view.
        // this listens for changes in the values of the database (added, removed, changed)
        //1 - reviews data
        // queryOrdered(byChild:) allows to arrange children in list by "style"
        
        newRef.observe(.value, with: {snapshot in
            
            print("This is the snapshot: \(snapshot)")
            //2 new items are an empty array
            
            var newAgreements = 0
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            //}
            
            // 5 - the main "events" are now the adjusted "newEvents"
            //self.events = newEvents
            
            //self.variousItems = newSocialPosts
            //print("the new various Items: \(self.variousItems)")
            
            newAgreements = snapshot.value as! Int
            self.agreements = newAgreements
            self.prayerAgreementNumber.text = "\(self.agreements)"
            print("Your new agreements: \(newAgreements)")
            
            self.view.reloadInputViews()
        })
        
        
        if UserDefaults.standard.bool(forKey: "\(ref)didAgree") {
            prayerAgreementButton.isSelected = true
            
            let originalButtonImage = UIImage(named: "Prayer hands")
            
            let tintedButtonImage = originalButtonImage?.withRenderingMode(.alwaysTemplate)
            
            prayerAgreementButton.setImage(tintedButtonImage, for: .normal)
            
            prayerAgreementButton.tintColor = #colorLiteral(red: 0.3395062974, green: 0.874027315, blue: 0.9768045545, alpha: 1)
        }else {
            prayerAgreementButton.isSelected = false
            
            let originalButtonImage = UIImage(named: "Prayer hands")
            
            let tintedButtonImage = originalButtonImage?.withRenderingMode(.alwaysTemplate)
            
            prayerAgreementButton.setImage(tintedButtonImage, for: .normal)
            
            prayerAgreementButton.tintColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
        }
        
        prayerAgreementNumber.text = "\(prayerDatabase.prayerPostAgreements)"
        
        prayerTitle.text = prayerDatabase.prayerPostTitle
        
        prayerMessage.text = prayerDatabase.prayerPostMessage
        
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
        
        fetchUserAndSetupNavBarTitle()
    }
    
    //end-------------
    
    
    
    
    
    // reloading the view with constraints and new size based on the eventDetail height
    override func viewDidAppear(_ animated: Bool) {
       
    contentView.frame.size = CGSize( width:375 , height:400 + prayerMessage.frame.size.height )
        
        contentView.heightAnchor.constraint(equalToConstant: 500 + prayerMessage.frame.size.height ).isActive = true
        
        print(contentView.frame.size.height)
        
        print("constraint size: \(contentView.heightAnchor.constraint(equalToConstant: 500 + prayerMessage.frame.size.height ))")
        
        self.reloadInputViews()
        
    }
    //end-------------
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       let newRef = FIRDatabase.database().reference().child("prayer-items").child(prayerKey).child("prayerPostAgreements")
        newRef.removeAllObservers()
        print("listeners removed!")
        
    }

    
    //Actions
    @IBAction func prayerAgreementButton(_ sender: Any) {
        
        if prayerAgreementButton.isSelected == false {
            
            let originalButtonImage = UIImage(named: "Prayer hands")
            
            let tintedButtonImage = originalButtonImage?.withRenderingMode(.alwaysTemplate)
            
            prayerAgreementButton.setImage(tintedButtonImage, for: .normal)
            
            prayerAgreementButton.tintColor = #colorLiteral(red: 0.3395062974, green: 0.874027315, blue: 0.9768045545, alpha: 1)
            
            self.prayerAgreementButton.isSelected = true
            
            let ref = FIRDatabase.database().reference().child("prayer-items").child(prayerKey)
            
            //self.agreements = agreements + 1
            
            prayerAgreementNumber.text = "\(agreements)"
            
            let updateAgreements = ["prayerPostAgreements": agreements + 1]
            ref.updateChildValues(updateAgreements)
            
            
            UserDefaults.standard.set(true, forKey: "\(ref)didAgree")
            
            print(UserDefaults.standard.bool(forKey: "\(ref)didAgree"))
            
            self.view.reloadInputViews()
            
            
            
            //for FirebaseUser
            let thisPostItem = Prayer(prayerPostTitle: self.pTitle, prayerPostMessage: self.pMessage,
                prayerPostPersonName: prayerPersonName,
                prayerPostDateMonth: postDateMonth,
                prayerPostDateDay: postDateDay,
                prayerFullDate : postFullDate,
                prayerPostAgreements: agreements,
                byUserName: byUser
            )
            
            //self.blogs.insert(blogItem, at: 0)
            //let thisItemRef = ref
            
            //thisItemRef.setValue(thisPostItem.toAnyObject())
            
            //this goes to user set of data not database.
            let nextItemRef = self.usersRef.child(self.stringOfProfileUid).child("PrayerAgreements").child(prayerKey)
            nextItemRef.setValue(thisPostItem.toAnyObject())
       
    print("successfully stored event into Firebase DB")
    
    self.view.endEditing(true)
    
            //end-------------
            
        } else {
            let originalButtonImage = UIImage(named: "Prayer hands")
            
            let tintedButtonImage = originalButtonImage?.withRenderingMode(.alwaysTemplate)
            
            prayerAgreementButton.setImage(tintedButtonImage, for: .normal)
            
            prayerAgreementButton.tintColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
            
            self.prayerAgreementButton.isSelected = false
            
            //self.agreements = agreements - 1
            
            prayerAgreementNumber.text = "\(agreements)"
            
            let ref = FIRDatabase.database().reference().child("prayer-items").child(prayerKey)
            
            let updateAgreements = ["prayerPostAgreements": agreements - 1]
            ref.updateChildValues(updateAgreements)
            
            didAgree = false
            
            UserDefaults.standard.set(false, forKey: "\(ref)didAgree")
            
            print(UserDefaults.standard.bool(forKey: "\(ref)didAgree"))
            
            
            //for FirebaseUser
            let nextItemRef = self.usersRef.child(self.stringOfProfileUid).child("PrayerAgreements").child(prayerKey)
            nextItemRef.removeValue()
            
            self.view.reloadInputViews()
        }
    }
    
    //end-------------
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
