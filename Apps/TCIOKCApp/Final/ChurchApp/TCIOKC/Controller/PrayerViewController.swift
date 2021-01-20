//
//  PrayerViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class PrayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var data = MinistryData()
    var prayers: [Prayer] = []
    var user: ChurchUser!
    var administrator = ""
    var associate = ""
    var regular = ""
    
    @IBOutlet weak var prayerImage: UIImageView!
    @IBOutlet weak var prayerTitle: UILabel!
    
    
    
    // add post constraints
    
    
    
    var pImage = "prayer"
    var pTitle = "TCI Prayer Wall"

    let ref = FIRDatabase.database().reference(withPath: "prayer-items")
    let usersRef = FIRDatabase.database().reference(withPath: "users")
    
    
    @IBAction func unwindToPrayerList(segue: UIStoryboardSegue){
        self.tableView.reloadData()
        /*
    if segue.source is PrayerDetailViewController{
            if let receivingDestination = segue.source as? PrayerDetailViewController {
                let ref = FIRDatabase.database().reference().child("prayer-items/\(receivingDestination.pTitle.lowercased())")
                
                let post = ["prayerPostAgreements": receivingDestination.agreements] as [String : Any]
               let agreements = receivingDestination.agreements
                self.tableView.reloadData()
                ref.updateChildValues(post)
                self.tableView.reloadData()
                print("unwinded \(agreements) agreements")
            }
        }
 */
    }
 
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "hasViewedPrayerWalkthrough"){
            return
        }
        
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            pageViewController.viewingPrayerWalkthrough = true
            present(pageViewController, animated: true, completion: nil)
            
            
        }
        
    }
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
        button.addTarget(self, action:#selector(informationButton), for:.touchUpInside)
        button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
        let barButton = UIBarButtonItem.init(customView: button)
        //self.navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = UIColor.blue
        
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPastoralBlog))
        
        self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem, barButton], animated: true)
        
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        print("This is the Admin: \(administrator)")
        print("This is the Associate: \(associate)")
        
        prayerImage.image = UIImage(named: pImage)
        prayerTitle.text = pTitle
        
        
        
        // Firebase Auth//
        
        // this listens for changes in the values of the database (added, removed, changed)
        //1 - reviews data
        // queryOrdered(byChild:) allows to arrange children in list by "style"
        //ref.observe(.value, with: {snapshot in
        ref.queryOrdered(byChild: "prayerFullDate").observe(.value, with: {snapshot in
        
            //2 new items are an empty array
            var newPrayers: [Prayer] = []
            
            //3 - for every item in snapshot as a child, the groceryItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                let blogItem = Prayer(snapshot: item as! FIRDataSnapshot)
                newPrayers.insert(blogItem, at: 0)
                
            }
            
            // 5 - the main "blogss" are now the adjusted "newBlogs"
            self.prayers = newPrayers
            self.tableView.reloadData()
            
        })
        
        tableView.allowsSelectionDuringEditing = false
        
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as?
        PrayerTableViewCell
        
        // to load the user on the post
        let prayer = prayers[indexPath.row]
        cell?.getPrayer(prayer: prayer)
        
        print(prayer.prayerFullDate)
        return cell!
    }

    
    // deleting cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SocialTableViewCell
        
        let thisPrayer = prayers[indexPath.row]
        
        if FIRAuth.auth()?.currentUser?.uid == administrator {
            if editingStyle == .delete{
                self.prayers.remove(at: indexPath.row)
                let thisPrayer = prayers[indexPath.row]
                
                let prayersRef = FIRDatabase.database().reference(withPath: "prayer-items").child(thisPrayer.key)
                
                prayersRef.removeValue()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let thisPrayer = prayers[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: {(action, indexPath)-> Void in
            // Delete the row from the dataSource
            
            
            let prayersRef = FIRDatabase.database().reference(withPath: "prayer-items").child(thisPrayer.key)
            
            prayersRef.removeValue()
            
            self.prayers.remove(at: indexPath.row)
            self.tableView.reloadData()
            //self.messages.remove(at: indexPath.row)
            //self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        })
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        var action = [Any]()
        if FIRAuth.auth()?.currentUser?.uid == self.administrator {
            action = [deleteAction]
        }else {
            action =  [Any]()
        }
        return action as? [UITableViewRowAction]
    }
    
    //end----
    
    
    
    
    @objc func addPastoralBlog() {
        performSegue(withIdentifier: "AddPrayerSegue", sender: self)
    }
    
    
    @objc func informationButton() {
        UserDefaults.standard.set(false, forKey: "hasViewedPrayerWalkthrough")
        information()
    }
    
    
    func information(){
        print("Calling Information")
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            pageViewController.viewingPrayerWalkthrough = true
            present(pageViewController, animated: true, completion: nil)
            
            
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowPrayerDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as!
                PrayerDetailViewController
                destinationController.prayerDatabase = prayers[indexPath.row]
                destinationController.pTitle = prayers[indexPath.row].prayerPostTitle
                destinationController.pMessage = prayers[indexPath.row].prayerPostMessage
                destinationController.agreements = prayers[indexPath.row].prayerPostAgreements
                destinationController.prayerPersonName = prayers[indexPath.row].byUserName
                destinationController.postDateMonth = prayers[indexPath.row].prayerPostDateMonth
                destinationController.postDateDay = prayers[indexPath.row].prayerPostDateDay
                destinationController.postFullDate = prayers[indexPath.row].prayerFullDate
                destinationController.byUser = prayers[indexPath.row].byUserName
                destinationController.prayers = [prayers[indexPath.row]]
                destinationController.prayerKey = prayers[indexPath.row].key
            }
        }
    }
}


