//
//  MassMessagingViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/31/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class MassMessagingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
   
    @IBOutlet weak var tableView: UITableView!
    
    var massItems = ["Mass Email", "Mass Text Message"]

    var emailRecipients : [String] = []
    var textRecipients : [String] = []
    
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "hasViewedDashboardWalkthrough"){
            return
        }
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            present(pageViewController, animated: true, completion: nil)
            
            pageViewController.viewingDashboardWalkthrough = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackButton()
        
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(information), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        

        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        // Do any additional setup after loading the view.
        
        
        fetchUsers()
        self.title = "Mass Messaging"
        
    }

    // Fetching Users
    func fetchUsers(){
        // fetches all the users in the database
        
        FIRDatabase.database().reference().child("members").observe(.childAdded, with: {(snapshot) in
            
            if let thisDictionary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.id = snapshot.key
                user.setValuesForKeys(thisDictionary)
                
                print("this userName: \(user.username)")
                
                self.emailRecipients.append(user.email!)
                self.textRecipients.append(user.telephone!)
                
                print(self.emailRecipients)
                print(self.textRecipients)
            }
            
        }, withCancel: nil)
    }
    
    
    //end------
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return massItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = massItems[indexPath.row]
        
        return cell
    }
    
    
    //sending Message
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            self.Email()
        case 1:
            self.TextMessage()
        default:
            break
        }
        
    }
    
    // email composer
    func Email(){
        //Check if the device is capable to send email
        print("preparing message")
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let emailTitle = "Untitled"
        let messageBody = "Message: "
        // you can tweak this to send to all members
        let toRecipients = emailRecipients
        
        // Initialize the mail composer and populate the mail content
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setSubject(emailTitle)
        mailComposer.setMessageBody(messageBody, isHTML: false)
        mailComposer.setToRecipients(toRecipients)
        
        
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
        print("preparing message")
        guard MFMessageComposeViewController.canSendText() else {
            let alertMessage = UIAlertController(title: "SMS Unavailable", message: "Your device is not capable of sending SMS.", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertMessage, animated: true, completion: nil)
            return
        }
        
        // prefill the SMS
        let messageController = MFMessageComposeViewController()
        messageController.messageComposeDelegate = self
        messageController.recipients = textRecipients
        
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
    //end-------
    
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "Back Button"), for: .normal) // Image can be downloaded from here below link
    
        backButton.setTitleColor(backButton.tintColor, for: .normal) // You can change the TitleColor
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        //let _ = self.navigationController?.popViewController(animated: true)
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    @objc func information(){
        print("Calling Information")
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            pageViewController.viewingDashboardWalkthrough = true
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
