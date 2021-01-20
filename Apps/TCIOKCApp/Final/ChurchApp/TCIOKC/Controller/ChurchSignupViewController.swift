 //
//  ChurchSignupViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 1/25/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import SafariServices
 
class ChurchSignupViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    //Outlets
        //Inputs
    @IBOutlet weak var signupFirstName: UITextField!
    @IBOutlet weak var signupLastName: UITextField!
    @IBOutlet weak var signupBirthday: UITextField!
    @IBOutlet weak var signupUsername: UITextField!
    @IBOutlet weak var signupPassword: UITextField!
    @IBOutlet weak var signupSubmitButton: UIButton!
    @IBOutlet weak var signupImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
 
    @IBOutlet weak var termsButton: UIButton!
    
    @IBOutlet weak var privacyButton: UIButton!
    
    let bdayPicker = UIDatePicker()
    
    
    var Agreement = "Terms of Use (Terms) \nLast updated: 7/29/2018 \n \nPlease read these Terms of Use (Terms, Terms of Use) carefully before using the Mobile App TCIApp (The Service) operated by BerryXChange.LLC & BerryXChange-Innovations. \n \nYour access to and use of the Service is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use the Service. \n \nBy accessing or using the Service, you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the Service.  \n \nContent \n \nOur Service allows you to post, like, store, share and otherwise make available certain information, text, graphics, images, or other material (Content). You are responsible for the material you provide and post. \n \nLinks To Other Web Sites \n \nOur Service may contain links to third-party web sites or services that are not owned or controlled by BerryXChange.LLC or BerryXChange-Innovations. \n \nBerryXChange.LLC & BerryXChange-Innovations has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third party web sites or services. You further acknowledge and agree that BerryXChange.LLC & BerryXChange-Innovations shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with use of or reliance on any such content, goods or services available on or through any such web sites or services.\n \nTermination \n \nWe may terminate or suspend access to our Service immediately, without prior notice or liability, for any reason whatsoever of bullying, inappropriate behavior, language, images that harm or objectify others in any manner, including without limitation if you breach these Terms. \n \nAll provisions of the Terms which by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability. Should any user be subject to any of these objectifications or inappropriate behavior, you have the right and responsibility to report it to berryxchange.innovations@gmail.com or use the in-app chat to report to your administrator. \n \nChanges \n \nWe reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will try to provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion. \n \nContact Us \n \nIf you have any questions about these Terms, please contact us at berryxchange.innovations@gmail.com"
    
    //Main Variables
        // as a reference for access to this viewController from other views
    var usersViewController: MessagesController?
    var imagePicker = UIImagePickerController()
    
    //View
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signupBirthday.inputView = bdayPicker
        
        //Initials
        self.hideKeyboardWhenTappedAround()
        imagePicker.delegate = self

        //Delegates
        signupUsername.delegate = self
        signupPassword.delegate = self
        
        //Visuals
        signupFirstName.underlined()
        signupLastName.underlined()
        signupBirthday.underlined()
        signupUsername.underlined()
        signupPassword.underlined()
        signupSubmitButton.churchAppButtonRegular()
       
        
        cancelButton.churchAppButtonRegular()
        
        // Create a date picker for the birthday  field.
        
        bdayPicker.datePickerMode = .date
        bdayPicker.addTarget(self, action: #selector(updateDateField(sender:)), for: .valueChanged)
        
        // If the date field has focus, display a date picker instead of keyboard.
        // Set the text to the date currently displayed by the picker.
        signupBirthday.inputView = bdayPicker
        
        
        //Firebase
            //Listeners
        FIRAuth.auth()?.addStateDidChangeListener() { auth, user in
            if user != nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let controller = storyboard.instantiateViewController(withIdentifier: "MainViewController") as UIViewController
               
                self.show(controller, sender: self)
            }//End of if statement
            
        }//end of listener
        // the agreement Text
        
    }//End of ViewDidLoad

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //End...
    
    //for datePicker
    
    
    // Called when the date picker changes.
    
    @objc func updateDateField(sender: UIDatePicker) {
        switch sender{
        case bdayPicker:
            signupBirthday?.text = formatDateForDisplay(date: sender.date)
        
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
    
    
    //Actions
    
    @IBAction func signupSubmitButton(_ sender: Any) {
        // remember to change this on the actual app
        signupRecheck()
        //signUpRecheckDemo()
    }
        //...
    
   
    
    
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
            signupImage.layer.cornerRadius = 55
            signupImage.layer.masksToBounds = true
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = (originalImage as! UIImage)
            
        }
        if let selectedImage = selectedImageFromPicker{
            signupImage.image = selectedImage
            signupImage.layer.cornerRadius = 55
            signupImage.layer.masksToBounds = true
            signupImage.contentMode = .scaleAspectFill
            signupImage.clipsToBounds = true
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
        //...
    
    // terms
    
    @IBAction func termsButton(_ sender: Any) {
   
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let controller = storyboard.instantiateViewController(withIdentifier: "TermsAndPoliciesViewController") as! TermsAndPoliciesViewController
        controller.isTerms = true
        self.show(controller, sender: self)
    }
    //...
    
    // privacy
    @IBAction func privacyButton(_ sender: Any) {
        let churchWebsitePolicy = "https://www.berryxchange.org/Innovations/privacy-policy/"
        
        if let url = URL(string: churchWebsitePolicy){
            let safariController = SFSafariViewController(url:url)
            present(safariController, animated: true, completion: nil)
        }
        
        /* for individual use only
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         
         let controller = storyboard.instantiateViewController(withIdentifier: "TermsAndPoliciesViewController") as! TermsAndPoliciesViewController
         controller.isPrivacy = true
         self.show(controller, sender: self)
         */
    }
    
        //...
    
    func signUpRecheckDemo(){
        let alert = UIAlertController(title: "Unavailable", message: "Sorry, we are unable to add new users at this time, please try again later", preferredStyle: .alert)
        
        let returnAction = UIAlertAction(title: "Ok", style: .default) { action in
        }
        
        // actions of the alert controller
        alert.addAction(returnAction)
        
        // action to present the alert controller
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func signupRecheck(){
        if signupUsername.text == "" || signupPassword.text == "" {
            
            let alert = UIAlertController(title: "Event Alert", message: "One or more fields are empty.", preferredStyle: .alert)
            
            let returnAction = UIAlertAction(title: "Return", style: .default) { action in
            }
            
            // actions of the alert controller
            alert.addAction(returnAction)
            
            // action to present the alert controller
            present(alert, animated: true, completion: nil)
            
        } else {
            
            if isValidEmail(email: signupUsername.text!) == true{
                
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
            
            if isValidPassword(testStr: signupPassword.text!) == true{
                
            }else{
                let alert = UIAlertController(title: "Registration", message: "Please make sure your password is 8 characters long", preferredStyle: .alert)
                
                let returnAction = UIAlertAction(title: "Return", style: .default) { action in
                }
                
                // actions of the alert controller
                alert.addAction(returnAction)
                
                self.usersViewController?.fetchUserAndSetupNavBarTitle()
                // action to present the alert controller
                present(alert, animated: true, completion: nil)
            }
            
            FIRAuth.auth()?.createUser(withEmail: signupUsername.text!, password: signupPassword.text!, completion: { (user: FIRUser?, error) in
    
                    if error != nil {
                        print(error!)
                        //do something if the user is already there or if somethig is wrong with the user info
                        
                        let alert = UIAlertController(title: "Duplicate User", message: "Sorry, \(self.signupUsername.text!) is already in use, please try another", preferredStyle: .alert)
                        
                        let returnAction = UIAlertAction(title: "Ok", style: .default) { action in
                        }
                        
                        // actions of the alert controller
                        alert.addAction(returnAction)
                        
                        // action to present the alert controller
                        self.present(alert, animated: true, completion: nil)
                        
                        return
                    }
                
                // saving the user to the databae...
                guard let uid = user?.uid else {
                    return
                }
                
                // saving an image to FirebaseDatabase..
                //let imageName = NSUUID().uuidString
                let storageRef = FIRStorage.storage().reference().child("Users").child(uid).child("Profile Image").child("ProfileImage.jpg")
                if self.signupImage.image == UIImage(named:"addUserImage"){
                    self.signupImage.image = UIImage(named: "ic_person_72pt_3x")
                    if let signupImage = self.signupImage.image, let uploadData = UIImageJPEGRepresentation(signupImage, 0.1){
                        
                        storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                            
                            if error != nil{
                                print(error!)
                                return
                            }//...
                            
                            if let userImageUrl = metadata?.downloadURL()?.absoluteString{
                                
                                // where your values come from
                                let values = ["username": self.signupUsername.text!, "userImageUrl": userImageUrl, "role": "regular", "firstname": self.signupFirstName.text!, "lastname": self.signupLastName.text!, "birthday": self.signupBirthday.text!, "email": self.signupUsername.text!,"id": "unknown id", "telephone": "Choose telephone #", "bio": "unknown bio", "anniversary": "Choose anniversary", "profession": "Set profession", "address": "Choose address", "gender": "Choose gender", "status": "Choose status", "work": "Choose work number", "currentLevelStatus": "members", "allergies": "unknown allergies", "hobbies": "unknown hobbies", "parentName": "unknown parent name", "parentUserName": "unknown parent username", "parentUid": "unknown parent id", "parentImage": "unknownparentimage", "parentEmail": "unknown parent email", "parentTelephone": "unknown parent telephone number", "parentWorkTelephone": "unknown parent work number", "studentSelected": false] as [String : AnyObject]
                                
                                self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                                
                                print(userImageUrl)
                                print(self.signupUsername.text!)
                                
                            }//...
                            
                        })//End of Storage Ref
                        
                    }//End of Image Signup
                }else{
                if let signupImage = self.signupImage.image, let uploadData = UIImageJPEGRepresentation(signupImage, 0.1){
                    
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        
                        if error != nil{
                            print(error!)
                            return
                        }//...
                        
                        if let userImageUrl = metadata?.downloadURL()?.absoluteString{
                            
                            // where your values come from
                            let values = ["username": self.signupUsername.text!, "userImageUrl": userImageUrl, "role": "regular", "firstname": self.signupFirstName.text!, "lastname": self.signupLastName.text!, "birthday": self.signupBirthday.text!, "email": self.signupUsername.text!, "id": "unknown id", "telephone": "Choose telephone #", "bio": "unknown bio", "anniversary": "Choose anniversary", "profession": "Set profession", "address": "Choose address", "gender": "Choose gender", "status": "Choose status", "work": "Choose work number", "currentLevelStatus": "members", "allergies": "unknown allergies", "hobbies": "unknown hobbies", "parentName": "unknown parent name", "parentUserName": "unknown parent username", "parentUid": "unknown parent id", "parentImage": "unknownparentimage", "parentEmail": "unknown parent email", "parentTelephone": "unknown parent telephone number", "parentWorkTelephone": "unknown parent work number", "studentSelected": false] as [String : AnyObject]
                            
                            self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                            
                            print(userImageUrl)
                            
                        }//...
                        
                    })//End of Storage Ref
                    
                }//End of Image Signup
                
                }
                
            })//End of Fireauth
            
        }//End of if statement
        
    }//End of recheck Satement
    

    // for adjusting text field distance from bottom
    func animateTextField(textField: UITextField, up: Bool) {
        let movementDistance:CGFloat = -220
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        
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
    
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        self.animateTextField(textField: textField, up:true)
    }
        //...
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up:false)
    }
        //...
    
    
    func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]){
        
        // successfully authenticated user
        // replace this when created new!
        let usersRef = FIRDatabase.database().reference()
    
        // this allows the child of the main child "users" to be the "uid" then the content of values will be stored under that uid.
       
        let usersChildRef = usersRef.child("users").child(uid).child("thisUserInfo")
        
        let membersChildRef = usersRef.child("members").child(uid)
        
        // stores the values in the usersChildRef path
        usersChildRef.updateChildValues(values, withCompletionBlock: { (error, usersRef) in
            
            if error != nil {
                print(error!)
                return
            }
           
            let user = User()
            user.setValuesForKeys(values)
            self.usersViewController?.setupNavbarWithUser(user: user)
            
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
        //...
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        if textField == signupUsername {
            signupPassword.becomeFirstResponder()
        }
        if textField == signupPassword {
            textField.resignFirstResponder()
        }
        
        return true
    }
    //...
    
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    //...
    
    
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        
        // at least one uppercase,
        // at least one digit
        // at least one lowercase
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", ".{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}//End...


    func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }

