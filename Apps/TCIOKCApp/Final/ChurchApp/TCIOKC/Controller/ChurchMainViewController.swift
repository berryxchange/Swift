//
//  ChurchMainViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/27/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import iCarousel
import SafariServices



class ChurchMainViewController: UIViewController,  iCarouselDelegate, iCarouselDataSource {
    
    @IBOutlet var caroselView: iCarousel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    
    //points to an online location that stores the list of online users.
   
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBAction func unwindToMainController(segue: UIStoryboardSegue ){
    
    }
    
    @IBOutlet weak var menutab: UIView!
    @IBOutlet weak var menuLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var mainButton: UIButton!
    
    @IBOutlet weak var usersButton: UIButton!
    
    @IBOutlet weak var closeButton: UIButton!
    
    
    
    var count = 0
    
    var data = MinistryData()
    var administrator = ""
    var associate = ""
    var regular = ""
    //var role = ""
    var ministryIcon: UIImageView!
    var ministryTitle: UILabel!
    var ministryDetail: UILabel!
    var button: UIButton!
    var ministryImage: UIImageView!
    var imageToner: UIView!
    var arrayOfRoles : [String] = []
    var role : String? = ""
    var viewingAgreement = false
    var isInAgreement = false
    let infoButton = UIButton.init(type: .custom)
    let rightSignoutBarButtonItem =  UIButton.init(type: .custom)
    let profileButton =  UIButton.init(type: .custom)
    var stringOfProfileUID = ""
    
    
    var currentUserUid = FIRAuth.auth()?.currentUser?.uid
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        }
        
        self.caroselView.reloadData()
        let adminRef = FIRDatabase.database().reference().child("Administrators")
        let associateRef = FIRDatabase.database().reference().child("Associates")
        
        //test for the admin
        adminRef.observe(.childAdded, with: {snapshot in
            // first compare the currrent user with the array of admins
            // if the current id is in that group then the current user id will be added to the administrator string
            //else if not in that group, the name will be tried in the associates array
            // else if not in that group, the user will just be a plain user.
            //print("the snapshot \(snapshot.value!)")
            var adminsArray = [String]()
            
            adminsArray.append("\(snapshot.value!)")
            for array in adminsArray{
                print(self.currentUserUid!)
                print(array)
                if self.currentUserUid! == array{
                    self.administrator = self.currentUserUid!
                    print("The admin name: \(self.administrator)")
                }
                self.caroselView.reloadData()
            }
            self.caroselView.reloadData()
        })
        
        //test for the associate
        associateRef.observe(.childAdded, with: {snapshot in
            
            print(snapshot)
            var associatesArray = [String]()
            
            associatesArray.append("\(snapshot.value!)")
            for array in associatesArray{
                print(self.currentUserUid!)
                print(array)
                if self.currentUserUid! == array{
                    self.associate = self.currentUserUid!
                    print("The associate name: \(self.associate)")
                }
                self.caroselView.reloadData()
            }
            self.caroselView.reloadData()
        })
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(true)
        if UserDefaults.standard.bool(forKey: "hasViewedWalkthrough"){
            return
        }
        
        
        information()
        
        self.caroselView.reloadData()
        let adminRef = FIRDatabase.database().reference().child("Administrators")
        let associateRef = FIRDatabase.database().reference().child("Associates")
        
        //test for the admin
        adminRef.observe(.childAdded, with: {snapshot in
            // first compare the currrent user with the array of admins
            // if the current id is in that group then the current user id will be added to the administrator string
            //else if not in that group, the name will be tried in the associates array
            // else if not in that group, the user will just be a plain user.
            //print("the snapshot \(snapshot.value!)")
            var adminsArray = [String]()
            
            adminsArray.append("\(snapshot.value!)")
            for array in adminsArray{
                print(self.currentUserUid!)
                print(array)
                if self.currentUserUid! == array{
                  self.administrator = self.currentUserUid!
                    print("The admin name: \(self.administrator)")
                }
                self.caroselView.reloadData()
            }
           self.caroselView.reloadData()
        })
        
        //test for the associate
        associateRef.observe(.childAdded, with: {snapshot in
           
            print(snapshot)
            var associatesArray = [String]()
            
            associatesArray.append("\(snapshot.value!)")
            for array in associatesArray{
                print(self.currentUserUid!)
                print(array)
                if self.currentUserUid! == array{
                    self.associate = self.currentUserUid!
                    print("The admin name: \(self.associate)")
                }
                self.caroselView.reloadData()
            }
            self.caroselView.reloadData()
        })
        
       
        
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let adminRef = FIRDatabase.database().reference().child("Administrators")
        let associateRef = FIRDatabase.database().reference().child("Associates")
        
        //test for the admin
        adminRef.observe(.childAdded, with: {snapshot in
            // first compare the currrent user with the array of admins
            // if the current id is in that group then the current user id will be added to the administrator string
            //else if not in that group, the name will be tried in the associates array
            // else if not in that group, the user will just be a plain user.
            //print("the snapshot \(snapshot.value!)")
            var adminsArray = [String]()
            
            adminsArray.append("\(snapshot.value!)")
            for array in adminsArray{
                print(self.currentUserUid!)
                print(array)
                if self.currentUserUid! == array{
                    self.administrator = self.currentUserUid!
                    print("The admin name: \(self.administrator)")
                }
                self.caroselView.reloadData()
            }
            self.caroselView.reloadData()
        })
        
        //test for the associate
        associateRef.observe(.childAdded, with: {snapshot in
            
            print(snapshot)
            var associatesArray = [String]()
            
            associatesArray.append("\(snapshot.value!)")
            for array in associatesArray{
                print(self.currentUserUid!)
                print(array)
                if self.currentUserUid! == array{
                    self.associate = self.currentUserUid!
                    print("The admin name: \(self.associate)")
                }
                self.caroselView.reloadData()
            }
            self.caroselView.reloadData()
        })
        
        title = "CHURCH"//"\(data.churchName)"
        
        caroselView.type = .rotary
        if isInAgreement == false{
            infoButton.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
            infoButton.addTarget(self, action:#selector(informationButton), for:.touchUpInside)
            infoButton.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
            let barButton = UIBarButtonItem.init(customView: infoButton)
            
            barButton.tintColor = UIColor.blue
            
            
            rightSignoutBarButtonItem.addTarget(self, action:#selector(signout), for:.touchUpInside)
            rightSignoutBarButtonItem.setTitle("Sign Out", for: .normal)
            rightSignoutBarButtonItem.setTitleColor(UIColor.blue, for: .normal)
            
            let rightBarButton = UIBarButtonItem.init(customView: rightSignoutBarButtonItem)
             self.navigationItem.setRightBarButtonItems([rightBarButton, barButton], animated: true)
           
        }
    }

    
    func checkIfUserIsLoggedIn(){
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
            
        }
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
                self.setupNavbarWithUser(user: user)
            }
            
        }, withCancel: nil)
    }
    
    
    func setupNavbarWithUser(user: User){
       
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        //titleView.backgroundColor = UIColor.red
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode  = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        if let profileImageUrl = user.userImageUrl {
            profileImageView.loadImageUsingCacheWithURLString(urlString: profileImageUrl)
        }
        containerView.addSubview(profileImageView)
        
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.text = user.username
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        nameLabel.font = nameLabel.font.withSize(12)
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        //self.navigationItem.titleView = titleView
        
        
    }
    
    @objc func handleLogout(){
        
    }
    
    
    func information(){
        print("Calling Information")
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            pageViewController.viewingIntroWalkthrough = true
            present(pageViewController, animated: true, completion: nil)
            
            
        }
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        if FIRAuth.auth()?.currentUser?.uid == administrator{
            return data.administratorMinistries.count
        }else if FIRAuth.auth()?.currentUser?.uid == associate{
            return data.associatesMinistries.count
        }else{
            return data.ministries.count
        }
    }
    
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        
       
        
        //var label: UILabel
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        
      //  var itemView: UIImageView
        
        
        // main container
        tempView.backgroundColor = UIColor.white.withAlphaComponent(1)
        tempView.layer.cornerRadius = 8.0
        tempView.layer.borderWidth = 1.0
        tempView.layer.borderColor = UIColor.clear.cgColor
        tempView.layer.masksToBounds = true
     
        //first level
        
        ministryImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        
        ministryImage.contentMode = .scaleAspectFill
        ministryImage.clipsToBounds = true
        
        
 
        //tempView.addSubview(ministryImage)
        
        imageToner = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        
        //  var itemView: UIImageView
        
        
        // main container
        imageToner.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        imageToner.layer.cornerRadius = 8.0
        imageToner.layer.borderWidth = 1.0
        imageToner.layer.borderColor = UIColor.clear.cgColor
        imageToner.layer.masksToBounds = true
        //tempView.addSubview(imageToner)
        
        
        //second level
        
        ministryIcon = UIImageView(frame: CGRect(x: 75, y: 75, width: 146, height: 146))
        if FIRAuth.auth()?.currentUser?.uid == self.administrator {
             ministryIcon.image = UIImage(named: data.administratorMinistries[index].ministryIcon)
        }else if FIRAuth.auth()?.currentUser?.uid == self.associate {
            ministryIcon.image = UIImage(named: data.associatesMinistries[index].ministryIcon)
        }else{
             ministryIcon.image = UIImage(named: data.ministries[index].ministryIcon)
        }
       
        ministryIcon.contentMode = .scaleAspectFit
        ministryIcon.clipsToBounds = true
        tempView.addSubview(ministryIcon)
    
        //third level
        ministryTitle = UILabel(frame: CGRect(x: 25, y: 245, width: 250, height: 30))
        ministryTitle.backgroundColor = .clear
        ministryTitle.textColor = UIColor.black
        ministryTitle.textAlignment = .center
        ministryTitle.numberOfLines = 0
        ministryTitle.lineBreakMode = .byWordWrapping
        ministryTitle.font = ministryTitle.font.withSize(27)
        if FIRAuth.auth()?.currentUser?.uid == self.administrator {
            ministryTitle.text = data.administratorMinistries[index].ministryTitle
        }else if FIRAuth.auth()?.currentUser?.uid == self.associate {
            ministryTitle.text = data.associatesMinistries[index].ministryTitle
        }else{
            ministryTitle.text = data.ministries[index].ministryTitle
        }
        
        tempView.addSubview(ministryTitle)
    
        //fourth level
        ministryDetail = UILabel(frame: CGRect(x: 50, y: 255, width: 200, height: 100))
        ministryDetail.backgroundColor = .clear
        ministryDetail.textColor = UIColor.black 
        ministryDetail.textAlignment = .center
        ministryDetail.numberOfLines = 3
        ministryDetail.lineBreakMode = .byWordWrapping
        ministryDetail.font = ministryTitle.font.withSize(17)
        if FIRAuth.auth()?.currentUser?.uid == self.administrator {
             ministryDetail.text = data.administratorMinistries[index].ministrySubtitle
        }else if FIRAuth.auth()?.currentUser?.uid == self.associate {
            ministryDetail.text = data.associatesMinistries[index].ministrySubtitle
        }else{
             ministryDetail.text = data.ministries[index].ministrySubtitle
        }
       
        tempView.addSubview(ministryDetail)
        
        //fifth level
        button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 450))
        button.addTarget(self, action: #selector(self.pressed), for: .touchUpInside)
       button.tag = index
        tempView.addSubview(button)
        
        //returns all that are listed above as items in the container
        return tempView
        
    
    }
    
  
    
    
    @objc func informationButton() {
        UserDefaults.standard.set(false, forKey: "hasViewedWalkthrough")
        information()
    }
    
    
    
    @objc func pressed(sender: UIButton!) {
        let buttonTag = sender.tag
        if FIRAuth.auth()?.currentUser?.uid == self.administrator {
            print(data.administratorMinistries[buttonTag].ministryTitle)
            print("The admin name: \(self.administrator)")
            switch data.administratorMinistries[buttonTag].ministryTitle {
                
            case "Events" :
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let controller = storyboard.instantiateViewController(withIdentifier: "MainEventsController") as UIViewController
                
                
                
                //self.show(controller, sender: self)
                self.present(controller, animated: true, completion: nil)
                
                
                
            case "Weekly Bulliten" :
                performSegue(withIdentifier: "ShowMinistry", sender: self)
            case "Media" :
                performSegue(withIdentifier: "ShowMedia", sender: self)
            case "Social" :
                performSegue(withIdentifier: "ShowSocial", sender: self)
            case "Prayer" :
                performSegue(withIdentifier: "ShowPrayerWall", sender: self)
            case "Pastoral Blog" :
                performSegue(withIdentifier: "ShowBlog", sender: self)
            case "Bible" :
                
                var BibleLink = "http://bible.com"
                    
                    if let url = URL(string: BibleLink){
                        let safariController = SFSafariViewController(url:url)
                        present(safariController, animated: true, completion: nil)
                    }
                
                //performSegue(withIdentifier: "ShowBible", sender: self)
            case "Chat" :
                let controller = storyboard?.instantiateViewController(withIdentifier: "UsersNavigationController") as! UIViewController
                
                show(controller, sender: self)
                
            case "Class" :
                performSegue(withIdentifier: "ShowClassSegue", sender: self)
            
            case "Dashboard" :
                performSegue(withIdentifier: "ShowDashboardSegue", sender: self)
                
            case "Church Info" :
                let controller = storyboard?.instantiateViewController(withIdentifier: "ChurchInfo") as! ChurchInfoViewController
                controller.administrator = administrator
                controller.associate = associate
                
                show(controller, sender: self)
                
                
            default:
                break
            }
        }else if FIRAuth.auth()?.currentUser?.uid == self.associate {
            print(data.associatesMinistries[buttonTag].ministryTitle)
            print("The associate name: \(self.associate)")
            switch data.associatesMinistries[buttonTag].ministryTitle {
                
            case "Events" :
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let controller = storyboard.instantiateViewController(withIdentifier: "MainEventsController") as UIViewController
                
                //self.show(controller, sender: self)
                
                self.present(controller, animated: true, completion: nil)
            case "Weekly Bulliten" :
                performSegue(withIdentifier: "ShowMinistry", sender: self)
            case "Media" :
                performSegue(withIdentifier: "ShowMedia", sender: self)
            case "Social" :
                performSegue(withIdentifier: "ShowSocial", sender: self)
            case "Prayer" :
                performSegue(withIdentifier: "ShowPrayerWall", sender: self)
            case "Pastoral Blog" :
                performSegue(withIdentifier: "ShowBlog", sender: self)
            case "Bible" :
                var BibleLink = "http://bible.com"
                
                if let url = URL(string: BibleLink){
                    let safariController = SFSafariViewController(url:url)
                    present(safariController, animated: true, completion: nil)
                }
            
            //performSegue(withIdentifier: "ShowBible", sender: self)
            case "Chat" :
                let controller = storyboard?.instantiateViewController(withIdentifier: "UsersNavigationController") as! UIViewController
                show(controller, sender: self)
                
            case "Class" :
                performSegue(withIdentifier: "ShowClassSegue", sender: self)
                
            case "Church Info" :
                let controller = storyboard?.instantiateViewController(withIdentifier: "ChurchInfo") as! ChurchInfoViewController
                controller.administrator = administrator
                controller.associate = associate
                
                show(controller, sender: self)
    
            default:
                break
            }
        }else if FIRAuth.auth()?.currentUser?.uid != self.associate && FIRAuth.auth()?.currentUser?.uid != self.administrator{
            print(data.ministries[buttonTag].ministryTitle)
            switch data.ministries[buttonTag].ministryTitle {
                
            case "Events" :
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let controller = storyboard.instantiateViewController(withIdentifier: "MainEventsController") as UIViewController
                
                //self.show(controller, sender: self)
                
                self.present(controller, animated: true, completion: nil)
                
            case "Weekly Bulliten" :
                performSegue(withIdentifier: "ShowMinistry", sender: self)
            case "Media" :
                performSegue(withIdentifier: "ShowMedia", sender: self)
            case "Social" :
                performSegue(withIdentifier: "ShowSocial", sender: self)
            case "Prayer" :
                performSegue(withIdentifier: "ShowPrayerWall", sender: self)
            case "Pastoral Blog" :
                performSegue(withIdentifier: "ShowBlog", sender: self)
            case "Bible" :
            
                var BibleLink = "http://bible.com"
                
                if let url = URL(string: BibleLink){
                    let safariController = SFSafariViewController(url:url)
                    present(safariController, animated: true, completion: nil)
                }
            
            //performSegue(withIdentifier: "ShowBible", sender: self)
            case "Chat" :
                let controller = storyboard?.instantiateViewController(withIdentifier: "UsersNavigationController") as! UIViewController
                
                show(controller, sender: self)
                
            case "Church Info" :
                let controller = storyboard?.instantiateViewController(withIdentifier: "ChurchInfo") as! ChurchInfoViewController
                controller.administrator = administrator
                controller.associate = associate
                
                show(controller, sender: self)
                
                
            default:
                break
            }
        }
        
    }
    
    
    
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if option == iCarouselOption.spacing {
            return value * 1.5
        }
        return value
    }
    
    
    
    @IBAction func menuButton(_ sender: Any) {
        //let slideDownTransition = SlideDownTransitionAnimator()
        
        let slideRightTransition = SlideRightTransitionAnimator()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "menuViewController") as UIViewController
        
        controller.transitioningDelegate = slideRightTransition
        
        print(slideRightTransition.isPresenting)
            present(controller, animated: true, completion: nil)
 
        
    }
    
   
   
    
    
    @IBAction func gotoProfile() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "ProfilePage") as! UIViewController
        
        show(controller, sender: self)
    }
   
    
    
    
    
    
    
    /*func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.ministries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as?
        MainCollectionViewCell
        
        let ourMinistry = data.ministries[indexPath.item]
        cell?.getMinistry(ministry: ourMinistry)
        
        // shadow edits
       
        cell?.layer.backgroundColor = UIColor.white.cgColor
        cell?.contentView.layer.cornerRadius = 8.0
        cell?.contentView.layer.borderWidth = 1.0
        cell?.contentView.layer.borderColor = UIColor.clear.cgColor
        cell?.contentView.layer.masksToBounds = true;
        
        cell?.layer.shadowColor = UIColor.lightGray.cgColor
        cell?.layer.shadowOffset = CGSize(width:0,height: 2.0)
        cell?.layer.shadowRadius = 6.0
        cell?.layer.shadowOpacity = 0.70
        cell?.layer.masksToBounds = false;
        cell?.layer.cornerRadius = 6.0
        cell?.layer.shadowPath = UIBezierPath(roundedRect:cell!.bounds, cornerRadius:cell!.contentView.layer.cornerRadius).cgPath
        
        print(indexPath.row)
        
        
        
        return cell!
    }
    */
    
    
    /*func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch data.ministries[indexPath.row].ministryTitle {
       
        case "Events" :
            performSegue(withIdentifier: "ShowEvents", sender: self)
        case "Weekly Bulliten" :
            performSegue(withIdentifier: "ShowMinistry", sender: self)
        case "Media" :
            performSegue(withIdentifier: "ShowMedia", sender: self)
        case "Social" :
            performSegue(withIdentifier: "ShowSocial", sender: self)
        case "Prayer" :
            performSegue(withIdentifier: "ShowPrayerWall", sender: self)
        case "Pastoral Blog" :
            performSegue(withIdentifier: "ShowBlog", sender: self)
        case "Bible" :
            performSegue(withIdentifier: "ShowMinistry", sender: self)
        default:
            break
        }
        
        
    }
     */
    
    
    
    @objc func signout() {
        
        do {
            try FIRAuth.auth()?.signOut()
            
            dismiss(animated: true, completion: nil)
                /* this resets the user defaults to reload after the user logs out.
           
             UserDefaults.standard.set(false, forKey: "hasViewedWalkthrough")
            dismiss(animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: "hasViewedEventsWalkthrough")
            dismiss(animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: "hasViewedSocialWalkthrough")
            dismiss(animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: "hasViewedPrayerWalkthrough")
            dismiss(animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: "hasViewedPastoralWalkthrough")
            dismiss(animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: "hasViewedChatWalkthrough")
            dismiss(animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: "hasViewedClassWalkthrough")
            dismiss(animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: "hasViewedDashboardWalkthrough")
            dismiss(animated: true, completion: nil)
            
            UserDefaults.standard.set(false, forKey: "hasViewedProfileWalkthrough")
            dismiss(animated: true, completion: nil)
            */
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
        

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        switch segue.identifier {
            
        case "ShowEvents" :
            let destinationController = segue.destination as! TableViewController
            destinationController.administrator = self.administrator
            destinationController.associate = self.associate
           
 
        case "ShowSocial" :
            
            let destinationController = segue.destination as!socialMediaViewController
            destinationController.administrator = self.administrator
            destinationController.associate = self.associate
            destinationController.regular = self.regular
            
        case "ShowPrayerWall" :
           
            let destinationController = segue.destination as! PrayerViewController
            destinationController.administrator = self.administrator
            destinationController.associate = self.associate
            destinationController.regular = self.regular
            
        case "ShowBlog" :
            
            let destinationController = segue.destination as! PastorsBlogListViewController
            destinationController.administrator = self.administrator
            destinationController.associate = self.associate
            
            
        case "ShowClassSegue" :
            let destinationController = segue.destination as! ClassesViewControllerTableViewController
            destinationController.administrator = self.administrator
            destinationController.associate = self.associate
            destinationController.regular = self.regular
            
        
        default:
            break
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}

extension UIButton{
    func churchAppButtonRegular(){
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1), for: .normal)
    }
    
    func churchAppButtonImportant(){
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 1, green: 0, blue: 0, alpha: 1), for: .normal)
    }
    
    func churchAppButtonAccent(){
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.3395062974, green: 0.874027315, blue: 0.9768045545, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0.3395062974, green: 0.874027315, blue: 0.9768045545, alpha: 1), for: .normal)
    }
    
    func churchAppButtonEventCancel(){
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), for: .normal)
    }
    
    func churchAppButtonEventReinstate(){
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), for: .normal)
    }
    
}
