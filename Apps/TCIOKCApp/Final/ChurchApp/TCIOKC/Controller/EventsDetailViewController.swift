//
//  EventsDetailViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 1/12/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MapKit
import Social
import EventKitUI

class EventsDetailViewController: UIViewController, UINavigationControllerDelegate{
  
    
    

    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventDetail: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventEndTime: UILabel!
    @IBOutlet weak var eventAttendButon: UIButton!
    
    
    @IBOutlet weak var attendingNumber: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var eventImageShadow: UIView!
    @IBOutlet weak var eventLocationDetails: UILabel!
    
    //@IBOutlet weak var editEventButton: UIBarButtonItem!
    
    @IBOutlet weak var eventDetailPad: UIView!
    @IBOutlet var showEventDetailImage: UITapGestureRecognizer!
    
    //@IBOutlet weak var eventSimilarPad: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var eventDatabase: Event!
    var liveEvent: Event!
    var attending = false
    var eImage = ""
    var eTitle = ""
    var eDetail = ""
    var eDate = ""
    var eStartDate = ""
    var eEndDate = ""
    var eventDateAsDateFormat = Date()
    var eStartTime = ""
    var eEndTime = ""
    var eCount = 0
    var eLocation = ""
    var selectedButton = false
    var theNewAttendees: [Event] = []
    var regularEventStartDate = ""
    var regularEventEndDate = ""
    var administrator = ""
    var eventKey = ""
    @IBAction func unwindToEventDetailController(segue: UIStoryboardSegue){
        
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    // for Firebase
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfProfileUid = ""
    
    var usersRef = FIRDatabase.database().reference(withPath: "users")
    
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        eImage = liveEvent.eventImage!
        eTitle = liveEvent.eventTitle
        eDetail = liveEvent.eventDescription
        eStartDate = liveEvent.eventStartDate
        eDate = liveEvent.eventdate
        eEndDate = liveEvent.eventEndDate
        eStartTime = liveEvent.eventStartTime
        eEndTime = liveEvent.eventEndTime
        eCount = liveEvent.peopleGoing
        eLocation = liveEvent.eventLocation
        regularEventStartDate = liveEvent.regularEventStartDate
        regularEventEndDate = liveEvent.regularEventEndDate
        
        eventDetailPad.layer.cornerRadius = 4
        //eventSimilarPad.layer.cornerRadius = 4
        
        if FIRAuth.auth()?.currentUser?.uid == administrator {
            self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editEvent) ), animated: true)
            
        }else{
            
        }
        
        let ref = FIRDatabase.database().reference().child("events/\(eTitle.lowercased())")
        
        
        let newRef = FIRDatabase.database().reference().child("events").child(self.eventKey).child("peopleGoing")
        
        // Do any additional setup after loading the view.
        // this listens for changes in the values of the database (added, removed, changed)
        //1 - reviews data
        // queryOrdered(byChild:) allows to arrange children in list by "style"
        
        newRef.observe(.value, with: {snapshot in
            
            print("This is the snapshot: \(snapshot)")
            //2 new items are an empty array
            
            var newCounts = 0
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            //}
            
            // 5 - the main "events" are now the adjusted "newEvents"
            //self.events = newEvents
            
            //self.variousItems = newSocialPosts
            //print("the new various Items: \(self.variousItems)")
            
            newCounts = snapshot.value as! Int
            self.eCount = newCounts
            self.attendingNumber.text = "People Going: \(self.eCount)"
            print("Your attendees: \(self.eCount)")
            
            self.view.reloadInputViews()
        })
        
        eventImageShadow.layer.shadowOpacity = 0.5
        eventImageShadow.layer.shadowOffset = CGSize.zero
        eventImageShadow.layer.shadowRadius = 5.0
        eventImageShadow.layer.masksToBounds = false
        
        
        eventDetailPad.layer.shadowOpacity = 0.5
        eventDetailPad.layer.shadowOffset = CGSize.zero
        eventDetailPad.layer.shadowRadius = 5.0
        
        //eventSimilarPad.layer.shadowOpacity = 0.5
        //eventSimilarPad.layer.shadowOffset = CGSize.zero
        //eventSimilarPad.layer.shadowRadius = 5.0
        //eventDetailPad.layer.masksToBounds = false
        mapView.layer.borderWidth = 0.5
        mapView.layer.borderColor = #colorLiteral(red: 0.4364677785, green: 0.4364677785, blue: 0.4364677785, alpha: 1)
        mapView.layer.cornerRadius = 4
        
       self.navigationItem.hidesBackButton = true
        
         navigationController?.delegate = self

        
        eventImage.loadImageUsingCacheWithURLString(urlString: eImage)
    
        //eventImage.image = UIImage(named: eImage)
        eventTitle.text = eTitle
        eventDetail.text = eDetail
        eventTime.text = eStartTime
        eventEndTime.text = eEndTime
        eventDate.text = eDate
        //eventEndDate.text = eEndDate
        eventAttendButon.backgroundColor = UIColor.gray
        
        
        
        let eImageS = 275
        let eTitleS = 29
        let eStartDateS = 22
        let eTimeS = 20
        let aNumberS = 20
        let eAttendButonS = 50
        
        self.reloadInputViews()
        
        
        
        eventImage.frame.size.height = CGFloat(eImageS)
        eventTitle.frame.size.height = CGFloat(eTitleS)
        eventDate.frame.size.height = CGFloat(eStartDateS)
        eventTime.frame.size.height = CGFloat(eTimeS)
        attendingNumber.frame.size.height = CGFloat(aNumberS)
        eventAttendButon.frame.size.height = CGFloat(eAttendButonS)
        eventAttendButon.layer.cornerRadius = 25
        
        
        
        print(UserDefaults())
        if UserDefaults.standard.bool(forKey: "\(ref)attending") {
            eventAttendButon.backgroundColor = #colorLiteral(red: 0.3395062974, green: 0.874027315, blue: 0.9768045545, alpha: 1)
            eventAttendButon.setTitle("I'm Going!", for: .normal)
            attending = true
        }else {
            eventAttendButon.backgroundColor = UIColor.gray
            eventAttendButon.setTitle("Interested?", for: .normal)
            attending = false
        }
        // Do any additional setup after loading the view.
        fetchUserAndSetupNavBarTitle()
        self.reloadInputViews()
        
        // for mapKit
        //let coordinate = placemark.lcation?.coordinate
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(eLocation, completionHandler: {
            placemarks, error in
            if error != nil {
                print(error!)
                return
            }
            if let placemarks = placemarks {
                // get the first placemark
                let placemark = placemarks[0]
                
                // Add annotation
                let annotation = MKPointAnnotation()
                
                if let location = placemark.location {
                    // Display the annotation
                    annotation.coordinate =  location.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    // Set the zoom level
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: false)
                }
            }
        })
        
        //end--------
        eventLocationDetails.text = eLocation
    }
    
    
    
    
    
    
    // reloading the view with constraints and new size based on the eventDetail height
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        contentView.frame.size = CGSize( width:375 , height:645 + eventDetail.frame.size.height )
        
        contentView.heightAnchor.constraint(equalToConstant: 795 + eventDetail.frame.size.height ).isActive = true
        
        // for the event detail height
       // eventDetailPad.frame.size.height = 200 + eventDetail.frame.size.height
        
        print(contentView.frame.size.height)
        print("constraint size: \(contentView.heightAnchor.constraint(equalToConstant: 700 + eventDetail.frame.size.height ))")
       
        self.reloadInputViews()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    @IBAction func showEventDetailImage(_ sender: Any) {
        performSegue(withIdentifier: "ShowImageDetail", sender: self)
    }
    
    
    @IBAction func attendingButton(_ sender: Any) {
       
        
        if attending == false {
            self.attending = true
            eventAttendButon.backgroundColor = #colorLiteral(red: 0.3395062974, green: 0.874027315, blue: 0.9768045545, alpha: 1)
            eventAttendButon.setTitle("I'm Going!", for: .normal)
            
            let ref = FIRDatabase.database().reference().child("events/\(eTitle.lowercased())")
            
            //eCount = eCount + 1
            attendingNumber.text = "People Going: \(eCount)"
            
            // adds to count
            let updateAttending = ["peopleGoing": eCount + 1]
            ref.updateChildValues(updateAttending)
            
            UserDefaults.standard.set(true, forKey: "\(ref)attending")
            print(UserDefaults.standard.bool(forKey: "\(ref)attending"))
            self.view.reloadInputViews()
            
            
            //for FirebaseUser
            // adds the whole post to the user for display in user page
            let thisPostItem = Event(eventImage: self.eImage, eventIcon: "", eventTitle: self.eTitle, eventSubtitle: "", eventDescription: self.eDetail, eventdate: eDate, eventStartTime: self.eStartTime, eventEndTime: self.eEndTime, regularEventStartDate: self.regularEventStartDate, regularEventEndDate: self.regularEventEndDate, eventStartDate: eStartDate, eventEndDate: eEndDate, eventLocation: eLocation, peopleGoing: self.eCount)
            
        
            //this goes to user set of data not database.
            let nextItemRef = self.usersRef.child(self.stringOfProfileUid).child("MyParticipation").child("AttendingEvents").child(self.eTitle.lowercased())
            
            nextItemRef.setValue(thisPostItem.toAnyObject())
            
            print("successfully stored event into Firebase DB")
            
            self.view.endEditing(true)
            
            // adds to calendar
           
            // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
            
            let isoStartDate = self.eStartDate
            let isoEndDate = self.eEndDate
            
            // date converter...
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
            
            let startDate = dateFormatter.date(from:isoStartDate)!
            let calendar = Calendar.current
            let startComponents = calendar.dateComponents([.year, .month, .day, .hour], from: startDate)
            
            
            let thisStartDate = calendar.date(from:startComponents)
            
            
            let endDate = dateFormatter.date(from:isoEndDate)!
            let endComponents = calendar.dateComponents([.year, .month, .day, .hour], from: endDate)
            let thisEndDate = calendar.date(from:endComponents)
            
            // end....
            addEventToCalendar(title: self.eTitle, description: self.eDetail, startDate: thisStartDate!, endDate: thisEndDate!, location: eLocation)
            print("title: \(self.eTitle), description: \(self.eDetail), startDate: \(thisStartDate!), endDate: \(thisEndDate!)")
            
            let alert = UIAlertController(title: "Events Notification", message: "This event has been added to your calendar.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Close", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else if attending == true {
            
            let ref = FIRDatabase.database().reference().child("events/\(eTitle.lowercased())")
            
            // subtracts from count
            let updateAttending = ["peopleGoing": eCount - 1]
            ref.updateChildValues(updateAttending)
            
            
            eventAttendButon.backgroundColor = UIColor.gray
            eventAttendButon.setTitle("Interested?", for: .normal)
            
            self.attending = false
            //eCount = eCount - 1
            attendingNumber.text = "People Going: \(eCount)"
            
            attending = false
            UserDefaults.standard.set(false, forKey: "\(ref)attending")
            print(UserDefaults.standard.bool(forKey: "\(ref)attending"))
            self.view.reloadInputViews()
            
            //for FirebaseUser
            
            let nextItemRef = self.usersRef.child(stringOfProfileUid).child("MyParticipation").child("AttendingEvents").child(self.eTitle.lowercased())
            
            nextItemRef.removeValue()
            
            print("successfully removed event from Firebase DB")
            
            self.view.reloadInputViews()
            
            
        }
        
        //end-------------
        
        
        }
    
    // call to calendar
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, location: String, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.location = location
                event.calendar = eventStore.defaultCalendarForNewEvents
              
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    
    
    //Share
    
    @IBAction func shareButton(_ sender: Any) {
        let shareMenu = UIAlertController(title: nil, message: "Share using", preferredStyle: .actionSheet)
        let twitterAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default) { (action) in
            
            // Check if twitter is available. Otherwise display an error message
            guard SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) else {
                let alertMessage = UIAlertController(title: "Twitter Unavailable", message: "You haven't registered your Twitter account. Please go to Settings > Twitter to create one.", preferredStyle: .alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertMessage, animated: true, completion: nil)
                return
            }
            
            // display Tweet Composer
            if let tweetComposer = SLComposeViewController(forServiceType: SLServiceTypeTwitter) {
                tweetComposer.setInitialText("Check out this upcoming event! " + self.eTitle)
                tweetComposer.add(UIImage(named: self.eImage))
                self.present(tweetComposer, animated: true, completion: nil)
            }
        }
        
        
        let facebookAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.default) { (action) in
            
            // Check if facebook is available. Otherwise display an error message
            guard SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) else {
                let alertMessage = UIAlertController(title: "Facebook Unavailable", message: "You haven't registered your Facebook account. Please go to Settings > Facebook to create one.", preferredStyle: .alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertMessage, animated: true, completion: nil)
                return
            }
            
            // display Tweet Composer
            if let fbComposer = SLComposeViewController(forServiceType: SLServiceTypeFacebook) {
                fbComposer.setInitialText("Check out this upcoming event! " + self.eTitle)
                fbComposer.add(UIImage(named: self.eImage))
                self.present(fbComposer, animated: true, completion: nil)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        shareMenu.addAction(twitterAction)
        shareMenu.addAction(facebookAction)
        shareMenu.addAction(cancelAction)
        
        self.present(shareMenu, animated: true, completion: nil)
    }
    //end--------
    
    
    
    
    // for map
    
    @IBAction func mapClick(_ sender: Any) {
        performSegue(withIdentifier: "ShowMap", sender: self)
        
    }
    //end----------

    @objc func editEvent(){
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "EditEvent") as!
        AddEventViewController
        
        destinationController.isEditingEvent = true
        destinationController.editDetails = liveEvent
        destinationController.eventKey = eventKey
        
        self.navigationController?.show(destinationController, sender: self)
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let newRef = FIRDatabase.database().reference().child("events").child(eventKey).child("peopleGoing")
        newRef.removeAllObservers()
        print("listeners removed!")
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowMap" {
            let destinationController = segue.destination as! EventMapViewViewController
            destinationController.eventTitle = self.eTitle
            destinationController.eventLocation = self.eLocation
            destinationController.eventAttendees = self.eCount
            destinationController.eventImage = self.eImage
           
        }
        if segue.identifier == "ShowImageDetail" {
            let destinationController = segue.destination as! EventsImageDetailViewController
            destinationController.detailImage = eImage
        }
    }
    

}




