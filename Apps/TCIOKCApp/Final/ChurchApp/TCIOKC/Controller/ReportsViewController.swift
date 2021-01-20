//
//  ReportsViewController.swift
//  ChurchAppOne
//
//  Created by Quinton Quaye on 11/9/18.
//  Copyright © 2018 Transformation Church International. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    
    var complaints: [Complaint] = []
    var newComplaints: [Complaint] = []
    var creators: [Member] = []
    func getSocial(){
        FIRDatabase.database().reference().child("Complaints").child("Social").observe(.value, with: {snapshot in
            
            var newSocial : [Complaint] = []
            for item in snapshot.children {
                let complaintItem = Complaint(snapshot: item as! FIRDataSnapshot)
                newSocial.insert(complaintItem, at: 0)
            }
            self.newComplaints += newSocial
            
            print("inserted social")
        })
    }
    
    func getProfile(){
        FIRDatabase.database().reference().child("Complaints").child("Profile").observe(.value, with: {snapshot in
            
            var newProfile: [Complaint] = []
            for item in snapshot.children {
                let complaintItem = Complaint(snapshot: item as! FIRDataSnapshot)
                newProfile.insert(complaintItem, at: 0)
            }
            self.newComplaints += newProfile
             print("inserted Profile")
        })
    }
    
    
    func getGroup(){
        FIRDatabase.database().reference().child("Complaints").child("Group").observe(.value, with: {snapshot in
            var newGroups: [Complaint] = []
            for item in snapshot.children {
                let complaintItem = Complaint(snapshot: item as! FIRDataSnapshot)
                newGroups.insert(complaintItem, at: 0)
            }
            self.newComplaints += newGroups
            
             print("inserted Group")
            self.complaints = self.newComplaints
            self.complaints = self.complaints.sorted(by: {
                $0.complaintDate!.compare($1.complaintDate!) == .orderedDescending
            })
            self.tableView.reloadData()
            print("the total items from each area: \(self.complaints.count)")
        })
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       
        // for every app member
        FIRDatabase.database().reference().child("members").observe(.value, with: {(snapshot) in
            
            var thisMember: [Member] = []
            for item in snapshot.children{
                print(item)
                let memberItem = Member(snapshot: item as! FIRDataSnapshot)
                thisMember.append(memberItem)
            }
                self.creators = thisMember
            
        }, withCancel: nil)
        
        
        // --------------
       
    }
    
    @IBAction func unwindToReportsViewController(segue: UIStoryboardSegue){
        let indexPath = tableView.indexPathForSelectedRow
        tableView.scrollToRow(at: indexPath!, at: UITableViewScrollPosition.middle, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // the information Button
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(information), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
        
        let barButton = UIBarButtonItem.init(customView: button)
        //self.navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = UIColor.blue
        
        
        self.navigationItem.setRightBarButtonItems([barButton], animated: true)
        
        
        complaints = []
        newComplaints = []
        //social
        getSocial()
        
        //profile
        getProfile()
        
        //group
        getGroup()
        self.tableView.reloadData()
        
    }
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addBackButton()
        // the information Button
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(information), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
        
        let barButton = UIBarButtonItem.init(customView: button)
        //self.navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = UIColor.blue
        
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(somefunc))
        
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem, barButton], animated: true)
        
        // Do any additional setup after loading the view.
    }

    
    @objc func somefunc(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return complaints.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as?
        ComplaintTableViewCell
        let thisComplaint = complaints[indexPath.row]
        cell?.getComplaint(complaint: thisComplaint)
        
        for creator in creators{
            if thisComplaint.reporterUID == creator.key{
        cell?.plaintiffImage.loadImageUsingCacheWithURLString(urlString: creator.userImageUrl!)
            }
        }
        
        
        cell?.plaintiffImage.layer.cornerRadius = 30
        cell?.plaintiffImage.layer.masksToBounds = true
        
        if thisComplaint.isResolved == "true"{
            cell?.backgroundColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
            cell?.complaintDate.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell?.complaintType.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell?.plaintiffName.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else{
            cell?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cell?.complaintDate.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell?.complaintType.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell?.plaintiffName.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "SocialComplaintDetails") as! ReportsDetailViewController
        
        destinationController.complaint = complaints[indexPath.row]
        destinationController.creators = creators
        self.navigationController?.pushViewController(destinationController, animated: true)
    }
    
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
    
    // for deleting personal posts
    
    
    /* deleting cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let thisComplaint = complaints[indexPath.row]
            let complaintRef = FIRDatabase.database().reference(withPath: "Complaints").child("\(thisComplaint.complaintType!)").child(thisComplaint.key)
            
            complaintRef.removeValue()
            self.complaints.remove(at: indexPath.row)
        }
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let thisComplaint = complaints[indexPath.row]
        
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: {(action, indexPath)-> Void in
            // Delete the row from the dataSource
            
            
            let complaintRef = FIRDatabase.database().reference(withPath: "Complaints").child("\(thisComplaint.complaintType!)").child(thisComplaint.key)
            
            complaintRef.removeValue()
            
            self.complaints.remove(at: indexPath.row)
            self.tableView.reloadData()
            //self.messages.remove(at: indexPath.row)
            //self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        })
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction]
    }
    
    //end----
    */
    
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
