//
//  ReportsDetailViewController.swift
//  ChurchAppOne
//
//  Created by Quinton Quaye on 11/9/18.
//  Copyright © 2018 Transformation Church International. All rights reserved.
//

import UIKit
import MessageUI
import FirebaseAuth
import FirebaseDatabase

class ReportsDetailViewController: UIViewController {

    
    var complaint: Complaint!
    
    // complaint type
    @IBOutlet weak var complaintType: UILabel!
    
    // plaintiff
    @IBOutlet weak var plaintiffImage: UIImageView!
    @IBOutlet weak var plaintiffFirstName: UILabel!
    @IBOutlet weak var plaintiffLastName: UILabel!
    @IBOutlet weak var plaintiffUsername: UILabel!
    @IBOutlet weak var plaintiffText: UILabel!
    
    // defendant
    @IBOutlet weak var defendantImage: UIImageView!
    @IBOutlet weak var defendantFirstName: UILabel!
    @IBOutlet weak var defendantLastName: UILabel!
    @IBOutlet weak var defendantUsername: UILabel!
    
    
    // buttons
    @IBOutlet weak var messagePlaintiff: UIButton!
    @IBOutlet weak var messageDefendant: UIButton!
    
    @IBOutlet weak var makeNoteButton: UIButton!
    @IBOutlet weak var markAsRead: UIButton!
    @IBOutlet weak var complaintPad: UIView!
    
    var creators : [Member] = []
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfUid = ""
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        // for every app member
        
        complaintPad.layer.shadowOpacity = 0.5
        complaintPad.layer.shadowOffset = CGSize.zero
        complaintPad.layer.shadowRadius = 5.0
        complaintPad.layer.cornerRadius = 4
        
        
        messagePlaintiff.layer.cornerRadius = 20
        messagePlaintiff.layer.borderWidth = 2
        messagePlaintiff.layer.borderColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        
        messageDefendant.layer.cornerRadius = 20
        messageDefendant.layer.borderWidth = 2
        messageDefendant.layer.borderColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        
        makeNoteButton.layer.cornerRadius = 20
        makeNoteButton.layer.borderWidth = 2
        makeNoteButton.layer.borderColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        
        markAsRead.layer.cornerRadius = 20
        markAsRead.layer.borderWidth = 2
        markAsRead.layer.borderColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        
        plaintiffImage.layer.shadowOpacity = 0.5
        plaintiffImage.layer.shadowOffset = CGSize.zero
        plaintiffImage.layer.shadowRadius = 50
        plaintiffImage.layer.cornerRadius = 50
        plaintiffImage.layer.masksToBounds = true
        
        defendantImage.layer.shadowOpacity = 0.5
        defendantImage.layer.shadowOffset = CGSize.zero
        defendantImage.layer.shadowRadius = 50
        defendantImage.layer.cornerRadius = 50
        defendantImage.layer.masksToBounds = true
        
        
       
        FIRDatabase.database().reference().child("members").observe(.value, with: {(snapshot) in
            
            var thisMember: [Member] = []
            for item in snapshot.children{
                print(item)
                let memberItem = Member(snapshot: item as! FIRDataSnapshot)
                thisMember.append(memberItem)
            }
                self.creators = thisMember
            
        }, withCancel: nil)
        fetchUserAndSetupNavBarTitle()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if complaint.isResolved == "true"{
            markAsRead.setTitle("Not Yet Resolved", for: .normal)
        }else{
            markAsRead.setTitle("Mark As Resolved", for: .normal)
        }
        
        complaintType.text = "\(complaint.complaintType!) Complaint"
        for creator in creators{
            if complaint.reporterUID == creator.key{
                plaintiffImage.loadImageUsingCacheWithURLString(urlString: creator.userImageUrl!)
                plaintiffFirstName.text = creator.firstname!
                plaintiffLastName.text = creator.lastname
                plaintiffUsername.text = creator.username
                plaintiffText.text = complaint.complaintMessage
            }
            if complaint.issueCreatorUID == creator.key{
                defendantImage.loadImageUsingCacheWithURLString(urlString: creator.userImageUrl!)
                defendantFirstName.text = creator.firstname!
                defendantLastName.text = creator.lastname
                defendantUsername.text = creator.username
            }
        }
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
       
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //sending Message
    @IBAction func messagePlaintiff(_ sender: Any) {
        print("I am going to send a mesaage!")
        
        let alert = UIAlertController(title: "How do you want to send your message", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "App Message", style: .default, handler: { _ in
            // function here
            self.internalMessage(messageUser: self.complaint.reporterUID!)
        }))
        /*if Semail == ""{
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
         */
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
    
