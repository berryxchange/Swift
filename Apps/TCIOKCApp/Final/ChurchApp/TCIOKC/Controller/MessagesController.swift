//
//  UsersViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 1/23/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import UserNotifications

class MessagesController: UIViewController, UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var emptyChat: UIView!
    
    
    //MARK: Constants
    
    
    //MARK: Properties
    var currentUsers = [User]()
    var administrators: [Administrator] = []
    
    // unwind to this page
    
    @IBAction func unwindToMessagesControllerRegular(segue: UIStoryboardSegue ){
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "hasViewedChatWalkthrough"){
            return
        }
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            present(pageViewController, animated: true, completion: nil)
            
            pageViewController.viewingChatWalkthrough = true
        }
    }
    
    
    //MARK: UIViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(informationButton), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        //self.navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = UIColor.blue
        
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(goToCompose))
        
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem, barButton], animated: true)
        
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        tableView.backgroundColor = .clear
        navigationItem.backBarButtonItem?.isEnabled = true
        
        
        
        checkIfUserIsLoggedIn()
        
        print("there are \(currentUsers.count) users")
        // will observe another message group for secure 1 on 1 chat      observeMessages()
        
        
        tableView.allowsSelectionDuringEditing = true
        
        UNUserNotificationCenter.current().requestAuthorization(options:
            [[.alert, .sound, .badge]],completionHandler: { (granted, error) in
            // Handle Error
        })
       

        
    }
    
    
    func getNotification(){
        // Notifications
        
        let content = UNMutableNotificationContent()
        content.title = "Someone sent you a message!"
        content.subtitle = ""
        content.body = "Check it out!"
        content.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1,
                                                        repeats: false)
        
        let requestIdentifier = "demoNotification"
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request,withCompletionHandler: { (error) in
            // Handle error
        })
        
        //end.....
    
    }
    
    
    
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
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
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        
        // this is the new observer
        observeSingleUserMessages()
        
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
        
        
    }
    
    
    @objc func handleLogout(){
        
    }
    
    
    
    
    var messages : [Message] = [] // is the array for the display of chat data
    var messagesDictionary = [String: Message]()  // is the array of data for the display of a singular secured chat between a user
    
   
    var noticeUserName = ""
    var noticeMessage = ""
    
    // gets the messages of a single chat to a specific user
    func observeSingleUserMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
            
        }
        
        let ref = FIRDatabase.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            
            let userId = snapshot.key // the uid
            
            
            FIRDatabase.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot) in
                
                
                let messageId = snapshot.key
                
                // for notification
                self.notifyMessage(messageId: messageId)
                //end.....
                
                self.fetchAndAndMesageId(messageId: messageId)
                
                
            }, withCancel: nil)
        }, withCancel: nil)
        
        ref.observe(.childRemoved, with: { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadOfTable()
        }, withCancel: nil)
        
    }
    
    
    // for notifying about new message
    private func notifyMessage(messageId: String){
        let messagesReference = FIRDatabase.database().reference().child("Messages").child(messageId) // gets this message by the uid
        
        messagesReference.observe(.value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if message.fromId != FIRAuth.auth()?.currentUser?.uid{
                    
                     self.getNotification()
                    
                   // print("This is the chat user UID: \(message.fromId!), the message: \(message.text!)")
                    // add extra data to specify about who and what data is to be shown in the notification.
                }
            }
        })
    }
    
    
    private func fetchAndAndMesageId(messageId: String){
        let messagesReference = FIRDatabase.database().reference().child("Messages").child(messageId) // gets this message by the uid
        messagesReference.observe(.value, with: { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                    //self.scheduleNotifications(partnerId: chatPartnerId)
                }
                
                
                
                self.attemptReloadOfTable()
            }
            
        }, withCancel: nil)
        
    }
    
    
    private func attemptReloadOfTable(){
        self.timer?.invalidate()
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.reloadTable), userInfo: nil, repeats: false)
    }
    
    var timer: Timer?
    
    @objc func reloadTable(){
        self.messages = Array(self.messagesDictionary.values)
        self.messages.sort(by: { (message1, message2) ->
            Bool in
            
            return (message1.timestamp?.intValue)! > (message2.timestamp?.intValue)!
            
        })
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if messages.isEmpty == true {
            emptyChat.isHidden = false
        }else {
            emptyChat.isHidden = true
        }
        return messages.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MessagesCell
        
        
        
        let thisMessage = messages[indexPath.row]
        
        
        if let toId = thisMessage.chatPartnerId() {
            let ref = FIRDatabase.database().reference().child("users").child(toId)
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    
                    print(dictionary["thisUserInfo"]!["username"]!!)
                    
                    cell.userName.text = dictionary["thisUserInfo"]!["username"]!! as? String
                    
                    cell.userPostedText.text = thisMessage.text
                    if let seconds = thisMessage.timestamp?.doubleValue {
                        let timeStampDate = NSDate.init(timeIntervalSince1970: seconds)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM/d/yyyy (hh:mm a)"
                        cell.timeStamp.text = dateFormatter.string(from: timeStampDate as Date)
                    }
                    
                    
                    if let profileImageUrl = dictionary["thisUserInfo"]!["userImageUrl"]!! as? String{
                        cell.userImage.loadImageUsingCacheWithURLString(urlString: profileImageUrl)
                    }
                    
                    
                    
                }
                
                //print(snapshot)
            }, withCancel: nil)
        }
        
        //cell.textLabel?.text = thisMessage.text
        
        
        cell.userImage.layer.cornerRadius = 37.5
        cell.userImage.layer.masksToBounds = true
        
        
        return cell
    }
    
    // deleting cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            messages.remove(at: indexPath.row)
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let thisMessage = messages[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: {(action, indexPath)-> Void in
            // Delete the row from the dataSource
            guard let uid = FIRAuth.auth()?.currentUser?.uid else {
                return
                
            }
            
            let toId = thisMessage.chatPartnerId()
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid)
            
            let chatPartner = userMessagesRef.child(toId!)
            chatPartner.removeValue()
            //let toUid = thisMessage.toUid
            
            
            self.messagesDictionary.removeValue(forKey: toId!)
            self.attemptReloadOfTable()
            //self.messages.remove(at: indexPath.row)
            //self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            
        })
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        return [deleteAction]
    }
    
    
    var exsistingUser : Member!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        //print("your code:" + message.text!, message.toUid!, message.fromId!)
        
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        let ref = FIRDatabase.database().reference().child("members").child(chatPartnerId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            print(snapshot)
           
            var user: Member!
            let thisMember = Member(snapshot: snapshot )
            user = thisMember
            
            user.id = chatPartnerId
            
            self.exsistingUser = user
            //self.performSegue(withIdentifier: "ShowExistingChat", sender: self)
            let chatLogControllerOne = ChatLogControllerOne(collectionViewLayout: UICollectionViewFlowLayout())
            
            
            //let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ChatLogController") as! ChatLogController
            chatLogControllerOne.kind = 2
            chatLogControllerOne.user = self.exsistingUser
            
            self.navigationController?.show(chatLogControllerOne, sender: self)
            
        }, withCancel: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    
    @objc func goToCompose() {
        //let NewMessageController = newMessageController()
        let controller = storyboard?.instantiateViewController(withIdentifier: "newMessage") as! newMessageController
        controller.style = "chat"
        
        show(controller, sender: self)
    }
    
    
    @objc func informationButton() {
        UserDefaults.standard.set(false, forKey: "hasViewedChatWalkthrough")
        information()
    }
    
    
    func information(){
        print("Calling Information")
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            pageViewController.viewingChatWalkthrough = true
            present(pageViewController, animated: true, completion: nil)
            
            
        }
    }
    
    
    // MARK: - Navigation
    
    /* // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if segue.identifier == "ChatLogController"{
     
     let destinationController = segue.destination as! ChatLogController
     destinationController.user = self.exsistingUser
     
     }
     }
     */
}



// for cashing images
let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImageUsingCacheWithURLString(urlString: String){
        self.image = nil
        // check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) {
            self.image = cachedImage as? UIImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil{
                print(error!  )
                return
            }
            
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    
                    self.image = downloadedImage
                }
            }
        }).resume()
        
    }
    
    
}


