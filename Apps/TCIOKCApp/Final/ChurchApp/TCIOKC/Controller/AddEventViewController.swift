//
//  AddEventViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 1/23/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class AddEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var eventImage: UIImageView!
    
    @IBOutlet weak var eventTitle: UITextField!
    
    
    @IBOutlet weak var eventStartDate: UITextField!
    
    
    @IBOutlet weak var eventEndDate: UITextField!
    
    @IBOutlet weak var eventLocation: UITextField!
    
    @IBOutlet weak var eventDetails: UITextView!
    
    @IBOutlet weak var postEventButton: UIButton!
    
    @IBOutlet weak var imageFilter: UIImageView!
    
    @IBOutlet weak var eventUploadImageIcon: UIImageView!
    
    @IBOutlet weak var deletePostButton: UIButton!
    
    
    var editDetails : Event!
    
    var isEditingEvent = false
    
    var eEditImage = ""
    var eEditTitle = ""
    var eEditStartDate = ""
    var eEditEndDate = ""
    var eEditLocation = ""
    var eEditDetails = ""
    var peopleGoing = 0
    var eventDate = ""
    var eventStartTime = ""
    var eventEndTime = ""
    var eventCategory = ""
    var regularEventStartDate = ""
    var regularEventEndDate = ""
    var eventKey = ""
    
    
    var data = MinistryData()
    var events: [Event] = []
    var user: ChurchUser!
    let ref = FIRDatabase.database().reference(withPath: "events")
    var frameView: UIView!
    var thisEventDate: String? = ""
    var thisEventRegularDate: String? = ""
    let imagePicker = UIImagePickerController()
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imagePicker.delegate = self
        // hides keyboard when tapped anywhere
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
        eventTitle.delegate = self
        eventStartDate.delegate = self
        eventEndDate.delegate = self
        eventLocation.delegate = self
        eventDetails.delegate = self
        
        if isEditingEvent == true {
            self.deletePostButton.isHidden = false
            eEditImage = editDetails.eventImage!
            eEditTitle = editDetails.eventTitle
            eventDate = editDetails.eventdate
            eventStartTime = editDetails.eventStartTime
            eventEndTime = editDetails.eventEndTime
            eEditStartDate = editDetails.eventStartDate
            eEditEndDate = editDetails.eventEndDate
            eEditLocation = editDetails.eventLocation
            eEditDetails = editDetails.eventDescription
            peopleGoing = editDetails.peopleGoing
            regularEventStartDate = editDetails.regularEventStartDate
            regularEventEndDate = editDetails.regularEventEndDate
            
            eventTitle.text = eEditTitle
            eventStartDate.text = eEditStartDate
            eventEndDate.text = eEditEndDate
            eventLocation.text = eEditLocation
            eventDetails.text = eEditDetails
            eventImage.loadImageUsingCacheWithURLString(urlString: eEditImage)
            imageFilter.isHidden = true
            eventUploadImageIcon.isHidden = true
            
        } else {
            self.deletePostButton.isHidden = true
        }
        
        
        
        postEventButton.layer.cornerRadius = 20
        deletePostButton.layer.cornerRadius = 20
        
        let startDatePickerView: UIDatePicker = UIDatePicker()
        //datePickerView.datePickerMode = UIDatePickerMode.date
        eventStartDate.inputView = startDatePickerView
       
        
        startDatePickerView.addTarget(self, action: #selector(self.startDatePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let endDatePickerView: UIDatePicker = UIDatePicker()
        //datePickerView.datePickerMode = UIDatePickerMode.date
        eventEndDate.inputView = endDatePickerView
        
        
        endDatePickerView.addTarget(self, action: #selector(self.endDatePickerValueChanged), for: UIControlEvents.valueChanged)
       
        
        
        // Firebase Auth//
        
        // this listens for changes in the values of the database (added, removed, changed)
        //1 - reviews data
        // queryOrdered(byChild:) allows to arrange children in list by "style"
        ref.queryOrdered(byChild: "eventTitle").observe(.value, with: {snapshot in
            
            //2 new items are an empty array
            var newEvents: [Event] = []
            
            //3 - for every item in snapshot as a child, the groceryItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                let eventItem = Event(snapshot: item as! FIRDataSnapshot)
                newEvents.insert(eventItem, at: 0)
                
            }
            
            // 5 - the main "events" are now the adjusted "newBlogs"
            self.events = newEvents
            
            
        })
        
    }

    
    // for adjusting text field distance from bottom
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat = -130
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
    
    
    func animateTextView(textView: UITextView, up: Bool)
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
    
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        self.animateTextView(textView: textView, up: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        self.animateTextView(textView: textView, up:false)
    }
    
    
    // for date picker...
    
    // Make a dateFormatter in which format you would like to display the selected date in the textfield.
    
    // for date
    @objc func startDatePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        eventStartDate.text = DateFormatter.localizedString(from: sender.date, dateStyle: .full, timeStyle: .short)
        
        //for the date
        let thisDateFormatter = DateFormatter()
        let thisTimeFormatter = DateFormatter()
        let thisEntireDateFormatter = DateFormatter()
        thisDateFormatter.dateFormat = "MM/dd/yyyy"
        thisEntireDateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        
        eventStartDate.text = thisEntireDateFormatter.string(from: sender.date)
        
        
        
        thisEventDate = thisDateFormatter.string(from: sender.date)
        print(thisEventDate!)
        
        let regularDateFormatter = DateFormatter()
        regularDateFormatter.dateStyle = .medium
        
        eEditStartDate = regularDateFormatter.string(from: sender.date)
        regularEventStartDate = regularDateFormatter.string(from: sender.date)
        thisEventRegularDate = regularDateFormatter.string(from: sender.date)
        eventDate = thisDateFormatter.string(from: sender.date)
        
        // for the time
        thisTimeFormatter.timeStyle = .short
        eventStartTime = thisTimeFormatter.string(from: sender.date)
        
        
        
    }
    
    @objc func endDatePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        //eventEndDate.text = DateFormatter.localizedString(from: sender.date, dateStyle: .full, timeStyle: .short)
        
        //for the full date
        let thisDateFormatter = DateFormatter()
        let thisEntireDateFormatter = DateFormatter()
        let thisTimeFormatter = DateFormatter()
        thisDateFormatter.dateFormat = "MM/dd/yyyy"
        thisEntireDateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        
        eventEndDate.text = thisEntireDateFormatter.string(from: sender.date)
        
        thisEventDate = thisDateFormatter.string(from: sender.date)
        print(thisEventDate!)
        
        let regularDateFormatter = DateFormatter()
        regularDateFormatter.dateStyle = .medium
        
        eEditEndDate = regularDateFormatter.string(from: sender.date)
        regularEventEndDate = regularDateFormatter.string(from: sender.date)
        thisEventRegularDate = regularDateFormatter.string(from: sender.date)
        
        // for the time
        thisTimeFormatter.timeStyle = .short
        eventEndTime = thisTimeFormatter.string(from: sender.date)
        
    }
    
   /* // for time picker
    @objc func timePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        eventTime.text = dateFormatter.string(from: sender.date)
        
    }
    
    // for end time picker
    @objc func endTimePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        eventEndTime.text = dateFormatter.string(from: sender.date)
        
    }
    */
    
    
    
    // end of date picker



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
            eventImage.image = selectedImage
            eventImage.contentMode = .scaleAspectFill
            eventImage.clipsToBounds = true
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    

   
    @IBAction func postEventButton(_ sender: Any) {
        if isEditingEvent == true{
            // for the editing data
            if eventTitle.text == "" || eventStartDate.text == "" || eventEndDate.text == ""  {
                let alert = UIAlertController(title: "Error", message: "Please fill in the blanks", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            } else {
                
                print("has passed checkpoint 1")
                let imageName = NSUUID().uuidString
                //create a storage reference from our storage service
                let storageRef = FIRStorage.storage().reference().child("Events").child("\(imageName).jpg")
                
                
                if let thisEventImage = self.eventImage.image, let uploadData = UIImageJPEGRepresentation(thisEventImage, 0.1){
                    //if let uploadData = UIImagePNGRepresentation(self.eventImage.image!){
                    storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                        guard let metadata = metadata else{
                            
                            print(error!)
                            return
                        }
                        
                        let downloadURL = metadata.downloadURL()
                        print(downloadURL!)
                        
                        
                        //event title
                        guard let titleField = self.eventTitle,
                            let eTitle = titleField.text else { return }
                        
                        //event start date
                        guard let startDateField = self.eventStartDate,
                            let eEditStartDate = startDateField.text else { return }
                        
                        //event end date
                        guard let endDateField = self.eventEndDate,
                            let eEditEndDate = endDateField.text else { return }
                        
                        /*event time
                        guard let timeField = self.eventTime,
                            let eTime = timeField.text else { return }
                        
                        //event end time
                        guard let endTimeField = self.eventEndTime,
                            let eEndTime = endTimeField.text else { return }
                        */
                        
                        //event location
                        guard let locationField = self.eventLocation,
                            let eLocation = locationField.text else { return }
                        
                        //event text
                        guard let messageField = self.eventDetails,
                            let eMessage = messageField.text else { return }
                        
                        
                        
                        //blog formatted items needed for the array
                        let eventItem = Event(eventImage: "\(downloadURL!)" , eventIcon: "", eventTitle: eTitle, eventSubtitle: "", eventDescription: eMessage, eventdate: self.eventDate, eventStartTime: self.eventStartTime, eventEndTime: self.eventEndTime, regularEventStartDate: self.regularEventStartDate, regularEventEndDate: self.regularEventEndDate, eventStartDate: eEditStartDate, eventEndDate: eEditEndDate, eventLocation: eLocation, peopleGoing: self.peopleGoing)
                        
                        
                        //self.blogs.insert(blogItem, at: 0)
                        let eventItemRef = self.ref.child(eTitle.lowercased())
                        eventItemRef.setValue(eventItem.toAnyObject())
                        
                        
                        print(self.eventImage!, self.eventTitle.text!, self.eventStartDate.text!, self.eventEndDate.text!, self.eventLocation.text!, self.eventDetails.text!)
                        
                        
                        self.performSegue(withIdentifier: "unwindToEventsWithSegue", sender: self)
                    })
                }
                print("has passed checkpoint 3")
                
                print("successfully stored event into Firebase DB")
                
            }
        }else{
            if eventTitle.text == "" || eventStartDate.text == "" || eventEndDate.text == ""  {
                    let alert = UIAlertController(title: "No Title", message: "Please add needed text", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default)
            
                    alert.addAction(okAction)
                    present(alert, animated: true, completion: nil)
            
                } else {
            
                    print("has passed checkpoint 1")
                    let imageName = NSUUID().uuidString
                    //create a storage reference from our storage service
                    let storageRef = FIRStorage.storage().reference().child("Events").child("\(imageName).jpg")
            
            
                    if let thisEventImage = self.eventImage.image, let uploadData = UIImageJPEGRepresentation(thisEventImage, 0.1){
                        //if let uploadData = UIImagePNGRepresentation(self.eventImage.image!){
                        storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                            guard let metadata = metadata else{
                
                                print(error!)
                                return
                            }
                            
                            let downloadURL = metadata.downloadURL()
                            print(downloadURL!)
                
                
                            //event title
                            guard let titleField = self.eventTitle,
                    let eTitle = titleField.text else { return }
                 
                            //event start date
                            guard let startDateField = self.eventStartDate,
                                let eStartDate = startDateField.text else { return }
                            
                            //event end date
                            guard let endDateField = self.eventEndDate,
                                let eEndDate = endDateField.text else { return }
                            
                            /*event time
                            guard let timeField = self.eventTime,
                                let eTime = timeField.text else { return }
                 
                            //event end time
                            guard let endTimeField = self.eventEndTime,
                                let eEndTime = endTimeField.text else { return }
 
                            */
                            
                            //event location
                            guard let locationField = self.eventLocation,
                                let eLocation = locationField.text else { return }
                 
                            //event text
                            guard let messageField = self.eventDetails,
                                let eMessage = messageField.text else { return }
                
               
                
                            //blog formatted items needed for the array
                            let eventItem = Event(eventImage: "\(downloadURL!)" , eventIcon: "", eventTitle: eTitle, eventSubtitle: "", eventDescription: eMessage, eventdate: self.eventDate, eventStartTime: self.eventStartTime, eventEndTime: self.eventEndTime, regularEventStartDate: self.regularEventStartDate, regularEventEndDate: self.regularEventEndDate, eventStartDate: eStartDate, eventEndDate: eEndDate, eventLocation: eLocation, peopleGoing: self.peopleGoing)
                
                
                            //self.blogs.insert(blogItem, at: 0)
                            let eventItemRef = self.ref.child(eTitle.lowercased())
                            eventItemRef.setValue(eventItem.toAnyObject())
                
                
                            print(self.eventImage!, self.eventTitle.text!, self.eventStartDate.text!, self.eventEndDate.text!, self.eventLocation.text!, self.eventDetails.text!)
                
                
                            self.performSegue(withIdentifier: "unwindToEventsWithSegue", sender: self)
                        })
                    }
                    print("has passed checkpoint 3")
         
                    print("successfully stored event into Firebase DB")
            
        
            
                }
        }
    }
     
    @IBAction func categorySelectButton(_ sender: Any) {
        performSegue(withIdentifier: "ShowCategories", sender: self)
    }
    
    @IBAction func deletePostButton(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Delete Post", message: "Are you sure you want to delete this post?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Close", style: .default) { action in
        }
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { action in
            
            self.performSegue(withIdentifier: "unwindToEventsAndDelete", sender: self)
        }
        
        // actions of the alert controller
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        if isEditingEvent == true{
            performSegue(withIdentifier: "unwindToEventDetailController", sender: self)
        }
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     
        
        if textField == eventTitle {
            eventStartDate.becomeFirstResponder()
        }
        if textField == eventStartDate {
            eventEndDate.becomeFirstResponder()
        }
        if textField == eventEndDate {
            eventLocation.becomeFirstResponder()
        }
        if textField == eventLocation{
            textField.resignFirstResponder()
        }
        
        return true
    }

}


