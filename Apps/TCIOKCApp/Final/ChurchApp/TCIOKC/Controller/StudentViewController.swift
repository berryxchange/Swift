//
//  StudentViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/17/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import MessageUI

class StudentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var contactParentButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var studentAge: UILabel!
    
    @IBOutlet weak var parentDisplayName: UILabel!
    
    @IBOutlet weak var profileImageBackgroundPad: UIView!
    @IBOutlet weak var camera: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var editingView: UIView!

    
    @IBOutlet weak var inputFirstName: UITextField!
    @IBOutlet weak var inputLastName: UITextField!
    @IBOutlet weak var inputDone: UIButton!
    
    @IBOutlet weak var inputAge: UITextField!
    
    @IBOutlet weak var editingViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundGraphicView: UIView!
    @IBOutlet weak var ParentButton: UIButton!
    @IBOutlet weak var parentFirstNameLabel: UILabel!
    
    @IBOutlet weak var parentLastNameLabel: UILabel!
    @IBOutlet weak var thisParentImage: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteThisUserButton: UIButton!
    
    @IBOutlet weak var userPadShadowPad: UIView!
    
    
    var thisGroupKey = ""
    var sAge = ""
    var sFirstName = ""
    var sLastName = ""
    var sImage: String? = ""
    var thisGroup: Group!
    var thisGroupMember: Member!
    var sAttendance : [Attendance] = []
    var imagePicker = UIImagePickerController()

    
    
    // for the parent data
    var thisStudentParentData : Member!
    
    // if there isnt one, the Uid will be the imageurl
    var stringOfProfileUid = ""
    var parentId = ""
    var parentName = ""
    var parentUserName = ""
    var parentImage = ""
    var parentEmail = ""
    var parentTelephone = ""
    
    
    @IBAction func unwindToEditStudentBasic(segue: UIStoryboardSegue){
    }
    
    @IBAction func unwindToEditStudent(segue: UIStoryboardSegue){
        if segue.source is newMessageController{
            if let receivingDestination = segue.source as? newMessageController {
                
                thisStudentParentData = receivingDestination.thisParent
                if let parentImageUrl = thisStudentParentData.userImageUrl {
                    thisParentImage.loadImageUsingCacheWithURLString(urlString: parentImageUrl)
                }
                parentUserName = thisStudentParentData.parentUserName!
                parentId = thisStudentParentData.parentUid!
                parentFirstNameLabel.text = "\(thisStudentParentData.firstname!)"
                parentLastNameLabel.text = "\(thisStudentParentData.lastname!)"
                parentImage = thisStudentParentData.userImageUrl!
                parentEmail = thisStudentParentData.email!
                parentTelephone = thisStudentParentData.telephone!
                ParentButton.titleLabel?.textColor = UIColor.blue
                ParentButton.setTitle("Change Parent...", for: .normal)
                print("the parent is: " + parentFirstNameLabel.text! + parentLastNameLabel.text!)
                parentDisplayName.text = "\(thisStudentParentData.firstname!) \(thisStudentParentData.lastname!)"
                view.reloadInputViews()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = #colorLiteral(red: 0.4364677785, green: 0.4364677785, blue: 0.4364677785, alpha: 1)
        tableView.layer.cornerRadius = 4
        
        backgroundGraphicView.backgroundColor = UIColor(patternImage: UIImage(named: "black_scales")!)
        ParentButton.setTitle("Select Parent", for: .normal)
        thisParentImage.image = UIImage(named: parentImage)
        thisParentImage.layer.cornerRadius = 37.5
        thisParentImage.layer.masksToBounds = true
        contactParentButton.layer.cornerRadius = 20
        contactParentButton.layer.masksToBounds = true
       
        inputDone.churchAppButtonRegular()
        
        cancelButton.churchAppButtonRegular()
    deleteThisUserButton.churchAppButtonImportant()
        
        
        hideKeyboardWhenTappedAround()
        editingViewBottomConstraint.constant = -650
        
        userPadShadowPad.layer.cornerRadius = 4
        userPadShadowPad.layer.shadowOpacity = 0.8
        userPadShadowPad.layer.shadowOffset = CGSize.zero
        userPadShadowPad.layer.shadowRadius = 4.0
        //userPadShadowPad.layer.masksToBounds = false
        userPadShadowPad.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        
        let studentAttendanceRef = FIRDatabase.database().reference().child("Categories").child(thisGroup.category!.lowercased()).child("Groups").child(thisGroup.key).child("Members").child(thisGroupMember.key).child("Attendance Record")
        
        
        studentAttendanceRef.queryOrdered(byChild: "attendanceDate").observe(.value, with: {snapshot in
            
            print(snapshot.children)
            var newAttendance = [Attendance]()
            //print("your snapshot: \(snapshot)")
            //2 new items are an empty array
            for item in snapshot.children {
                print(item)
                let attendanceItem = Attendance(snapshot: item as! FIRDataSnapshot)
                print(attendanceItem)
                newAttendance.insert(attendanceItem, at: 0)
            }
            
            self.sAttendance = newAttendance
            self.tableView.reloadData()
            //print(self.sAttendanceDate)
            //print(self.sAttendanceStatus)
        })

        imagePicker.delegate = self
        inputFirstName.delegate = self
        inputLastName.delegate = self
        inputAge.delegate = self
        
        if let userImageUrl = sImage{
            profileImage.loadImageUsingCacheWithURLString(urlString: userImageUrl)
        }
        
        studentAge.text = "Age: \(sAge)"
        studentName.text = "\(sFirstName) \(sLastName)"
        parentDisplayName.text = "Parent: \(parentName)"
        contactParentButton.churchAppButtonImportant()

        profileImageBackgroundPad.layer.shadowOpacity = 0.5
        profileImageBackgroundPad.layer.shadowOffset = CGSize.zero
        profileImageBackgroundPad.layer.shadowRadius = 5.0
        profileImageBackgroundPad.layer.masksToBounds = false
        
        camera.layer.shadowOpacity = 0.8
        camera.layer.shadowOffset = CGSize.zero
        camera.layer.shadowRadius = 2.0
        camera.layer.masksToBounds = false
        
        profileImageBackgroundPad.layer.cornerRadius = 55
        self.profileImage.layer.cornerRadius = 50
        // Do any additional setup after loading the view.
    }

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sAttendance.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? StudentAttendanceCell
        
       
        
        
        cell?.attendanceDate.text = sAttendance[indexPath.row].attendanceDate
        cell?.attendanceDate.textColor = UIColor.black
        
        cell?.attendanceStatus.text = sAttendance[indexPath.row].attendanceStatus
        if cell?.attendanceStatus.text == "Absent"{
            cell?.attendanceStatus.textColor = UIColor.red
        }else{
            cell?.attendanceStatus.textColor = UIColor.blue
        }
        
        return cell!
    }

    
    @IBAction func inputDone(_ sender: Any) {
   
    // this is for updating the student data
    let userRef = FIRDatabase.database().reference().child("Categories").child(thisGroup.category!.lowercased()).child("Groups").child(thisGroup.key).child("Members").child(thisGroupMember.key)
    
    
        let userPost = ["firstname": inputFirstName.text!, "lastname": inputLastName.text!, "birthday": inputAge.text!, "parentName": "\(parentFirstNameLabel.text!) \(parentLastNameLabel.text!)", "parentUserName": parentUserName, "parentUid": parentId, "parentImage": parentImage, "parentEmail": parentEmail, "parentTelephone": parentTelephone
    ]
        
    userRef.updateChildValues(userPost)
        editingViewBottomConstraint.constant = -650
        editButton.isHidden = false
        studentName.text = "\(inputFirstName.text!) \(inputLastName.text!)"
        studentAge.text = "\(inputAge.text!)"
        
        self.view.reloadInputViews()
        
    }
    
    
     @IBAction func inputCancel(_ sender: Any) {
    
        inputAge.text = sAge
        
        editButton.isHidden = true
        editingViewBottomConstraint.constant = -650
        editButton.isHidden = false
    }
    
    
    
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
    
    
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        profileImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        //
        let studentRef = FIRDatabase.database().reference().child("Classes").child("\(thisGroupKey)").child("Student").child(stringOfProfileUid)
        
        //updating the image
        //let imageName = NSUUID().uuidString
        
        let storageRef = FIRStorage.storage().reference().child("Classes").child(thisGroupKey).child("Students").child("\(sFirstName) \(sLastName) ProfileImage.jpg")
        
        if let thisUserImage = self.profileImage.image, let uploadData = UIImageJPEGRepresentation(thisUserImage, 0.1){
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                guard let metadata = metadata else{
                    
                    print(error!)
                    return
                }
                
                let downloadURL = metadata.downloadURL()
                print(downloadURL!)
                
                let post = ["userImageUrl":"\(downloadURL!)"]
                studentRef.updateChildValues(post)
                print("the UID: \(self.stringOfProfileUid)")
                
            })
        }
    }

    
    @IBAction func editButton(_ sender: Any) {
    
        inputFirstName.text = sFirstName
        inputLastName.text = sLastName
        inputAge.text = sAge
        editButton.isHidden = true
        editingViewBottomConstraint.constant = 0
        parentFirstNameLabel.text = parentName
        parentLastNameLabel.text = ""
       thisParentImage.loadImageUsingCacheWithURLString(urlString: parentImage)
     
    }
    
    
    @IBAction func deleteThisUser(_ sender: Any) {
        // take user off class & or group
        // take group off users/Groups
        // take user off Categories/Groups/Meetups/MembersGoing
        // take meetup off users/Meetups
        let studentRef = FIRDatabase.database().reference().child("Classes").child("\(self.thisGroupKey.lowercased())").child("Student").child("\(stringOfProfileUid)")
        
        
        let alert = UIAlertController(title: "Delete Student", message: "Are you sure you want to delete this student?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Close", style: .default) { action in
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { action in
           studentRef.removeValue()
        self.performSegue(withIdentifier: "unwindToClass", sender: self)
        }
        
        // actions of the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        // action to present the alert controller
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func addParentButton(_ sender: Any) {
        //let NewMessageController = newMessageController()
        let controller = storyboard?.instantiateViewController(withIdentifier: "newMessage") as! newMessageController
        controller.style = "editStudent"
        
        show(controller, sender: self)
    }
    
    
    //sending Message
    @IBAction func contactParentButton(_ sender: Any) {
        
            print("I am going to send a mesaage!")
            
            let alert = UIAlertController(title: "How do you want to send your message", message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "App Message", style: .default, handler: { _ in
                // function here
                self.internalMessage()
            }))
        
        if parentEmail == ""{
        }else{
            alert.addAction(UIAlertAction(title: "Email", style: .default, handler: { _ in
                // function here
                self.Email()
            }))
        }
        
        if parentTelephone == "" {
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
            
            
            chatLogControllerOne.stringOfProfileUid = parentId
            chatLogControllerOne.stringOfProfileName = parentUserName
            chatLogControllerOne.stringOfProfileImageView = parentImage
            
            print(parentImage)
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
            let toRecipients = [parentEmail]
            
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
            messageController.recipients = [parentTelephone]
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
    
    // for adjusting text field distance from bottom
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat = -200
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if textField == inputFirstName {
            inputLastName.becomeFirstResponder()
        }
        if textField == inputLastName {
            inputAge.becomeFirstResponder()
        }
        
        if textField == inputAge{
            textField.resignFirstResponder()
        }
        
        return true
    }
        //end-------
 
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
