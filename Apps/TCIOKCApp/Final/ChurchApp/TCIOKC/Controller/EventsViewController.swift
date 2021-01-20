//
//  EventsViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 1/11/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import iCarousel

class EventsViewController: UIViewController, iCarouselDelegate, iCarouselDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var caroselView: iCarousel!
    
    @IBOutlet weak var noInternetConnectionView: UIView!
    
    @IBOutlet weak var noEventsView: UIView!
    
    var data = MinistryData()
    var events: [Event] = []
    
    var user: ChurchUser!
    var administrator = ""
    var associate = ""
    var regular = ""
    var attendees = 0
    
    let ref = FIRDatabase.database().reference(withPath: "events")

    var thisEventDate : [String] = []
    
    
    
    @IBAction func unwindToEvents(segue: UIStoryboardSegue){
        self.caroselView.reloadData()
        
        /*if segue.source is EventsDetailViewController{
            if let receivingDestination = segue.source as? EventsDetailViewController {
                let ref = FIRDatabase.database().reference().child("events/\(receivingDestination.eTitle.lowercased())")
        
                let post = ["peopleGoing": receivingDestination.eCount]
                ref.updateChildValues(post)
                attendees = receivingDestination.eCount
                self.caroselView.reloadData()
                print("unwinded \(attendees) attendees")
            }
        }
 */
        
    }
    
    @IBAction func unwindToEventsAndDelete(segue: UIStoryboardSegue){
        
        let receivingDestination = segue.source as! AddEventViewController
        let key = receivingDestination.eventKey
        
        let eventRef = FIRDatabase.database().reference(withPath: "events").child(key)
        eventRef.removeValue()
        self.view.reloadInputViews()
        self.caroselView.reloadData()
        /*if segue.source is EventsDetailViewController{
         if let receivingDestination = segue.source as? EventsDetailViewController {
         let ref = FIRDatabase.database().reference().child("events/\(receivingDestination.eTitle.lowercased())")
         
         let post = ["peopleGoing": receivingDestination.eCount]
         ref.updateChildValues(post)
         attendees = receivingDestination.eCount
         self.caroselView.reloadData()
         print("unwinded \(attendees) attendees")
         }
         }
         */
        
    }

    var eventImage: UIImageView!
    var eventImageOverlay: UIView!
    var eventTitle: UILabel!
    var eventDate: UILabel!
    var eventTime: UILabel!
    var eventRatingOne: UIImageView!
    var eventRatingTwo: UIImageView!
    var eventRatingThree: UIImageView!
    var eventRatingFour: UIImageView!
    var eventRatingFive: UIImageView!
    var eventSubtext: UILabel!
    var eventButton: UIButton!
    var likeButton: UIButton!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if events.isEmpty == true{
            noEventsView.isHidden = false
        } else if events.isEmpty == false{
            noEventsView.isHidden = true
        }
        if FIRAuth.auth()?.currentUser?.uid == self.administrator {
            //add the user defaults here....
            
        }
        
        if UserDefaults.standard.bool(forKey: "hasViewedEventsWalkthrough"){
            return
        }
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            present(pageViewController, animated: true, completion: nil)
            
            pageViewController.viewingEventsWalkthrough = true
        }
        
        self.caroselView.reloadData()
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    noEventsView.isHidden = true
        
        //caroselView.type = .rotary
        // Do any additional setup after loading the view.
        // for bar button item
        
        // this listens for changes in the values of the database (added, removed, changed)
        //1 - reviews data
        // queryOrdered(byChild:) allows to arrange children in list by "style"
        ref.queryOrdered(byChild: "eventdate").observe(.value, with: {snapshot in
            
            print(snapshot)
            //2 new items are an empty array
            var newEvents: [Event] = []
            
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                
                let eventItem = Event(snapshot: item as! FIRDataSnapshot)
                newEvents.append(eventItem)
                
            }
            
            // 5 - the main "events" are now the adjusted "newEvents"
            //self.events = newEvents
            
            var pendingEvents : [Event] = []
            pendingEvents = newEvents
            for item in pendingEvents{
                
                let formatter = DateFormatter()
                formatter.dateFormat = "MM/dd/yyyy"
                //let firstDate = formatter.date(from: "10/08/2017")
                //let secondDate = formatter.date(from: "10/08/2017")
                
                let date1 = formatter.string(from: Date())
                let date2 = item.eventdate //formatter.date(from: item.eventdate)
                
                
                if date1 < date2 {
                    //do something
                    print("the event has not come yet")
                    self.thisEventDate.append("\(item.eventdate)")
                }else if date1 == date2{
                    //do something
                    print("the event is today")
                    self.thisEventDate.append("the event is today")
                    
                }else if date1 > date2 {
                    //do something
                    print("this event now over")
                    self.thisEventDate.append("this event is now over")
                }
            }
            
            self.events = pendingEvents
            self.caroselView.reloadData()
            
            self.checkIfUserIsLoggedIn()
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.caroselView.reloadData()
    }
    
    
    func checkIfUserIsLoggedIn(){
        
        if FIRAuth.auth()?.currentUser?.uid == self.administrator {
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
            button.addTarget(self, action:#selector(informationButton), for:.touchUpInside)
            button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
            let barButton = UIBarButtonItem.init(customView: button)
            //self.navigationItem.rightBarButtonItem = barButton
            barButton.tintColor = UIColor.blue
            
            let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEvent))
            
            self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem, barButton], animated: true)
            
        } else {
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
            button.addTarget(self, action:#selector(informationButton), for:.touchUpInside)
            button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
            let barButton = UIBarButtonItem.init(customView: button)
            self.navigationItem.rightBarButtonItem = barButton
            barButton.tintColor = UIColor.blue
            
           
            
           
        }
    }
    
    @objc func addEvent(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddEventViewController") as UIViewController
        
        //self.present(controller, animated: true, completion: nil)
        show(controller, sender: self)
    }
    
    
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        print("here is the final counts: \(events.count)")
        return events.count
    }
    
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let containerWidth = 290
        let containerHeight = 530 // was 620
        let containerY = 40
        
        
        let tempView = UIView(frame: CGRect(x: 0, y: containerY, width: containerWidth, height: containerHeight))
        
        //  var itemView: UIImageView
        
        // main container
        tempView.backgroundColor = UIColor.clear
        tempView.layer.cornerRadius = 8.0
        tempView.layer.borderWidth = 1.0
        tempView.layer.borderColor = UIColor.clear.cgColor
        tempView.layer.masksToBounds = true
        //let margins = view?.layoutMarginsGuide
        
        
        var iphoneSize = Int()
        iphoneSize = 390 // was 470
        // BackgroundPad
        let backgroundView = UIButton(frame: CGRect(x: 0, y: 100, width: 280, height: iphoneSize))
        
        backgroundView.backgroundColor = UIColor.white
        backgroundView.layer.cornerRadius = 10.0
        backgroundView.layer.borderWidth = 0.03
        backgroundView.layer.borderColor = UIColor.clear.cgColor
        backgroundView.layer.masksToBounds = false
        backgroundView.layer.shadowOpacity = 0.5
        backgroundView.layer.shadowOffset = CGSize.zero
        backgroundView.layer.shadowRadius = 5.0
        backgroundView.center.x = tempView.center.x
        //backgroundView.layer.shadowPath = UIBezierPath(rect: backgroundView.bounds).cgPath
        backgroundView.layer.shouldRasterize = true
        if thisEventDate[index] == "this event is now over"{
            if FIRAuth.auth()?.currentUser?.uid == administrator{
                backgroundView.addTarget(self, action: #selector(self.pressed), for: .touchUpInside)
            }else{
                
            }
        }else{
            backgroundView.addTarget(self, action: #selector(self.pressed), for: .touchUpInside)
        }
        backgroundView.tag = index
        tempView.addSubview(backgroundView)
        //first level
        
        
        let imageHeight = 374 // was 454
        let imageWidth = 265
        let imageY = 108
        // for image drop shaddow
        /*let imageBackPadding = UIView(frame: CGRect(x: 0, y: imageY, width: imageWidth, height: imageHeight))
        
        imageBackPadding.backgroundColor = UIColor.white
        imageBackPadding.layer.cornerRadius = 8.0
        imageBackPadding.layer.borderWidth = 0.03
        imageBackPadding.layer.borderColor = UIColor.clear.cgColor
        imageBackPadding.layer.masksToBounds = false
        imageBackPadding.layer.shadowOpacity = 0.5
        imageBackPadding.layer.shadowOffset = CGSize.zero
        imageBackPadding.layer.shadowRadius = 5.0
        imageBackPadding.center.x = backgroundView.center.x
        //backgroundView.layer.shadowPath = UIBezierPath(rect: backgroundView.bounds).cgPath
        imageBackPadding.layer.shouldRasterize = true
        tempView.addSubview(imageBackPadding)
        
        */
        
         //else if eventImage == nil {
         //eventImage.image = UIImage(named: "Event4")
         //}
        
        
        //eventImage.topAnchor.constraint(equalTo: (margins?.topAnchor)!).isActive = true
    
        
        
        eventImage = UIImageView(frame: CGRect(x: 0, y: imageY, width: imageWidth, height: imageHeight))
        eventImage.image = UIImage(named: "Event4")
        eventImage.contentMode = .scaleAspectFill
        eventImage.layer.cornerRadius = 8.0
        eventImage.clipsToBounds = true
        eventImage.layer.shadowOpacity = 0.5
        eventImage.layer.shadowOffset = CGSize.zero
        eventImage.layer.shadowRadius = 5.0
        eventImage.layer.shouldRasterize = true
        eventImage.center.x = backgroundView.center.x
        //eventImage.topAnchor.constraint(equalTo: (margins?.topAnchor)!).isActive = true

        if let eventImageUrl = events[index].eventImage {
            eventImage.loadImageUsingCacheWithURLString(urlString: eventImageUrl)
        }
        tempView.addSubview(eventImage)
        
        
        eventImageOverlay = UIImageView(frame: CGRect(x: 0, y: imageY, width: imageWidth, height: imageHeight))
        eventImageOverlay.contentMode = .scaleAspectFill
        eventImageOverlay.layer.cornerRadius = 8.0
        eventImageOverlay.clipsToBounds = true
        if thisEventDate[index] == "this event is now over"{
            eventImageOverlay.layer.shadowOpacity = 0.9
        }else {
            eventImageOverlay.layer.shadowOpacity = 0.5
        }
      
        eventImageOverlay.layer.shadowOffset = CGSize.zero
        eventImageOverlay.layer.shadowRadius = 5.0
        eventImageOverlay.layer.shouldRasterize = true
        eventImageOverlay.center.x = backgroundView.center.x
        if thisEventDate[index] == "this event is now over"{
            eventImageOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        }else{
            eventImageOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
        
        
        tempView.addSubview(eventImageOverlay)
        
        
        //second level
        eventTitle = UILabel(frame: CGRect(x: 0, y: 300, width: 265, height: 55))
        eventTitle.backgroundColor = .clear
        if thisEventDate[index] == "this event is now over"{
            eventTitle.textColor = UIColor.red
        }else{
            eventTitle.textColor = UIColor.white
        }
        eventTitle.font = UIFont.boldSystemFont(ofSize: 22.0)
        eventTitle.textAlignment = .center
        eventTitle.numberOfLines = 0
        eventTitle.lineBreakMode = .byWordWrapping

        eventTitle.center.x = backgroundView.center.x
        eventTitle.text = events[index].eventTitle
        //eventTitle.topAnchor.constraint(equalTo: eventImage.bottomAnchor).isActive = true
        tempView.addSubview(eventTitle)
        
        
        //third level
        eventDate = UILabel(frame: CGRect(x: 0, y: 375, width: 265, height: 20))
        eventDate.backgroundColor = .clear
        if thisEventDate[index] == "this event is now over"{
            eventDate.textColor = UIColor.red
        }else{
            eventDate.textColor = UIColor.white
        }
        eventDate.textAlignment = .center
        eventDate.numberOfLines = 0
        eventDate.lineBreakMode = .byWordWrapping
        eventDate.font = eventDate.font.withSize(16)
        eventDate.center.x = backgroundView.center.x
        //eventDate.text = events[index].eventdate
        eventDate.text = thisEventDate[index]
        //eventDate.topAnchor.constraint(equalTo: eventTitle.bottomAnchor).isActive = true
        tempView.addSubview(eventDate)
        
        
        //rating controllers
        let ratingY = 400
        let ratingHeight = 20
        let ratingWidth = 20
        
        
        //fourth level - 1
        eventRatingOne = UIImageView(frame: CGRect(x: 80, y: ratingY, width: ratingWidth, height: ratingHeight))
        eventRatingOne.image = UIImage(named: "RatingStar")
        eventRatingOne.contentMode = .scaleAspectFit
        eventRatingOne.clipsToBounds = true
        //eventRatingOne.topAnchor.constraint(equalTo: eventDate.bottomAnchor).isActive = true
        tempView.addSubview(eventRatingOne)
        
        //fourth level - 2
        eventRatingTwo = UIImageView(frame: CGRect(x: 110, y: ratingY, width: ratingWidth, height: ratingHeight))
        eventRatingTwo.image = UIImage(named: "RatingStar")
        eventRatingTwo.contentMode = .scaleAspectFit
        eventRatingTwo.clipsToBounds = true
        //eventRatingTwo.topAnchor.constraint(equalTo: eventDate.bottomAnchor).isActive = true
        tempView.addSubview(eventRatingTwo)
        
        //fourth level - 3
        eventRatingThree = UIImageView(frame: CGRect(x: 140, y: ratingY, width: ratingWidth, height: ratingHeight))
        eventRatingThree.image = UIImage(named: "RatingStar")
        eventRatingThree.contentMode = .scaleAspectFit
        eventRatingThree.clipsToBounds = true
        //eventRatingThree.topAnchor.constraint(equalTo: eventDate.bottomAnchor).isActive = true
        tempView.addSubview(eventRatingThree)
        
        //fourth level - 4
        eventRatingFour = UIImageView(frame: CGRect(x: 170, y: ratingY, width: ratingWidth, height: ratingHeight))
        eventRatingFour.image = UIImage(named: "RatingStar")
        eventRatingFour.contentMode = .scaleAspectFit
        eventRatingFour.clipsToBounds = true
        //eventRatingFour.topAnchor.constraint(equalTo: eventDate.bottomAnchor).isActive = true
        tempView.addSubview(eventRatingFour)
        
        //fourth level - 5
        eventRatingFive = UIImageView(frame: CGRect(x: 200, y: ratingY, width: ratingWidth, height: ratingHeight))
        eventRatingFive.image = UIImage(named: "RatingStar")
        eventRatingFive.contentMode = .scaleAspectFit
        eventRatingFive.clipsToBounds = true
        //eventRatingFive.topAnchor.constraint(equalTo: eventDate.bottomAnchor).isActive = true
        tempView.addSubview(eventRatingFive)
        
        
        //fifth level
        /*eventSubtext = UILabel(frame: CGRect(x: 0, y: 485, width: 265, height: 60))
        eventSubtext.backgroundColor = .clear
        eventSubtext.textColor = UIColor.gray
        eventSubtext.textAlignment = .left
        eventSubtext.numberOfLines = 3
        eventSubtext.lineBreakMode = .byTruncatingTail
        eventSubtext.font = eventSubtext.font.withSize(13)
        eventSubtext.center.x = backgroundView.center.x
        eventSubtext.text = events[index].eventDescription
        tempView.addSubview(eventSubtext)
        */
        
        /*sixth level
        eventButton = UIButton(frame: CGRect(x: 14, y: 566, width: 200, height: 35))
        eventButton.backgroundColor = UIColor.darkGray
        eventButton.setTitle("More Info", for: .normal)
        eventButton.setTitleColor(UIColor.white, for: .normal)
        eventButton.layer.cornerRadius = 17.5
        eventButton.addTarget(self, action: #selector(self.pressed), for: .touchUpInside)
        eventButton.tag = index
        tempView.addSubview(eventButton)
 
        
        //seventh level
        likeButton = UIButton(frame: CGRect(x: 239, y: 573.5, width: 25, height: 20.34))
        likeButton.backgroundColor = UIColor.darkGray
        likeButton.setTitleColor(UIColor.white, for: .normal)
        likeButton.addTarget(self, action: #selector(self.liked), for: .touchUpInside)
        likeButton.tag = index
        tempView.addSubview(likeButton)
        */
        
        
        var starHitcolor = UIColor.yellow
        if thisEventDate[index] == "this event is now over"{
            starHitcolor = UIColor.red
        }else{
            starHitcolor = UIColor.yellow
        }
        
        if events[index].peopleGoing <= 5 {
            eventRatingOne.tintColor = starHitcolor
            eventRatingTwo.tintColor = UIColor.gray
            eventRatingThree.tintColor = UIColor.gray
            eventRatingFour.tintColor = UIColor.gray
            eventRatingFive.tintColor = UIColor.gray
        } else if events[index].peopleGoing <= 20 {
            eventRatingOne.tintColor = starHitcolor
            eventRatingTwo.tintColor = starHitcolor
            eventRatingThree.tintColor = UIColor.gray
            eventRatingFour.tintColor = UIColor.gray
            eventRatingFive.tintColor = UIColor.gray
        } else if events[index].peopleGoing <= 50 {
            eventRatingOne.tintColor = starHitcolor
            eventRatingTwo.tintColor = starHitcolor
            eventRatingThree.tintColor = starHitcolor
            eventRatingFour.tintColor = UIColor.gray
            eventRatingFive.tintColor = UIColor.gray
        }else if events[index].peopleGoing <= 99 {
            eventRatingOne.tintColor = starHitcolor
            eventRatingTwo.tintColor = starHitcolor
            eventRatingThree.tintColor = starHitcolor
            eventRatingFour.tintColor = starHitcolor
            eventRatingFive.tintColor = UIColor.gray
        }else if events[index].peopleGoing >= 100 {
            eventRatingOne.tintColor = starHitcolor
            eventRatingTwo.tintColor = starHitcolor
            eventRatingThree.tintColor = starHitcolor
            eventRatingFour.tintColor = starHitcolor
            eventRatingFive.tintColor = starHitcolor
        }
        
        return tempView
    }
    
    
    @objc func liked(sender: UIButton!){
        let buttonTag = sender.tag
        print(events[buttonTag].eventTitle)
        print(events[buttonTag].eventImage!)
        let thisEvent = events[buttonTag]
        
            likeButton.backgroundColor = UIColor.red
        
    }
    
    @objc func pressed(sender: UIButton!) {
        let buttonTag = sender.tag
        print(events[buttonTag].eventTitle)
        print(events[buttonTag].eventImage!)
        let thisEvent = events[buttonTag]
        
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ShowEventDetail") as!
        EventsDetailViewController
        
        
        /*destinationController.eImage = thisEvent.eventImage!//events[buttonTag].eventImage!
        print(events[buttonTag].eventImage!)
        
        destinationController.eTitle = thisEvent.eventTitle
        destinationController.eDetail = thisEvent.eventDescription
        destinationController.eDate = thisEvent.eventdate
        destinationController.eTime = thisEvent.eventTime
        destinationController.eCount = thisEvent.peopleGoing
        destinationController.eLocation = thisEvent.eventLocation
        destinationController.regularEventDate = thisEvent.regularEventDate
 */
        destinationController.administrator = administrator
        destinationController.eventKey = thisEvent.key

        self.navigationController?.pushViewController(destinationController, animated: true)
        destinationController.liveEvent = thisEvent
    }
    
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 1.1
        }
        return value
        
    }
        
    
    @objc func informationButton() {
        UserDefaults.standard.set(false, forKey: "hasViewedEventsWalkthrough")
        information()
    }
    
    
    func information(){
        print("Calling Information")
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            pageViewController.viewingEventsWalkthrough = true
            present(pageViewController, animated: true, completion: nil)
            
            
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


