//
//  AddPastorTableViewController.swift
//  ChurchAppOne
//
//  Created by Quinton Quaye on 10/17/18.
//  Copyright © 2018 Transformation Church International. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class AddPastorTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate {

    @IBOutlet weak var pastorImage: UIImageView!
    @IBOutlet weak var imageFilter: UIImageView!
    
    @IBOutlet weak var pastoralTitle: UITextField!
    @IBOutlet weak var pastorFirstName: UITextField!
    @IBOutlet weak var pastorLastName: UITextField!
    
    @IBOutlet weak var eventUploadImageIcon: UIImageView!
    @IBOutlet weak var postBlogButton: UIButton!
    @IBOutlet weak var cancelBlogButton: UIButton!
    
    let ref = FIRDatabase.database().reference(withPath: "blog-items")
    let usersRef = FIRDatabase.database().reference(withPath: "users").child("thisUserInfo")
    
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfUid = ""
    var user: ChurchUser!
    var pastoralPost: Blog!
    var isEditingPastoralPost = false
    var pastoralPostKey = ""
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        
        self.pastoralTitle.delegate = self
        self.pastorFirstName.delegate = self
        self.pastorLastName.delegate = self
        
        postBlogButton.churchAppButtonRegular()
        
        cancelBlogButton.churchAppButtonRegular()
        
        self.hideKeyboardWhenTappedAround()
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
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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
            eventUploadImageIcon.isHidden = true
            imageFilter.isHidden = true
            
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = (originalImage as! UIImage)
            
        }
        if let selectedImage = selectedImageFromPicker{
            pastorImage.image = selectedImage
            pastorImage.contentMode = .scaleAspectFill
            pastorImage.clipsToBounds = true
            
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
    @IBAction func addPastorButton(_ sender: Any) {
        if isEditingPastoralPost == true {
            if pastorFirstName.text == "" || pastorLastName.text == ""  {
                let alert = UIAlertController(title: "No Title", message: "Please add a title", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                
            } else {
                //for time format
                monthFormatter.dateFormat = "MMM"
                dayFormatter.dateFormat = "dd"
                dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
                //dateFormatter.dateStyle = .medium
                //dateFormatter.timeStyle = .short
                
                print("has passed checkpoint 1")
                let imageName = NSUUID().uuidString
                
                let storageRef = FIRStorage.storage().reference().child("Pastorial").child("\(imageName).jpg")
                
                
                //if let uploadData = UIImagePNGRepresentation(self.socialImage.image!){
                
                
                if let thisPastorialImage = self.pastorImage.image, let uploadData = UIImageJPEGRepresentation(thisPastorialImage, 0.1){
                    
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        guard let metadata = metadata else{
                            
                            print(error!)
                            return
                        }
                        
                        let downloadURL = metadata.downloadURL()
                        print(downloadURL!)
                        
                        //blog title
                        //guard let titleField = self.blogTitleTextField,
                            //let textTitle = titleField.text else { return }
                        //blog message
                        //guard let messageField = self.blogMessageTextField,
                            //let textMessage = messageField.text else { return }
                        
                        
                        //blog formatted items needed for the array
                        //let blogItem = Blog(blogTitle: textTitle, blogMesage: textMessage, blogDate: self.pastoralPost.blogDate, blogImage: String(describing: downloadURL!), blogLikes: self.pastoralPost.blogLikes, blogUniq: self.pastoralPost.blogUniq)
                        
                        
                        //let blogItemRef = self.ref.child(self.pastoralPostKey)
                        //blogItemRef.setValue(blogItem.toAnyObject())
                    })
                }
                print("has passed checkpoint 3")
                print("successfully stored event into Firebase DB")
                tableView.reloadData()
                
                
                performSegue(withIdentifier: "UnwindToPastorialBlog", sender: self)
            }
            
        }else {
            if pastorFirstName.text == "" || pastorLastName.text == "" {
                let alert = UIAlertController(title: "No Title", message: "Please add a title", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
                
            } else {
                
                //for time format
                monthFormatter.dateFormat = "MMM"
                dayFormatter.dateFormat = "dd"
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .short
                
                print("has passed checkpoint 1")
                let imageName = NSUUID().uuidString
                
                let storageRef = FIRStorage.storage().reference().child("Pastorial").child("\(imageName).jpg")
                
                
                //if let uploadData = UIImagePNGRepresentation(self.socialImage.image!){
                
                if pastorImage.image == nil || pastorImage.image == UIImage(named:"travelling"){
                    
                    if let thisPastorialImage = UIImage(named: "ic_person_72pt_3x"), let uploadData = UIImageJPEGRepresentation(thisPastorialImage, 0.1){
                        
                        storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                            guard let metadata = metadata else{
                                
                                print(error!)
                                return
                            }
                            
                            let downloadURL = metadata.downloadURL()
                            print(downloadURL!)
                            
                            //blog title
                            guard let titleField = self.pastoralTitle,
                                let textTitle = titleField.text else { return }
                            
                            guard let firstName = self.pastorFirstName,
                                let textFirstName = firstName.text else { return }
                            
                            guard let lastName = self.pastorLastName,
                                let textLastName = lastName.text else { return }
                           
                            
                            
                            //blog formatted items needed for the array
                            let pastorItem = Pastor(pastorImage: "\(downloadURL!)", firstName: textFirstName, lastName: textLastName, pastorTitle: textTitle, creatorId: self.stringOfUid)
                            
                            
                            let pastorItemRef = self.ref.child("pastors").child("\(textFirstName)\(textLastName)")
                            let pastorDataRef = pastorItemRef.child("info")
                            pastorDataRef.setValue(pastorItem.toAnyObject())
                        })
                    }
                    print("has passed checkpoint 3")
                    print("successfully stored event into Firebase DB")
                    tableView.reloadData()
                    
                    
                    performSegue(withIdentifier: "unwindToPastorsList", sender: self)
                    
                }else {
                    
                    if let thisPastorialImage = self.pastorImage.image, let uploadData = UIImageJPEGRepresentation(thisPastorialImage, 0.1){
                        
                        storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                            guard let metadata = metadata else{
                                
                                print(error!)
                                return
                            }
                            
                            let downloadURL = metadata.downloadURL()
                            print(downloadURL!)
                        
                            
                            //blog title
                            guard let titleField = self.pastoralTitle,
                                let textTitle = titleField.text else { return }
                            
                            guard let firstName = self.pastorFirstName,
                                let textFirstName = firstName.text else { return }
                            
                            guard let lastName = self.pastorLastName,
                                let textLastName = lastName.text else { return }
                            
                            
                            
                            //blog formatted items needed for the array
                            let pastorItem = Pastor(pastorImage: "\(downloadURL!)", firstName: textFirstName, lastName: textLastName, pastorTitle: textTitle, creatorId: self.stringOfUid)
                            
                            
                            let pastorItemRef = self.ref.child("pastors").child("\(textFirstName)\(textLastName)")
                            let pastorDataRef = pastorItemRef.child("info")
                            pastorDataRef.setValue(pastorItem.toAnyObject())
                        })
                    }
                    print("has passed checkpoint 3")
                    print("successfully stored event into Firebase DB")
                    tableView.reloadData()
                    
                    
                    performSegue(withIdentifier: "unwindToPastorsList", sender: self)
                }
            }
        }
    }
    
    @IBAction func cancelBlogButton(_ sender: Any) {
      
        pastoralTitle.placeholder = "Pastoral Title..."
        pastorFirstName.text = "First Name..."
        pastorLastName.text = "Last Name..."
        performSegue(withIdentifier: "unwindToPastorsList", sender: self)
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
