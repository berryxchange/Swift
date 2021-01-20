//
//  NewGroupViewController.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/16/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class NewGroupViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var userImageBackground: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var groupDescription: UITextView!
    @IBOutlet weak var groupLocation: UITextField!
    
    @IBOutlet weak var currentUserImage: UIImageView!
    @IBOutlet weak var userImageIcon: UIImageView!
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var groupImage: UIImageView!
    @IBOutlet weak var addPhotoIcon: UIImageView!
    
    @IBOutlet weak var categoryNameLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryButton: UIButton!
    
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfUid = ""
    
    // for member
    var username = ""
    var userImageUrl = ""
    var id = ""
    var firstname = ""
    var lastname = ""
    var email = ""
    var telephone = ""
    var bio = ""
    var role = ""
    var birthday = ""
    var anniversary = ""
    var profession = ""
    var address = ""
    var gender = ""
    var status = ""
    var work = ""
    var currentLevelStatus = ""
    var allergies = ""
    var hobbies = ""
    var parentName = ""
    var parentUserName = ""
    var parentUid = ""
    var parentImage = ""
    var parentEmail = ""
    var parentTelephone = ""
    var parentWorkTelephone = ""
    var studentSelected = false
    //end
    var group: Group!
    
    
    var imagePicker = UIImagePickerController()
    var isEditingGroup = false
    var administrator = ""
    
    @IBAction func unwindToAddGroup(segue: UIStoryboardSegue){
        let destinationReceiver = segue.source as? CategoriesViewController
        let categoryItem = destinationReceiver?.thisCategory
        self.categoryNameLabel.text = categoryItem
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        if isEditingGroup == false{
            cancelButton.isHidden = true
            cancelButton.isEnabled = false
            deleteButton.isHidden = true
            deleteButton.isEnabled = false
            
        }else {
            cancelButton.isHidden = false
            cancelButton.isEnabled = true
            deleteButton.isHidden = true
            deleteButton.isEnabled = false
            categoryButton.isEnabled = false
            categoryIcon.isHidden = true
            groupImage.loadImageUsingCacheWithURLString(urlString: group.groupImage!)
            groupImage.contentMode = .scaleAspectFill
            groupImage.clipsToBounds = true
            addPhotoIcon.isHidden = true
            
            groupName.text = group.groupName
            groupLocation.text = group.groupLocation
            groupDescription.text = group.groupDescription
            categoryNameLabel.text = group.category
            
        }
        
        
        
        self.hideKeyboardWhenTappedAround()
        userImageBackground.layer.cornerRadius = 37.5
        userImage.layer.cornerRadius = 32.5
        userImage.layer.masksToBounds = true
        finishButton.churchAppButtonRegular()
        cancelButton.churchAppButtonRegular()
        
        userImageIcon.tintColor = #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)
        groupDescription.delegate = self
        groupName.delegate = self
        imagePicker.delegate = self
        
        groupDescription.layer.borderWidth = 0.5
        groupDescription.layer.borderColor = #colorLiteral(red: 0.5530076101, green: 0.5530076101, blue: 0.5530076101, alpha: 1)
        groupDescription.layer.cornerRadius = 4
        
        fetchUserAndSetupNavBarTitle()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    
    @IBAction func finishButton(_ sender: Any) {
        if isEditingGroup == true{
             let ref = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups")
            // for the editing data
            if groupName.text == "" || groupDescription.text == ""{
                let alert = UIAlertController(title: "Error", message: "Please fill in the blanks", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            } else {
                
                print("has passed checkpoint 1")
                let imageName = NSUUID().uuidString
                //create a storage reference from our storage service
                let storageRef = FIRStorage.storage().reference().child("Groups").child(self.groupName.text!).child("\(imageName).jpg")
                
                
                if let thisGroupImage = self.groupImage.image, let uploadData = UIImageJPEGRepresentation(thisGroupImage, 0.1){
                    //if let uploadData = UIImagePNGRepresentation(self.eventImage.image!){
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        guard let metadata = metadata else{
                            
                            print(error!)
                            return
                        }
                        
                        let downloadURL = metadata.downloadURL()
                        print(downloadURL!)
                        
                        //blog formatted items needed for the array
                        let groupItem = ["groupName": self.groupName.text!, "groupLocation": self.groupLocation.text!, "groupImage": "\(downloadURL!)", "groupDescription": self.groupDescription.text!]
                        
                        //self.blogs.insert(blogItem, at: 0)
                        
                        let newGroupItemRef = ref.child(self.group.key)//.child("GroupInfo")
                        
                        newGroupItemRef.updateChildValues(groupItem)
                        
                        print("oldKey: \(self.group.key), newkey: \(newGroupItemRef)")
                        
                            self.performSegue(withIdentifier: "unwindToGroupPage", sender: self)
                    })
                }
                print("has passed checkpoint 3")
                print("successfully stored event into Firebase DB")
            }
            
        }else{
            if groupName.text == "" || groupDescription.text == ""{
                let alert = UIAlertController(title: "Error", message: "Please fill in the blanks", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            } else {
                let groupRef = FIRDatabase.database().reference(withPath: "Categories").child(self.categoryNameLabel.text!.lowercased()).child("Groups")
                
                
                print("has passed checkpoint 1")
                let imageName = NSUUID().uuidString
                //create a storage reference from our storage service
                let storageRef = FIRStorage.storage().reference().child("Groups").child(self.groupName.text!).child("\(imageName).jpg")
                
                
                
                if let thisEventImage = self.groupImage.image, let uploadData = UIImageJPEGRepresentation(thisEventImage, 0.1){
                    //if let uploadData = UIImagePNGRepresentation(self.eventImage.image!){
                    
                    
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        guard let metadata = metadata else{
                            
                            print(error!)
                            return
                        }
                        
                        let downloadURL = metadata.downloadURL()
                        print(downloadURL!)
                        
                        
                        
                        //blog formatted items needed for the array
                        let groupItem = Group(groupName: "\(self.groupName.text!)", groupParent: "", groupLocation: self.groupLocation.text!, groupImage: "\(downloadURL!)", groupDescription: self.groupDescription.text!, groupCreatorUID: self.stringOfUid, groupMemberCount: 1, Members: [:], Meetups: [:], category: self.categoryNameLabel.text!, blockedMembers: [:])
                        
                        
                        //self.blogs.insert(blogItem, at: 0)
                        let groupItemRef = groupRef.child(self.groupName.text!.lowercased()) //.child("GroupInfo")
                        groupItemRef.setValue(groupItem.toAnyObject())
                        
                        
                        // posts the creator information as the first member in the group
                        let memberRef = FIRDatabase.database().reference(withPath: "Categories").child(self.categoryNameLabel.text!.lowercased()).child("Groups").child("\(self.groupName.text!.lowercased())").child("Members")
                        
                        let churchMembers = FIRDatabase.database().reference(withPath: "members")
                        
                        var churchUsers: [Member] = []
                        
                        
                        
                        churchMembers.queryOrdered(byChild: "lastname").observe(.value, with: {snapshot in
                            print("Stage 1: members \(snapshot)")
                            
                            for member in snapshot.children{
                                
                                
                                
                                
                                let thisMember = Member(snapshot: member as! FIRDataSnapshot)
                                churchUsers.append(thisMember)
                                print("Stage 2: the Member \(churchUsers)")
                            }
                            
                            print("Stage 3: refined users \(churchUsers)")
                            print()
                            for member in churchUsers{
                                if member.key == self.stringOfUid{
                                self.username = member.username!
                                self.userImageUrl = member.userImageUrl!
                                self.id = member.key
                                self.firstname = member.firstname!
                                self.lastname = member.lastname!
                                self.email = member.email!
                                self.telephone = member.telephone!
                                self.bio = member.bio!
                                self.role = member.role!
                                self.birthday = member.birthday!
                                self.anniversary = member.anniversary!
                                self.profession = member.profession!
                                self.address = member.address!
                                self.gender = member.gender!
                                self.status = member.status!
                                self.work = member.work!
                                self.currentLevelStatus = member.status!
                                self.allergies = member.allergies!
                                self.hobbies = member.hobbies!
                                self.parentName = member.parentName!
                                self.parentUserName = member.parentUserName!
                                self.parentUid = member.parentUid!
                                self.parentImage = member.parentImage!
                                self.parentEmail = member.parentEmail!
                                self.parentTelephone = member.parentTelephone!
                                self.parentWorkTelephone = member.parentWorkTelephone!
                                self.studentSelected = false
                                
                                
                                    print("found you!")
                                    // for main database
                                    let memberItem =
                                        Member(username: self.username, userImageUrl: self.userImageUrl, id: self.id, firstname: self.firstname, lastname: self.lastname, email: self.email, telephone: self.telephone, bio: self.bio, role: self.role, birthday: self.birthday, anniversary: self.anniversary, profession: self.profession, address: self.address, gender: self.gender, status: self.status, work: self.work, currentLevelStatus: self.status, allergies: self.allergies, hobbies: self.hobbies, parentName: self.parentName, parentUserName: self.parentUserName, parentUid: self.parentUid, parentImage: self.parentImage, parentEmail: self.parentEmail, parentTelephone: self.parentTelephone, parentWorkTelephone: self.parentWorkTelephone, studentSelected: false)
                                    
                                    //self.blogs.insert(blogItem, at: 0)
                                    let memberItemRef = memberRef.child(self.stringOfUid.lowercased())
                                    memberItemRef.setValue(memberItem.toAnyObject())
                                }
                            }
                        })
                        // posts the group to the users/Group
                        self.postGroup(groupImage: "\(downloadURL!)")
                                
                        self.performSegue(withIdentifier: "unwindToMainDashboard", sender: self)
                            
                    })
                }
                print("has passed checkpoint 3")
                
                print("successfully stored event into Firebase DB")
            }
        }
    }
    
    
    func postGroup(groupImage: String){
        // posts the Group name/key in the users groups section
        let groupItemRef = FIRDatabase.database().reference(withPath: "users").child(self.stringOfUid).child("Groups").child("\(self.groupName.text!.lowercased())")
        // for main database
        let groupItem = Group(groupName: "\(self.groupName.text!)", groupParent: "", groupLocation: self.groupLocation.text!, groupImage: groupImage, groupDescription: self.groupDescription.text!, groupCreatorUID: self.stringOfUid, groupMemberCount: 1, Members: [:], Meetups: [:], category: self.categoryNameLabel.text!,blockedMembers: [:])
        
        //self.blogs.insert(blogItem, at: 0)
        groupItemRef.setValue(groupItem.toAnyObject())
        
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
        //print("Image: \(stringOfProfileImageView), Name: \(stringOfProfileName), UID: \(stringOfUid)")
        
        currentUserImage.loadImageUsingCacheWithURLString(urlString: stringOfProfileImageView)
        
    }
    
    @IBAction func postGroupDelete(){
        // posts the Group name/key in the users groups section
        let usersMeetupItemRef = FIRDatabase.database().reference(withPath: "users").child(self.stringOfUid).child("Groups").child("\(self.group.key)")
        
        let meetupItemRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child(group.key)
        
        let meetupGroupRef = FIRDatabase.database().reference(withPath: "Groups").child(group.key)
        
        
        let alert = UIAlertController(title: "Delete Group", message: "Are you sure you want to delete this group?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Close", style: .default) { action in
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { action in
            usersMeetupItemRef.removeValue()
            meetupItemRef.removeValue()
            meetupGroupRef.removeValue()
            self.postMeetupDelete()
            
        }
        
        // actions of the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        // action to present the alert controller
        present(alert, animated: true, completion: nil)
        //self.blogs.insert(blogItem, at: 0)
        
    }
    
    func postMeetupDelete(){
        // posts the Group name/key in the users groups section
        //let usersMeetupItemRef = FIRDatabase.database().reference(withPath: "users").child(self.stringOfUid).child("Meetups").child()
        
        let meetupItemRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child(group.key).child("Meetups")
        
        //usersMeetupItemRef.removeValue()
        meetupItemRef.removeValue()
        
        self.performSegue(withIdentifier: "unwindToMainDashboardFromDelete", sender: self)
        
    }
    
    // for adjusting text field distance from bottom
    func animateTextField(textField: UITextField, up: Bool) {
        let movementDistance: CGFloat = -200
        let movementDuration: Double = 0.3
        var movement: CGFloat = 0
        
        if up {
            movement = movementDistance
        }else {
            movement = -movementDistance
        }
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    //...
    
    
   
    
    @IBAction func chooseCategory(_ sender: Any) {
        if isEditingGroup == true {
        }else{
            performSegue(withIdentifier: "ShowCategories", sender: self)
        }
    }
    
    
    
    
    
    
    @IBAction func chooseImageButton(_ sender: Any) {
        
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
            addPhotoIcon.isHidden = true
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = (originalImage as! UIImage)
            
        }
        if let selectedImage = selectedImageFromPicker{
            groupImage.image = selectedImage
            groupImage.contentMode = .scaleAspectFill
            groupImage.clipsToBounds = true
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        // if is editing
        if isEditingGroup == true{
            self.performSegue(withIdentifier: "unwindToGroupPage", sender: self)
        }else if isEditingGroup == false{
            // if is not editing
            
        }
    }
    
    
    
    /* MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    */

}


