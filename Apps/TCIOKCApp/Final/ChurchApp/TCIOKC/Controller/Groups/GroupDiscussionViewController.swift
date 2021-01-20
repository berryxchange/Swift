//
//  GroupDiscussionViewController.swift
//  OKCityChurch
//
//  Created by Quinton Quaye on 12/20/18.
//  Copyright © 2018 City Church. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class GroupDiscussionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    

    
    var group: Group!
    var meetup: Meetup!
    var thisMember: Member!
    var stringOfUID = ""
    var posts: [GroupMessage] = []
    
    // time formats
    // for month
    let date = Date()
    let monthFormatter = DateFormatter()
    // for day
    let dayFormatter = DateFormatter()
    //for the full date
    let dateFormatter  = DateFormatter()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var postTextBox: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 600
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // for the keyboard moving up
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.hideKeyboardWhenTappedAround()
        
        
        // post button
        postButton.churchAppButtonRegular()
        
        postTextBox.layer.cornerRadius = 20
        //postTextBox.layer.borderWidth = 2
        //postTextBox.layer.borderColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        
        // for the messages
        let discussionRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("Meetups").child(meetup.key).child("Group Messages")
        
       
        discussionRef.observe(.value, with: {snapshot in
            
            var newGroupPosts: [GroupMessage] = []
            
            for post in snapshot.children{
                let thisPost = GroupMessage(snapshot: post as! FIRDataSnapshot)
                newGroupPosts.append(thisPost)
            }
            self.posts = newGroupPosts
            self.tableView.reloadData()
            // after load new message, scroll to bottom of chat
            if self.posts.count != 0{
                let indexPath = IndexPath(row: self.posts.count - 1, section: 0)
                self.tableView?.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        })
        //...
        
        
        // for main database
        let churchMembers = FIRDatabase.database().reference(withPath: "members")
        
        var churchUsers: [Member] = []
        churchMembers.queryOrdered(byChild: "lastname").observe(.value, with: {snapshot in
            
            var newMembers: [Member] = []
            
            for member in snapshot.children{
                let thisMember = Member(snapshot: member as! FIRDataSnapshot)
                newMembers.append(thisMember)
            }
            churchUsers = newMembers
            for member in churchUsers{
                if member.key == self.stringOfUID{
                    self.thisMember = member
                }
            }
        })
        // Do any additional setup after loading the view.
    }

    

@objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= keyboardSize.height
            if self.posts.count != 0{
                let indexPath = IndexPath(row: posts.count - 1, section: 0)
                self.tableView?.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}

@objc func keyboardWillHide(notification: NSNotification) {
    if self.view.frame.origin.y != 0 {
        self.view.frame.origin.y = 0
    }
}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? GroupDiscussionTableViewCell
        
        let thisPost = posts[indexPath.row]
        cell?.getPost(message: thisPost)
        // chatImage
        cell?.chatImage.layer.cornerRadius = 20
        cell?.chatImage.layer.masksToBounds = true
        
        return cell!
    }

    @IBAction func postButton(_ sender: Any) {
        //for time format
        monthFormatter.dateFormat = "MM dd, yyyy"
        dayFormatter.dateFormat = "dd"
        dateFormatter.dateFormat = "MM/dd/yyyy, h:mm a"
        
        let discussionRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("Meetups").child(meetup.key).child("Group Messages")
        
        let post = GroupMessage(chatImage: thisMember.userImageUrl, chatName: "\(thisMember.firstname!) \(thisMember.lastname!)", chatMessage: postTextBox.text!, chatPostTime: self.dateFormatter.string(from: Date()))
        
        let discussionItem = discussionRef.childByAutoId()
        discussionItem.setValue(post.toAnyObject())
        
        
        
        self.hideKeyboardWhenTappedAround()
        if self.posts.count != 0{
            let indexPath = IndexPath(row: posts.count - 1, section: 0)
            tableView?.scrollToRow(at: indexPath, at: .bottom, animated: false)
        
           
        }
         postTextBox.text = ""
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
