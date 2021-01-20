//
//  someClassViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/17/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase


class someClassViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var attendancePad: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var attendancePadBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var takeAttendancePad: UIView!
    
    @IBOutlet weak var takeAttendanceButton: UIButton!
    
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var submitAttendacneButton: UIButton!
    
    //reading from groups
    var category = ""
    var group: Group!
    var thisClassMembers: [Member] = []
    var stringOfProfileImageView = ""
    var stringOfProfileName = ""
    var stringOfUid = ""
    
    //
    var thisClass: [ClassRoom] = []
    
    var thisClassName = ""
    var thisGroupKey = ""
    var takingAttendance = false
    var studentSelected = false
    var presentMembers : [Member] = []
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    
    @IBAction func unwindToClass(segue: UIStoryboardSegue){
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // visuals
        self.collectionView.alwaysBounceVertical = true;

        attendancePad.layer.shadowOpacity = 0.5
        attendancePad.layer.shadowOffset = CGSize.zero
        attendancePad.layer.shadowRadius = 5.0
        attendancePad.layer.masksToBounds = false
        
        
        takeAttendanceButton.layer.cornerRadius = 20
        takeAttendanceButton.layer.masksToBounds = true
        submitAttendacneButton.layer.cornerRadius = 20
        submitAttendacneButton.layer.masksToBounds = true
        //end------
        
        attendancePadBottomConstraint.constant = -100
        
        // for class array
        let MemberRef = FIRDatabase.database().reference().child("Categories").child(group.category!.lowercased()).child("Groups").child(group.key).child("Members")
        
        MemberRef.queryOrdered(byChild: "lastname").observe(.value, with: {snapshot in
            
            print(snapshot)
            //2 new items are an empty array
            var newMember: [Member] = []
            
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                
                let memberItem = Member(snapshot: (item as? FIRDataSnapshot)!)
                newMember.insert(memberItem, at: 0)
                
                self.thisClassMembers = newMember
                self.collectionView.reloadData()
                self.navigationItem.title = "(\(self.thisClassMembers.count)) Students"
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

     func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return thisClassMembers.count
    }

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? someClassCell
    
        // Configure the cell
       let thisStudent = thisClassMembers[indexPath.row]
        cell?.studentName.text = "\(thisStudent.firstname!) \(thisStudent.lastname!)"
        
        
        if let userImageUrl = thisStudent.userImageUrl {
            cell?.studentImage.loadImageUsingCacheWithURLString(urlString: userImageUrl)
        }
        
        if cell?.studentImage == nil {
            cell?.studentImage.image = UIImage(named: "pastor")
        }
        
         if thisStudent.studentSelected == false{
            cell?.studentImageOverlay.isHidden = true
            cell?.studentImageCheckmark.isHidden = true
         }else{
            cell?.studentImageOverlay.isHidden = false
            cell?.studentImageCheckmark.isHidden = false
        }

        cell?.studentImage.layer.cornerRadius = 4
        cell?.studentImage.layer.masksToBounds = true
        
        print("items are shown")
        
        return cell!
    }

    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            //---
            
            if takingAttendance == false {
                //let studentRef = FIRDatabase.database().reference().child("Classes").child("\(thisClassName.lowercased())").child("Student")
                
                let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "StudentDetailController") as!
                StudentViewController
                
                let thisStudent = thisClassMembers[indexPath.row]
                
                print(thisStudent)
                
                destinationController.sAge = "\(thisClassMembers[indexPath.row].birthday!)"
                //print(thisStudent.studentFirstName!)
                
                destinationController.sFirstName = "\( thisClassMembers[indexPath.row].firstname!)"
                
                destinationController.sLastName = "\(thisClassMembers[indexPath.row].lastname!)"
                
                //print(thisStudent.studentImage!)
                destinationController.sImage = thisClassMembers[indexPath.row].userImageUrl!
                
                //destinationController.thisGroupKey = thisGroupKey
                
                destinationController.stringOfProfileUid = thisClassMembers[indexPath.row].key
                
                // parent data
                destinationController.parentUserName = thisClassMembers[indexPath.row].parentUserName!
                
                destinationController.parentId = thisClassMembers[indexPath.row].parentUid!
                destinationController.parentName = thisClassMembers[indexPath.row].parentName!
                destinationController.parentImage = thisClassMembers[indexPath.row].parentImage!
                destinationController.parentEmail = thisClassMembers[indexPath.row].parentEmail!
                destinationController.parentTelephone = thisClassMembers[indexPath.row].parentTelephone!
                
                    destinationController.thisGroup = group
                
                print("group category: \(group.category!) group member: \(thisClassMembers[indexPath.row].key) thisGroupKey: \(group.key)")
                destinationController.thisGroupMember = self.thisClassMembers[indexPath.row]
                self.navigationController?.pushViewController(destinationController, animated: true)
                
                
            }else if takingAttendance == true {
                // for adding visual items to the studentCell
                let cell = collectionView.cellForItem(at: indexPath) as? someClassCell
                
                //1 state the student location for edits
                let MemberRef = FIRDatabase.database().reference().child("Categories").child(category.lowercased()).child("Groups").child(group.key).child("Members").child(thisClassMembers[indexPath.row].key)
                
                //let studentRef = FIRDatabase.database().reference().child("Classes").child("\(thisClassKey)").child("Student").child(thisClassStudent[indexPath.row].key)
                
                //2 make conditions
                
                if thisClassMembers[indexPath.row].studentSelected == false{
                    cell?.studentImageOverlay.isHidden = false
                    cell?.studentImageCheckmark.isHidden = false
                    
                    //3 update the conditions
                    let post = ["studentSelected": true]
                    MemberRef.updateChildValues(post)
                    
                    
                }else{
                    
                    cell?.studentImageOverlay.isHidden = true
                    cell?.studentImageCheckmark.isHidden = true
                    
                    //3 update the conditions
                    let post = ["studentSelected": false]
                    MemberRef.updateChildValues(post)
                }
            }
            
            //---
            
        
    }
    
    // time formats
    // for month
    let date = Date()
    let monthFormatter = DateFormatter()
    // for day
    let dayFormatter = DateFormatter()
    //for the full date
    let dateFormatter  = DateFormatter()
    let identifierDate = DateFormatter()
    
    @IBAction func takeAttendanceButton(_ sender: Any) {
        attendancePadBottomConstraint.constant = 0
        collectionViewBottomConstraint.constant = 25
        takingAttendance = true
        
    }
    
    @IBAction func submitAttendanceButton(_ sender: Any) {
        for item in thisClassMembers{
        
            let MemberAttendanceRef = FIRDatabase.database().reference().child("Categories").child(category.lowercased()).child("Groups").child(group.key).child("Members").child(item.key)
            
        //let studentAttendanceRef = FIRDatabase.database().reference().child("Classes").child(thisClassKey).child("Student").child("\(item.key)")
            
            //for time format
            monthFormatter.dateFormat = "MMM dd, yyyy"
            dayFormatter.dateFormat = "dd"
            dateFormatter.dateFormat = "MM/dd/yyyy"
            identifierDate.dateStyle = .short
            //dateFormatter.timeStyle = .short
            
            var memberStatus = ""
           
            if item.studentSelected == true{
                memberStatus = "Present"
                
                let post = ["attendanceDate": self.dateFormatter.string(from: self.date),
                            "attendanceStatus": memberStatus]
                
                let memberAttendance = MemberAttendanceRef.child("Attendance Record").child(self.monthFormatter.string(from: self.date))
                memberAttendance.updateChildValues(post)
                
                let selectionPost = ["studentSelected": false]
                MemberAttendanceRef.updateChildValues(selectionPost)
                
                collectionView.reloadData()
                    //print("this name is already present")
            }else {
                
                memberStatus = "Absent"
                let post = ["attendanceDate": self.dateFormatter.string(from: self.date),
                            "attendanceStatus": memberStatus]
                let memberAttendance = MemberAttendanceRef.child("Attendance Record").child(self.monthFormatter.string(from: self.date))
                memberAttendance.updateChildValues(post)
            }
            
            
            
            
        attendancePadBottomConstraint.constant = -100
        collectionViewBottomConstraint.constant = 0
        takingAttendance = false
        studentSelected = false
        //presentStudents = []
        //print("here are the present students: \([presentStudents])")
            
        }
        presentMembers = []
        collectionView.reloadData()
        
    }
    @IBAction func cancelAttendance(_ sender: Any) {
        attendancePadBottomConstraint.constant = -100
        collectionViewBottomConstraint.constant = 0
        takingAttendance = false
        studentSelected = false
        presentMembers = []
        collectionView.reloadData()
        for item in thisClassMembers{
            let MemberAttendanceRef = FIRDatabase.database().reference().child("Categories").child(category.lowercased()).child("Groups").child(group.key).child("Members").child(item.key)
            
            let selectionPost = ["studentSelected": false]
            MemberAttendanceRef.updateChildValues(selectionPost)
            
            collectionView.reloadData()
        }
    }
    
    
    
    
    
    
    @IBAction func AddStudentButton(_ sender: Any) {
        
       
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "ChooseTypeOfStudent") as!
        ChooseUsersViewController
        
        destinationController.group = group
        
        self.navigationController?.show(destinationController, sender: self)
        
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
