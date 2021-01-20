//
//  AddPrayerViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 2/28/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class AddPrayerViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var prayerTitleTextField: UITextField!
    @IBOutlet weak var prayerMessageTextField: UITextView!
    
    @IBOutlet weak var postPrayerButton: UIButton!
    @IBOutlet weak var cancelPrayerButton: UIButton!
    
    
    let ref = FIRDatabase.database().reference(withPath: "prayer-items")
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    var user: ChurchUser!
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfUid = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.prayerTitleTextField.delegate = self
        prayerTitleTextField.placeholder = "Title..."
        
        
        postPrayerButton.churchAppButtonRegular()
        
        cancelPrayerButton.churchAppButtonRegular()
        
        // for the dismissal of keyboard//
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        fetchUserAndSetupNavBarTitle()
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
                self.setupPrayerPostWithUser(user: user)
            }
            
        }, withCancel: nil)
    }
    
    
    
    
    func setupPrayerPostWithUser(user: User){
        
        print("this is the current user: \(user.username)")
        
        if let profileImageUrl = user.userImageUrl {
            stringOfProfileImageView = profileImageUrl
        }
        
        print(stringOfProfileImageView)
        
        stringOfProfileName = user.username
        stringOfUid = (FIRAuth.auth()?.currentUser?.uid)!
        
    }
    
    
    // time formats
    // for month
    let date = Date()
    let monthFormatter = DateFormatter()
    // for day
    let dayFormatter = DateFormatter()
    //for the full date
    let dateFormatter  = DateFormatter()
    
    @IBAction func addPrayerButton(_ sender: Any) {
        
        if prayerTitleTextField.text == ""  {
            let alert = UIAlertController(title: "No Title", message: "Please add a title", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        } else {
            //for time format
            monthFormatter.dateFormat = "MMM"
            dayFormatter.dateFormat = "dd"
            dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
            //dateFormatter.dateStyle = .full
            //dateFormatter.timeStyle = .medium
            
            //blog title
            guard let titleField = prayerTitleTextField,
                let textTitle = titleField.text else { return }
            //blog message
            guard let messageField = prayerMessageTextField,
                let textMessage = messageField.text else { return }
            //blog formatted items needed for the array
            let prayerItem = Prayer(prayerPostTitle: textTitle,
                                    prayerPostMessage: textMessage,
                                    prayerPostPersonName:"",
                                    prayerPostDateMonth: monthFormatter.string(from: date),
                                    prayerPostDateDay: dayFormatter.string(from: date),
                                    prayerFullDate: dateFormatter.string(from: date),
                                    prayerPostAgreements: 0,
                                    byUserName: self.stringOfProfileName)
            
            //self.blogs.insert(blogItem, at: 0)
                self.tableView.reloadData()
                self.view.reloadInputViews()
            tappedTextBoxCounts = 0
            
            let prayerItemRef = self.ref.child(textTitle.lowercased())
            prayerItemRef.setValue(prayerItem.toAnyObject())
            self.tableView.reloadData()
            
            
            prayerTitleTextField.text = ""
            prayerTitleTextField.placeholder = "Title..."
            prayerMessageTextField.text = "Type here..."
            
            // for user created array
            
            let prayerCreatedItemRef = self.usersRef.child(self.stringOfUid).child("MyParticipation").child("Prayers")
            
            //self.blogs.insert(blogItem, at: 0)
            let nextPrayerCreatedItemRef = prayerCreatedItemRef.child(textTitle.lowercased())
            nextPrayerCreatedItemRef.setValue(prayerItem.toAnyObject())
            
            //end-----------
            
            
            performSegue(withIdentifier: "unwindToPrayerList", sender: self)
        }
    }
    
    
    
    var tappedTextBoxCounts = 0
    @IBAction func tappedTextBox(_ sender: Any) {
        tappedTextBoxCounts = tappedTextBoxCounts + 1
        if tappedTextBoxCounts <= 1 {
            prayerMessageTextField.text = ""
        }
        else {
            
        }
    }
    
    
    
    
    @IBAction func cancelprayerButton(_ sender: Any) {
        prayerTitleTextField.placeholder = "Title..."
        prayerMessageTextField.text = "Type here..."
        self.view.reloadInputViews()
        performSegue(withIdentifier: "unwindToPrayerList", sender: self)
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
