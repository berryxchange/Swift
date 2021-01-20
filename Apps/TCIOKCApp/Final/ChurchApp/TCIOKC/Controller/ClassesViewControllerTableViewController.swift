//
//  ClassesViewControllerTableViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/17/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase

class ClassesViewControllerTableViewController: UITableViewController {

    
    var administrator = ""
    var associate = ""
    var regular = ""
    var classes: [ClassRoom] = []
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "hasViewedClassWalkthrough"){
            return
        }
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            present(pageViewController, animated: true, completion: nil)
            
            pageViewController.viewingClassWalkthrough = true
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
        
        let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(AddClassButton))
        
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
        
        
        self.hideKeyboardWhenTappedAround()
        // for class array
        let classRef = FIRDatabase.database().reference().child("Classes")
        
        classRef.queryOrdered(byChild: "className").observe(.value, with: {snapshot in
            
            print(snapshot)
            //2 new items are an empty array
            var newClass: [ClassRoom] = []
            
            //3 - for every item in snapshot as a child, the eventItem will be appended in the new items array list
            for item in snapshot.children {
                // 4
                
                let ClassItem = ClassRoom(snapshot: item as! FIRDataSnapshot)
                newClass.insert(ClassItem, at: 0)
                
                self.classes = newClass
                self.tableView.reloadData()
            }
        })
        
        
        
       
        
        
        //end-----------
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return classes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ClassesCell

        // Configure the cell...
        let thisClass = classes[indexPath.row]
        cell?.getClass(thisClass: thisClass)
        
        return cell!
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowSpecificClass", sender: self)
    }

    
    
    @objc func AddClassButton() {
        performSegue(withIdentifier: "AddClassSegue", sender: self)
    }
    
    
    // deleting cells
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SocialTableViewCell
        
        let thisClass = classes[indexPath.row]
        
        if thisClass.classTeacher == FIRAuth.auth()?.currentUser?.uid || FIRAuth.auth()?.currentUser?.uid == administrator {
            if editingStyle == .delete{
                self.classes.remove(at: indexPath.row)
                let thisClass = classes[indexPath.row]
                
                let classRef = FIRDatabase.database().reference(withPath: "Classes").child(thisClass.key)
                
                classRef.removeValue()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        }
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let thisClass = classes[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: {(action, indexPath)-> Void in
            // Delete the row from the dataSource
            
            
            let classRef = FIRDatabase.database().reference(withPath: "Classes").child(thisClass.key)
            
            classRef.removeValue()
            
            self.classes.remove(at: indexPath.row)
            self.tableView.reloadData()
            //self.messages.remove(at: indexPath.row)
            //self.tableView.deleteRows(at: [indexPath], with: .fade)
            
        })
        
        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        var action = [Any]()
        if thisClass.classTeacher == FIRAuth.auth()?.currentUser?.uid || FIRAuth.auth()?.currentUser?.uid == self.administrator {
            action = [deleteAction]
        }else {
            action =  [Any]()
        }
        return action as? [UITableViewRowAction]
    }
    
    //end----
    
   
    
    //end-----
    
    
    @objc func informationButton() {
        UserDefaults.standard.set(false, forKey: "hasViewedClassWalkthrough")
        information()
    }
    
    
    func information(){
        print("Calling Information")
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            pageViewController.viewingClassWalkthrough = true
            present(pageViewController, animated: true, completion: nil)
            
            
        }
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowSpecificClass"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as!
                someClassViewController
                
                destinationController.thisClassName = classes[indexPath.row].className
                
                destinationController.thisClass = [classes[indexPath.row]]
                destinationController.thisGroupKey = classes[indexPath.row].key
            }
        }
    }
    

}