    @IBAction func messageDefendant(_ sender: Any) {
        print("I am going to send a mesaage!")
        
        let alert = UIAlertController(title: "How do you want to send your message", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "App Message", style: .default, handler: { _ in
            // function here
            self.internalMessage(messageUser: self.complaint.issueCreatorUID!)
        }))
        /*if Semail == ""{
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
         */
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
    
    
    @IBAction func makeANote(_ sender: Any) {
        
        let destinationController = storyboard?.instantiateViewController(withIdentifier: "CompaintNoteController") as!
        ComplaintNotesViewController
        
        destinationController.complaint = complaint
        destinationController.note = complaint.complaintNotes!
        
        
        present(destinationController, animated: true, completion: nil)
        
    }
    
    
    
    func internalMessage(messageUser: String){
        
        let chatLogControllerOne = ChatLogControllerOne(collectionViewLayout: UICollectionViewFlowLayout())
        
        
        for creator in creators{
            if messageUser == creator.key{
                chatLogControllerOne.stringOfProfileUid = creator.key
                chatLogControllerOne.stringOfProfileName = creator.username!
                chatLogControllerOne.stringOfProfileImageView = creator.userImageUrl!
                print(creator.key)
                chatLogControllerOne.kind = 3
            }
        }
        
        show(chatLogControllerOne, sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //let newRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)")
        //newRef.removeAllObservers()
        //print("listeners removed!")
        
    }

    @IBAction func visitIssue(_ sender: Any) {
        // if Social
        if complaint.complaintType == "Social"{
            
            print("viewing data...")
        }
        
        // if group
        if complaint.complaintType == "Group"{
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePage") as! userProfileViewController
            
            for creator in creators{
                if complaint.issueCreatorUID == creator.key{
                    
                    destinationController.isViewingPage = true
                    destinationController.stringOfProfileImageView = creator.username!
                    destinationController.stringOfProfileName = "\(creator.firstname!) \(creator.lastname!)"
                    destinationController.stringOfProfileUid = creator.key
                }
            }
            self.navigationController?.pushViewController(destinationController, animated: true)
        }
        
        // if profile
        if complaint.complaintType == "Profile"{
            let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ProfilePage") as! userProfileViewController
            
            for creator in creators{
                if complaint.issueCreatorUID == creator.key{
                    
                    destinationController.isViewingPage = true
                    destinationController.stringOfProfileImageView = creator.username!
                    destinationController.stringOfProfileName = "\(creator.firstname!) \(creator.lastname!)"
                    destinationController.stringOfProfileUid = creator.key
                }
            }
            self.navigationController?.pushViewController(destinationController, animated: true)
        }
    }
    
    
    func checkReadOrNot(){
        
        if complaint.isResolved == "true"{
            performSegue(withIdentifier: "unwindToReportsViewController", sender: self)
            let complaintItemRef = FIRDatabase.database().reference().child("Complaints").child("\(complaint.complaintType!)").child(complaint.key)
            
            let newData = ["isResolved" : "false"]
            complaintItemRef.updateChildValues(newData)
            
            print("this \(complaint.complaintType!) complaint is still unfinished.")
            
        }else{
            
            performSegue(withIdentifier: "unwindToReportsViewController", sender: self)
            let complaintItemRef = FIRDatabase.database().reference().child("Complaints").child("\(complaint.complaintType!)").child(complaint.key)
            
            let newData = ["isResolved" : "true"]
            
            complaintItemRef.updateChildValues(newData)
            
            print("Marked this \(complaint.complaintType!) complaint as Resolved.")
        }
    }
    
    @IBAction func markAsRead(_ sender: Any) {
        
        
        // if Social
        if complaint.complaintType == "Social"{
            checkReadOrNot()
        }
        
        // if group
        if complaint.complaintType == "Group"{
          checkReadOrNot()
        }
        
        // if profile
        if complaint.complaintType == "Profile"{
          checkReadOrNot()
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
