//
//  addUserViewController.swift
//  OKCityChurch
//
//  Created by Quinton Quaye on 12/6/18.
//  Copyright © 2018 City Church. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

class addUserViewController: UIViewController, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    

    var currentSelection = ""
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var birthday: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var workNumber: UITextField!
    @IBOutlet weak var profession: UITextField!
    @IBOutlet weak var maritalStatus: UITextField!
    @IBOutlet weak var anniversaryDate: UITextField!
    @IBOutlet weak var allergies: UITextView!
    @IBOutlet weak var hobbies: UITextView!
    @IBOutlet weak var parentImage: UIImageView!
    @IBOutlet weak var parentName: UILabel!
    @IBOutlet weak var parentButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var usersViewController: MessagesController?
    
    
    let genderPicker = UIPickerView()
    let statusPicker = UIPickerView()
    let bdayPicker = UIDatePicker()
    let anniversaryPicker = UIDatePicker()
    var thisParent : Member!
    var thisParentName = ""
    var parentUid = ""
    var parentUserName = ""
    var thisParentImage = ""
    var parentEmail = ""
    var parentTelephone = ""
    var parentWorkTelephone = ""
    var parentAddress = ""
    var classKey = ""
    var attendance = ""
    
    @IBAction func unwindToAddUser(segue: UIStoryboardSegue){
        
    }
    
    @IBAction func unwindToAddNewUser(segue: UIStoryboardSegue){
        if segue.source is newMessageController{
            if let receivingDestination = segue.source as? newMessageController {
                
                thisParent = receivingDestination.thisParent
                if let parentImageUrl = thisParent.userImageUrl {
                    parentImage.loadImageUsingCacheWithURLString(urlString: parentImageUrl)
                }
                parentUid = thisParent.id!
                parentName.text = "\(thisParent.firstname!) \(thisParent.lastname!)"
                
                thisParentImage = thisParent.userImageUrl!
                parentEmail = thisParent.email!
                email.text = "child.\(thisParent.email!)"
                parentTelephone = thisParent.telephone!
                phone.text = thisParent.telephone!
                parentWorkTelephone = thisParent.work!
                workNumber.text = thisParent.work!
                parentAddress = thisParent.address!
                address.text = thisParent.address!
                parentButton.titleLabel?.textColor = UIColor.blue
                parentButton.setTitle("Change Parent...", for: .normal)
                print("the parent is: " + parentName.text!)
                view.reloadInputViews()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        imagePicker.delegate = self
        parentImage.image = UIImage(named: thisParentImage)
        parentImage.layer.cornerRadius = 20
        parentImage.layer.masksToBounds = true
        gender.inputView = genderPicker
        maritalStatus.inputView = statusPicker
        birthday.inputView = bdayPicker
        anniversaryDate.inputView = anniversaryPicker
        
        firstName.underlined()
        lastName.underlined()
        password.underlined()
        address.underlined()
        phone.underlined()
        email.underlined()
        birthday.underlined()
        gender.underlined()
        workNumber.underlined()
        profession.underlined()
        maritalStatus.underlined()
        anniversaryDate.underlined()
        firstName.delegate = self
        lastName.delegate = self
        password.delegate = self
        address.delegate = self
        phone.delegate = self
        email.delegate = self
        birthday.delegate = self
        gender.delegate = self
        workNumber.delegate = self
        profession.delegate = self
        maritalStatus.delegate = self
        anniversaryDate.delegate = self
        genderPicker.delegate = self
        statusPicker.delegate = self
        
        // Create a date picker for the birthday  field.
        
        bdayPicker.datePickerMode = .date
        bdayPicker.addTarget(self, action: #selector(updateDateField(sender:)), for: .valueChanged)
        
        // If the date field has focus, display a date picker instead of keyboard.
        // Set the text to the date currently displayed by the picker.
        birthday.inputView = bdayPicker
        
        
        // Create a date picker for the anniversary  field.
        
        anniversaryPicker.datePickerMode = .date
        anniversaryPicker.addTarget(self, action: #selector(updateDateField(sender:)), for: .valueChanged)
        
        // If the date field has focus, display a date picker instead of keyboard.
        // Set the text to the date currently displayed by the picker.
        anniversaryDate.inputView = anniversaryPicker
        
        
        signupButton.churchAppButtonRegular()
        
        cancelButton.churchAppButtonRegular()
        
        print(currentSelection)
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: UIPickerView Delegation
    //for gender
    let genders = ["Male", "Female"]
    
    //for marital status
    let statusStates = ["Single", "Married", "Separated", "Divorced", "Widow", "Widoer"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        switch pickerView{
        case genderPicker:
            count = genders.count
        case statusPicker:
            count = statusStates.count
        default:
            break
        }
        return count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var count = String()
        
        switch pickerView{
        case genderPicker:
            count = genders[row]
        case statusPicker:
            count = statusStates[row]
        default:
            break
        }
        return count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView{
        case genderPicker:
            gender.text = genders[row]
        case statusPicker:
            maritalStatus.text = statusStates[row]
        default:
            break
        }
        
    }
    
    
    //for datePicker
    
    
    // Called when the date picker changes.
    
    @objc func updateDateField(sender: UIDatePicker) {
        switch sender{
        case bdayPicker:
            birthday?.text = formatDateForDisplay(date: sender.date)
        case anniversaryPicker:
            anniversaryDate?.text = formatDateForDisplay(date: sender.date)
            
        default:
            break
        }
        
    }
    
    
    // Formats the date chosen with the date picker.
    
    fileprivate func formatDateForDisplay(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        
        return formatter.string(from: date)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
        if textField == firstName {
            lastName.becomeFirstResponder()
        }
        if textField == lastName {
            password.becomeFirstResponder()
        }
        if textField == password {
            textField.resignFirstResponder()
        }
        if textField == address {
            phone.becomeFirstResponder()
        }
        if textField == phone {
            email.becomeFirstResponder()
        }
        if textField == email {
            textField.resignFirstResponder()
        }
        
        if textField == workNumber {
            profession.becomeFirstResponder()
        }
        if textField == profession {
            textField.resignFirstResponder()
        }
        
        
        
        return true
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
            //imageFilter.isHidden = true
            //eventUploadImageIcon.isHidden = true
            userImage.layer.cornerRadius = 55
            userImage.layer.masksToBounds = true
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = (originalImage as! UIImage)
            
        }
        if let selectedImage = selectedImageFromPicker{
            userImage.image = selectedImage
            userImage.layer.cornerRadius = 55
            userImage.layer.masksToBounds = true
            userImage.contentMode = .scaleAspectFill
            userImage.clipsToBounds = true
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signupSubmitButton(_ sender: Any) {
        // remember to change this on the actual app
        signupRecheck()
        //signUpRecheckDemo()
    }
    

    func signupRecheck(){
        if firstName.text == "" ||
        lastName.text == "" ||
        password.text == "" ||
        address.text == "" ||
        phone.text == "" ||
        email.text == "" ||
        
        gender.text == "" ||
        
        maritalStatus.text == ""
            {
            
            let alert = UIAlertController(title: "Event Alert", message: "One or more fields are empty.", preferredStyle: .alert)
            
            let returnAction = UIAlertAction(title: "Return", style: .default) { action in
            }
            
            // actions of the alert controller
            alert.addAction(returnAction)
            
            // action to present the alert controller
            present(alert, animated: true, completion: nil)
            
        } else {
            
            if isValidEmail(email: email.text!) == true{
                
            }else{
                let alert = UIAlertController(title: "Registration", message: "Please enter a valid email address", preferredStyle: .alert)
                
                let returnAction = UIAlertAction(title: "Return", style: .default) { action in
                }
                
                // actions of the alert controller
                alert.addAction(returnAction)
                
                self.usersViewController?.fetchUserAndSetupNavBarTitle()
                // action to present the alert controller
                present(alert, animated: true, completion: nil)
            }
            
            // creating new user as secondary creation...
            if let secondaryApp = FIRApp(named: "CreatingUsersApp") {
                let secondaryAppAuth = FIRAuth(app: secondaryApp)
                
                // Create user in secondary app.
                secondaryAppAuth?.createUser(withEmail: email.text!, password: password.text!) { (user, error) in
                    if error != nil {
                        print(error!)
                    } else {
                        //Print created users email.
                        print(user!.email!)
                        
                        //Print current logged in users email.
                        print(FIRAuth.auth()?.currentUser?.email ?? "default")
                        
                        try! secondaryAppAuth?.signOut()
                        
                    }

            //end
            
                    // saving the user to the database...
                    guard let uid = user?.uid else {
                        return
                    }
                    
                    // saving an image to FirebaseDatabase..
                    //let imageName = NSUUID().uuidString
                    let storageRef = FIRStorage.storage().reference().child("Users").child(uid).child("Profile Image").child("ProfileImage.jpg")
                   
                    if self.userImage.image == UIImage(named:"addUserImage"){
                        self.userImage.image = UIImage(named: "ic_person_72pt_3x")
                        if let signupImage = self.userImage.image, let uploadData = UIImageJPEGRepresentation(signupImage, 0.1){
                            
                            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                                
                                if error != nil{
                                    print(error!)
                                    return
                                }//...
                                
                                if let userImageUrl = metadata?.downloadURL()?.absoluteString{
                                    var status = ""
                                    switch self.currentSelection{
                                        
                                    case "Salvations":
                                        status = "salvations"
                                        
                                    case "Members":
                                        status = "members"
                                        
                                    case "Guests":
                                        status = "guests"
                                        
                                    case "Miracles":
                                        status = "miracles"                                    default:
                                        break
                                    }
                                    // where your values come from
                                    var values: [String: AnyObject] = [:]
                                    
                                    // for no parent
                                    if self.parentImage.image == nil {
                                        //if the parent image is not selected...
                                        
                                        values =  ["username": self.email.text!, "userImageUrl": userImageUrl, "id": "unknown", "firstname": self.firstName.text!, "lastname": self.lastName.text!, "email": self.email.text!, "telephone": self.phone.text!, "bio": "none", "role": "regular", "birthday": self.birthday.text!, "anniversary": self.anniversaryDate.text!, "profession": self.profession.text!, "address": self.address.text!, "gender": self.gender.text!, "status": self.maritalStatus.text!, "work": self.workNumber.text!, "currentLevelStatus": status, "allergies": self.allergies.text!, "hobbies": self.hobbies.text!, "parentName": "unknown", "parentUserName": "unknown", "parentUid": "unknown", "parentImage": "unknown", "parentEmail": "unknown", "parentTelephone": "unknown", "parentWorkTelephone": "unknown", "studentSelected": false] as [String : AnyObject]
                                        
                                        
                                        
                                    }else{
                                        
                                        values = ["username": self.email.text!, "userImageUrl": userImageUrl, "id": "unknown", "firstname": self.firstName.text!, "lastname": self.lastName.text!, "email": self.email.text!, "telephone": self.phone.text!, "bio": "none", "role": "regular", "birthday": self.birthday.text!, "anniversary": self.anniversaryDate.text!, "profession": self.profession.text!, "address": self.address.text!, "gender": self.gender.text!, "status": self.maritalStatus.text!, "work": self.workNumber.text!, "currentLevelStatus": status, "allergies": self.allergies.text!, "hobbies": self.hobbies.text!, "parentName": "\(self.thisParent.firstname!) \(self.thisParent.lastname!)", "parentUserName": "\(self.thisParent.username!)", "parentUid": "\(self.parentUid)", "parentImage": "\(self.thisParent.userImageUrl!)", "parentEmail": "\(self.thisParent.email!)", "parentTelephone": "\(self.thisParent.telephone!)", "parentWorkTelephone": "\(self.thisParent.work!)", "studentSelected": false] as [String : AnyObject]
                                    }
                                    
                                    
                                    self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                                    self.performSegue(withIdentifier: "unwindToAdminControl", sender: self)
                                    
                                    print(userImageUrl)
                                    print(self.email.text!)
                                    
                                }//...
                                
                            })//End of Storage Ref
                            
                        }//End of Image Signup
                    
                    }else{ // if image is not default image
                        if let signupImage = self.userImage.image, let uploadData = UIImageJPEGRepresentation(signupImage, 0.1){
                            
                            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                                
                                if error != nil{
                                    print(error!)
                                    return
                                }//...
                                
                                if let userImageUrl = metadata?.downloadURL()?.absoluteString{
                                    
                                    var status = ""
                                    switch self.currentSelection{
                                        
                                    case "Salvations":
                                        status = "salvations"
                                        
                                    case "Members":
                                        status = "members"
                                        
                                    case "Guests":
                                        status = "guests"
                                        
                                    case "Miracles":
                                        status = "miracles"                                    default:
                                        break
                                    }
                                    
                                    // where your values come from
                                    var values: [String: AnyObject] = [:]
                                    
                                    // for no parent
                                    if self.parentImage.image == nil {
                                        //if the parent image is not selected...
                                        
                                        values =  ["username": self.email.text!, "userImageUrl": userImageUrl, "id": "unknown", "firstname": self.firstName.text!, "lastname": self.lastName.text!, "email": self.email.text!, "telephone": self.phone.text!, "bio": "none", "role": "regular", "birthday": self.birthday.text!, "anniversary": self.anniversaryDate.text!, "profession": self.profession.text!, "address": self.address.text!, "gender": self.gender.text!, "status": self.maritalStatus.text!, "work": self.workNumber.text!, "currentLevelStatus": status, "allergies": self.allergies.text!, "hobbies": self.hobbies.text!, "parentName": "unknown", "parentUserName": "unknown", "parentUid": "unknown", "parentImage": "unknown", "parentEmail": "unknown", "parentTelephone": "unknown", "parentWorkTelephone": "unknown", "studentSelected": false] as [String : AnyObject]
                                        
                                        
                                        
                                    }else{
                                        
                                        values = ["username": self.email.text!, "userImageUrl": userImageUrl, "id": "unknown", "firstname": self.firstName.text!, "lastname": self.lastName.text!, "email": self.email.text!, "telephone": self.phone.text!, "bio": "none", "role": "regular", "birthday": self.birthday.text!, "anniversary": self.anniversaryDate.text!, "profession": self.profession.text!, "address": self.address.text!, "gender": self.gender.text!, "status": self.maritalStatus.text!, "work": self.workNumber.text!, "currentLevelStatus": status, "allergies": self.allergies.text!, "hobbies": self.hobbies.text!, "parentName": "\(self.thisParent.firstname!) \(self.thisParent.lastname!)", "parentUserName": "\(self.thisParent.username!)", "parentUid": "\(self.parentUid)", "parentImage": "\(self.thisParent.userImageUrl!)", "parentEmail": "\(self.thisParent.email!)", "parentTelephone": "\(self.thisParent.telephone!)", "parentWorkTelephone": "\(self.thisParent.work!)", "studentSelected": false] as [String : AnyObject]
                                    }
                                    
                                    self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                                    
                                    print(userImageUrl)
                                    self.performSegue(withIdentifier: "unwindToAdminControl", sender: self)
                                    
                                }//...
                            })//End of Storage Ref
                        }// end of image conversion
                    }//End of Image Signup
                }//End of Fireauth
            }//End of if statement
        }//end of if firstname field is empty or not
    }//End of recheck Satement
    
    func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]){
        
        // successfully authenticated user
        // replace this when created new!
        let usersRef = FIRDatabase.database().reference()
        
        // this allows the child of the main child "users" to be the "uid" then the content of values will be stored under that uid.
        
        var membersChildRef = FIRDatabaseReference()
        switch currentSelection{
        
        case "Salvations":
            membersChildRef = usersRef.child("salvations").child(uid)
            
        case "Members":
            membersChildRef = usersRef.child("members").child(uid)
            
        case "Guests":
            membersChildRef = usersRef.child("guests").child(uid)
            
        case "Miracles":
            membersChildRef = usersRef.child("miracles").child(uid)
        default:
            break
        }
        
        
        let usersChildRef = usersRef.child("users").child(uid).child("thisUserInfo")
        
        // stores the values in the usersChildRef path
        usersChildRef.updateChildValues(values, withCompletionBlock: { (error, usersRef) in
            
            if error != nil {
                print(error!)
                return
            }
            /* omit this function when already signed in....
            let user = User()
            user.setValuesForKeys(values)
            self.usersViewController?.setupNavbarWithUser(user: user)
            */
            print("successfully stored user into Firebase DB")
        })
 
        
        // to members section
        // stores the values in the usersChildRef path
        membersChildRef.updateChildValues(values, withCompletionBlock: { (error, usersRef) in
            
            if error != nil {
                print(error!)
                return
            }
            
            
            let user = User()
            user.setValuesForKeys(values)
            self.usersViewController?.setupNavbarWithUser(user: user)
            
            print("successfully stored user into Firebase DB")
        })
 
    }
    
    @IBAction func addParentButton(_ sender: Any) {
        //let NewMessageController = newMessageController()
        let controller = storyboard?.instantiateViewController(withIdentifier: "newMessage") as! newMessageController
        controller.style = "addNewUser"
        
        show(controller, sender: self)
    }

    @IBAction func cancelButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToAdminControl", sender: self)
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
