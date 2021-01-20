//
//  AddSocialViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 1/28/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class AddSocialViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {
    
    @IBOutlet weak var socialImage: UIImageView!
    
    @IBOutlet weak var socialTitle: UITextField!
    
    @IBOutlet weak var socialDetails: UITextView!
    
    @IBOutlet weak var postButton: UIButton!
    
    @IBOutlet weak var imageFilter: UIImageView!
    
    @IBOutlet weak var eventUploadImageIcon: UIImageView!
    
    @IBOutlet weak var cancelButton: UIButton!

    
  var data = MinistryData()
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfUid = ""
    var user: ChurchUser!
    var socialPostDetails: SocialMediaPost!
    var isEditingSocialPost = false
    var socialPostKey = ""
    
    let ref = FIRDatabase.database().reference(withPath: "SocialPosts")
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    let imagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self

        if isEditingSocialPost == true{
            socialTitle.text = socialPostDetails.userPostTitle
            socialDetails.text = socialPostDetails.socialDetails
            let socialImageText = socialPostDetails.userUploadImage!
            socialImage.loadImageUsingCacheWithURLString(urlString: socialImageText)
            imageFilter.isHidden = true
            eventUploadImageIcon.isHidden = true
            
        }else{
            
        }
        
        
        postButton.churchAppButtonRegular()
        cancelButton.churchAppButtonRegular()
        
        // Do any additional setup after loading the view.
        fetchUserAndSetupNavBarTitle()
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
    
    
    
    @objc func handleLogout(){
        
    }
    
    
    var tappedTextBoxCounts = 0
    @IBAction func tappedTextBox(_ sender: Any) {
        tappedTextBoxCounts = tappedTextBoxCounts + 1
        if tappedTextBoxCounts <= 1 {
            socialDetails.text = ""
        }
        else {
            
        }
    }
 
    
    // for selecting a user image
    @IBAction func userimageTapped(_ sender: Any) {
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
            alert.popoverPresentationController?.sourceView = sender as? UIView
            alert.popoverPresentationController?.sourceRect = (sender as AnyObject).bounds
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
    
    func openGallary(){
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("Cancelled picker")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            
            selectedImageFromPicker = (editedImage as! UIImage)
            imageFilter.isHidden = true
            eventUploadImageIcon.isHidden = true
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = (originalImage as! UIImage)
            
        }
        if let selectedImage = selectedImageFromPicker{
            socialImage.image = selectedImage
            socialImage.contentMode = .scaleAspectFill
            socialImage.clipsToBounds = true
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    

    // time formats
    // for month
    let date = Date()
    let monthFormatter = DateFormatter()
    // for day
    let dayFormatter = DateFormatter()
    //for the full date
    let dateFormatter  = DateFormatter()
    @IBAction func postButton(_ sender: Any) {
        
        if isEditingSocialPost == true {
            if socialTitle.text == "" || socialDetails.text == ""  {
                let alert = UIAlertController(title: "Empty Fields", message: "Please add needed text", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }else{
                //for time format
                monthFormatter.dateFormat = "MM dd, yyyy"
                dayFormatter.dateFormat = "dd"
                dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
                //dateFormatter.dateStyle = .short
                //dateFormatter.timeStyle = .short
                
                
                //var postDate = "\(monthFormatter.string(from: date)) \(dayFormatter.string(from: date) \()) "
                
                print("has passed checkpoint 1")
                let imageName = NSUUID().uuidString
                
                let storageRef = FIRStorage.storage().reference().child("Social").child("\(imageName).jpg")
                
                
                //if let uploadData = UIImagePNGRepresentation(self.socialImage.image!){
                if let thisSocialImage = self.socialImage.image, let uploadData = UIImageJPEGRepresentation(thisSocialImage, 0.1){
                    
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        guard let metadata = metadata else{
                            
                            print(error!)
                            return
                        }
                        
                        let downloadURL = metadata.downloadURL()
                        print(downloadURL!)
                        
                        
                        //socialtitle
                        guard let titleField = self.socialTitle,
                            let sTitle = titleField.text else { return }
                        
                        //socialDetails
                        guard let detailField = self.socialDetails,
                            let sDetail = detailField.text else { return }
                        
                        // userImage
                        
                        // for main database: mkake these update styles rather than setting valules.
                        
                        let socialItem = SocialMediaPost(socialMediaIcon: self.socialPostDetails.socialMediaIcon!, byUserName: self.socialPostDetails.byUserName, timeAndDate: self.socialPostDetails.timeAndDate, userUploadImage: "\(downloadURL!)",userPostLikes: self.socialPostDetails.userPostLikes, userIcon: "String", userPostTitle: sTitle, socialDetails: sDetail, socialUniq: self.socialPostDetails.socialUniq)
                        
                        //self.blogs.insert(blogItem, at: 0)
                        let socialItemRef = self.ref.child(self.socialPostDetails.key)
                        socialItemRef.setValue(socialItem.toAnyObject())
                        
                        
                        // for user created array
                        
                        let socialCreatedItemRef = self.usersRef.child(self.stringOfUid).child("MyParticipation").child("Social")
                        
                        //self.blogs.insert(blogItem, at: 0)
                        let nextSocialCreatedItemRef = socialCreatedItemRef.child(self.socialPostDetails.key)
                        nextSocialCreatedItemRef.setValue(socialItem.toAnyObject())
                        
                        //end-----------
                        
                    })
                }
                print("has passed checkpoint 3")
                print("image: \(self.socialImage!)", "title: \(self.socialTitle.text!)",  "details: \(self.socialDetails.text!)")
                
                print("successfully stored event into Firebase DB")
                
                
                //tableView.reloadData()
                
                self.view.endEditing(true)
                
                performSegue(withIdentifier: "unwindToSocialListBasic", sender: self)

            }
            
        }else {
            if socialTitle.text == "" || socialDetails.text == ""  {
                let alert = UIAlertController(title: "Empty Fields", message: "Please add needed text", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                
            } else {
                
                //for time format
                monthFormatter.dateFormat = "MM dd, yyyy"
                dayFormatter.dateFormat = "dd"
                dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
                //dateFormatter.dateStyle = .short
                //dateFormatter.timeStyle = .short
                
                
                //var postDate = "\(monthFormatter.string(from: date)) \(dayFormatter.string(from: date) \()) "
                
                print("has passed checkpoint 1")
                let imageName = NSUUID().uuidString
                
                let storageRef = FIRStorage.storage().reference().child("Social").child("\(imageName).jpg")
                
                
                //if let uploadData = UIImagePNGRepresentation(self.socialImage.image!){
                if let thisSocialImage = self.socialImage.image, let uploadData = UIImageJPEGRepresentation(thisSocialImage, 0.1){
                    
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        guard let metadata = metadata else{
                            
                            print(error!)
                            return
                        }
                        
                        let downloadURL = metadata.downloadURL()
                        print(downloadURL!)
                        
                        
                        //socialtitle
                        guard let titleField = self.socialTitle,
                            let sTitle = titleField.text else { return }
                        
                        //socialDetails
                        guard let detailField = self.socialDetails,
                            let sDetail = detailField.text else { return }
                        
                        // userImage
                        
                        // for main database
                        let socialItem = SocialMediaPost(socialMediaIcon: self.stringOfProfileImageView, byUserName: self.stringOfProfileName, timeAndDate: self.dateFormatter.string(from: Date()), userUploadImage: "\(downloadURL!)",userPostLikes: 0, userIcon: "String", userPostTitle: sTitle, socialDetails: sDetail, socialUniq: self.stringOfUid)
                        
                        //self.blogs.insert(blogItem, at: 0)
                        let socialItemRef = self.ref.childByAutoId()
                        socialItemRef.setValue(socialItem.toAnyObject())
                        
                        
                        // for user created array
                        
                        let socialCreatedItemRef = self.usersRef.child(self.stringOfUid).child("MyParticipation").child("Social")
                        
                        //self.blogs.insert(blogItem, at: 0)
                        let nextSocialCreatedItemRef = socialCreatedItemRef.child(sTitle.lowercased())
                        nextSocialCreatedItemRef.setValue(socialItem.toAnyObject())
                        
                        //end-----------
                        
                    })
                }
                print("has passed checkpoint 3")
                print("image: \(self.socialImage!)", "title: \(self.socialTitle.text!)",  "details: \(self.socialDetails.text!)")
                
                print("successfully stored event into Firebase DB")
                
                
                //tableView.reloadData()
                
                self.view.endEditing(true)
                
                performSegue(withIdentifier: "unwindToSocialListBasic", sender: self)
            }
        }
    }
    
    
    @IBAction func cancelButton(_ sender: Any) {
        if isEditingSocialPost == true {
            performSegue(withIdentifier: "unwindToSocialDetail", sender: self)
        }else {
            socialTitle.placeholder = "Title..."
            socialDetails.text = "Post message here..."
            self.view.endEditing(true)
            performSegue(withIdentifier: "unwindToSocialListBasic", sender: self)
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
