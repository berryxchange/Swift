//
//  ChatLogControllerTableViewController.swift
//  ChurchAppOne
//
//  Created by Quinton Quaye on 5/9/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource { //UICollectionViewFlowLayout {
   
    var kind = 0
    
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var messageInput: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var user: User? {
        didSet {
            navigationItem.title = user?.username
            
            observeMessages()
        }
    }
    
    
    var messages = [Message]()
    
    func observeMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            return
        }
        
        let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            //print(snapshot)
            
            let messageId = snapshot.key
            let messagesRef = FIRDatabase.database().reference().child("Messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                //print(snapshot)
                
                guard let dictionary = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message(dictionary: dictionary)
                // potential of crashing, so be aware~
                message.setValuesForKeys(dictionary)
                //print(message.text!)
                
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                
                
            }, withCancel: nil)
            
        }, withCancel: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = true  // alows you to be able to pull the collection view like a scroll view when your content is shorter than the draggable space
        
        self.hideKeyboardWhenTappedAround()
        
        messageInput.delegate = self
        
        //navigationItem.title = "Chat Log Controller"
        messageContainer.layer.borderColor = #colorLiteral(red: 0.4364677785, green: 0.4364677785, blue: 0.4364677785, alpha: 1)
        messageContainer.layer.borderWidth = 0.5
        /*
        let fullWidth = collectionView.frame.width
        let cellSize = CGSize(width:fullWidth , height:80)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.reloadData()
 */
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return  messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? chatLogCell
        
        cell?.backgroundColor = UIColor.blue
        
        return cell!
    }
    
  
    
    // for adjusting text field distance from bottom
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat = -260
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
    
    
    func recheck(){
        if messageInput.text == "" {
            
            let alert = UIAlertController(title: "Cannot Send", message: "the text field is empty.", preferredStyle: .alert)
            
            let closeAction = UIAlertAction(title: "Close", style: .default) { action in
            }
            
            // actions of the alert controller
            alert.addAction(closeAction)
            
            // action to present the alert controller
            present(alert, animated: true, completion: nil)
        }else {
            let ref = FIRDatabase.database().reference().child("Messages")
            let childRef = ref.childByAutoId()
            
            let toUid = user!.id
            let fromId = FIRAuth.auth()!.currentUser!.uid
            let timestamp = Int(Date().timeIntervalSince1970)
            let values = ["text": messageInput.text!, "toUid": toUid!,  "fromId": fromId, "timestamp": timestamp] as [String : Any]
            //childRef.updateChildValues(values)
            
            childRef.updateChildValues(values){(error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                // the senders data
                let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
                
                let messageId = childRef.key
                userMessagesRef.updateChildValues([messageId: 1])
                
                
                // the receivers data
                let recipientUserMessagesRef = FIRDatabase.database().reference().child("user-messages").child(toUid!)
                recipientUserMessagesRef.updateChildValues([messageId : 1])
                
                
            }
            messageInput.text = ""
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == messageInput {
           textField.resignFirstResponder()
        }
        recheck()
        return true
    }
    
    @IBAction func sendButton(_ sender: Any) {
       recheck()
    }
    
    @IBAction func done(_ sender: Any) {
        if kind == 1{
            dismiss(animated: true, completion: nil)
            
        } else if kind == 2 {
            performSegue(withIdentifier: "unwindToMessagesControllerRegular", sender: self)
        }
    }
    
}
