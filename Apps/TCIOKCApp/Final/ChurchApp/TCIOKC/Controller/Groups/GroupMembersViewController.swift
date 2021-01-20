//
//  GroupMembersViewController.swift
//  GroupApp
//
//  Created by Quinton Quaye on 8/22/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class GroupMembersViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    var members: [Member] = []
    var meetup: Meetup!
    var group: Group!
    var isMeetup = false
    var administrator = ""
    var blockedMembers: [Member] = []
    var isRegular = false
    
    struct blocked {
    var color = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    var blocked = "(Blocked)"
    }
    
    struct unblocked{
        var color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isMeetup == true{
            // meetup members from firebase
            let ref = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("Meetups").child(meetup.key).child("MembersGoing")
            ref.queryOrdered(byChild: "memberName").observe(.value, with: {snapshot in
                
                //print(snapshot)
                //2 new items are an empty array
                var newMembers: [Member] = []
                //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
                for item in snapshot.children {
                    // 4
                    print(item)
                    let memberItem = Member(snapshot: item as! FIRDataSnapshot)
                    newMembers.append(memberItem)
                }
                self.members = newMembers
                self.tableView.reloadData()
            })
        }else if isMeetup == false{
            let ref = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("Members")
            ref.queryOrdered(byChild: "groupName").observe(.value, with: {snapshot in
                
                print(snapshot)
                //2 new items are an empty array
                var newMembers: [Member] = []
                //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
                for item in snapshot.children {
                    // 4
                    print(item)
                    let memberItem = Member(snapshot: item as! FIRDataSnapshot)
                    newMembers.append(memberItem)
                }
                if self.isRegular == false{
                    self.members = newMembers
                    self.tableView.reloadData()
                }else if self.isRegular == true{
                    self.tableView.reloadData()
                }
            })
            
            
            
        }
        // Do any additional setup after loading the view.
        //print(self.members)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? GroupMembersListTableViewCell
        
        let thisCell = members[indexPath.row]
        cell?.getMembers(member: thisCell)
        cell?.memberImage.layer.cornerRadius = 25
        cell?.memberImage.layer.masksToBounds = true
        if blockedMembers.contains(where: {$0.key == thisCell.key}){
            if self.group.groupCreatorUID == FIRAuth.auth()?.currentUser?.uid || FIRAuth.auth()?.currentUser?.uid == administrator {
                
                cell?.memberName.textColor = blocked().color
                cell?.memberName.text = "\(members[indexPath.row].firstname!) \(members[indexPath.row].lastname!)  \(blocked().blocked)"
            }else{
                cell?.memberName.textColor = unblocked().color
                cell?.memberName.text = "\(members[indexPath.row].firstname!) \(members[indexPath.row].lastname!)"
            }
        }
        return cell!
    }
    
    
    
    // for deleting personal posts
    
    // deleting cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SocialTableViewCell
        
        let thisBlockedMember = members[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? GroupMembersListTableViewCell
        
        if self.group.groupCreatorUID == FIRAuth.auth()?.currentUser?.uid || FIRAuth.auth()?.currentUser?.uid == administrator {
            let thisMember = members[indexPath.row]
            if editingStyle == .delete{
                self.members.remove(at: indexPath.row)
                
                
                let memberRef = FIRDatabase.database().reference(withPath: "Categories").child(group.category!.lowercased()).child("Groups").child(group.key).child("Members").child(thisMember.key)
                
                
                memberRef.removeValue()
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
            if blockedMembers.contains(where: {$0.key == thisBlockedMember.key}){
                if editingStyle == .none{
                    cell?.memberName.textColor = unblocked().color
                    cell?.memberName.text = "\(members[indexPath.row].firstname!) \(members[indexPath.row].lastname!)"
                    self.tableView.reloadData()
                }
            }else{
                if editingStyle == .none{
                    let ref = FIRDatabase.database().reference(withPath: "Categories").child(self.group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("blockedMembers")
                    // for main database
                            let memberItem =
                                Member(username: thisMember.username!, userImageUrl: thisMember.userImageUrl!, id: thisMember.id!, firstname: thisMember.firstname!, lastname: thisMember.lastname!, email: thisMember.email!, telephone: thisMember.telephone!, bio: thisMember.bio!, role: thisMember.role!, birthday: thisMember.birthday!, anniversary: thisMember.anniversary!, profession: thisMember.profession!, address: thisMember.address!, gender: thisMember.gender!, status: thisMember.status!, work: thisMember.work!, currentLevelStatus: thisMember.status!, allergies: thisMember.allergies!, hobbies: thisMember.hobbies!, parentName: thisMember.parentName!, parentUserName: thisMember.parentUserName!, parentUid: thisMember.parentUid!, parentImage: thisMember.parentImage!, parentEmail: thisMember.parentEmail!, parentTelephone: thisMember.parentTelephone!, parentWorkTelephone: thisMember.parentWorkTelephone!, studentSelected: thisMember.studentSelected!)
                            
                            //self.blogs.insert(blogItem, at: 0)
                            let memberItemRef = ref.child(thisMember.id!)
                            memberItemRef.setValue(memberItem.toAnyObject())
                    
                    cell?.memberName.textColor = blocked().color
                    cell?.memberName.text = "\(members[indexPath.row].firstname!) \(members[indexPath.row].lastname!) \(blocked().blocked)"
                    
                    
                    tableView.reloadData()
                }
            }
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        //let thismember = members[indexPath.row]
        let thisBlockedMember = members[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: {(action, indexPath)-> Void in
            // Delete the row from the dataSource
            
            let thisMember = self.members[indexPath.row]
                    
                    let memberRef = FIRDatabase.database().reference(withPath: "Categories").child(self.group.category!.lowercased()).child("Groups").child(self.group.key).child("Members").child(thisMember.key)
                    
                    
                    memberRef.removeValue()
            
            self.members.remove(at: indexPath.row)
            self.tableView.reloadData()
            //self.messages.remove(at: indexPath.row)
            //self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        })
       
        var blockAction = UITableViewRowAction()
        
            let thisMember = self.members[indexPath.row]
            let ref = FIRDatabase.database().reference(withPath: "Categories").child(self.group.category!.lowercased()).child("Groups").child("\(self.group.key)").child("blockedMembers")
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? GroupMembersListTableViewCell
        
        if self.blockedMembers.contains(where: {$0.key == thisBlockedMember.key}){
            blockAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Unblock", handler: {(action, indexPath)-> Void in
                    // Delete the row from the dataSource
                let notBlockedMemberRef = ref.child(thisMember.id!)
                notBlockedMemberRef.removeValue()
                
                cell?.memberName.textColor = unblocked().color
                cell?.memberName.text = "\(self.members[indexPath.row].firstname!) \(self.members[indexPath.row].lastname!)"
                
                self.tableView.reloadData()
                self.reloadMembers()
                })
            
            }else{
                
                blockAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Block", handler: {(action, indexPath)-> Void in
                // for main database
                    let memberItem =
                        Member(username: thisMember.username!, userImageUrl: thisMember.userImageUrl!, id: thisMember.id!, firstname: thisMember.firstname!, lastname: thisMember.lastname!, email: thisMember.email!, telephone: thisMember.telephone!, bio: thisMember.bio!, role: thisMember.role!, birthday: thisMember.birthday!, anniversary: thisMember.anniversary!, profession: thisMember.profession!, address: thisMember.address!, gender: thisMember.gender!, status: thisMember.status!, work: thisMember.work!, currentLevelStatus: thisMember.status!, allergies: thisMember.allergies!, hobbies: thisMember.hobbies!, parentName: thisMember.parentName!, parentUserName: thisMember.parentUserName!, parentUid: thisMember.parentUid!, parentImage: thisMember.parentImage!, parentEmail: thisMember.parentEmail!, parentTelephone: thisMember.parentTelephone!, parentWorkTelephone: thisMember.parentWorkTelephone!, studentSelected: thisMember.studentSelected!)
                
                //self.blogs.insert(blogItem, at: 0)
                let memberItemRef = ref.child(thisMember.id!)
                memberItemRef.setValue(memberItem.toAnyObject())
            
                    cell?.memberName.textColor = blocked().color
                    cell?.memberName.text = "\(self.members[indexPath.row].firstname!) \(self.members[indexPath.row].lastname!) \(blocked().blocked)"
                    
                    self.tableView.reloadData()
                    self.reloadMembers()
                    //self.messages.remove(at: indexPath.row)
                    //self.tableView.deleteRows(at: [indexPath], with: .fade)
                })
                
            }
        
    
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        var action = [Any]()
        if self.group.groupCreatorUID == FIRAuth.auth()?.currentUser?.uid || FIRAuth.auth()?.currentUser?.uid == administrator {
            action = [deleteAction, blockAction]
        }else {
            action =  [Any]()
        }
        return action as? [UITableViewRowAction]
    }
    
    //end----
    func reloadMembers(){
        self.tableView.reloadData()
    }
    
    func postMember(){
        // posts in the Group Members section
        
        
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
