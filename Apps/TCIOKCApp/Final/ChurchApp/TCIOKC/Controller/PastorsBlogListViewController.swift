//
//  PastorsBlogListViewController.swift
//  ChurchAppOne
//
//  Created by Quinton Quaye on 10/17/18.
//  Copyright © 2018 Transformation Church International. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct Pastor{
    var key: String?
    var ref: FIRDatabaseReference?
    var pastorImage: String?
    var firstName: String?
    var lastName: String?
    var pastorTitle: String?
    var creatorId: String?
    
    init(key: String = "", pastorImage: String, firstName: String, lastName: String, pastorTitle: String, creatorId: String?){
        self.key = key
        self.pastorImage = pastorImage
        self.firstName = firstName
        self.lastName = lastName
        self.pastorTitle = pastorTitle
        self.creatorId = creatorId
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot){
        key = snapshot.key
        ref = snapshot.ref
        var snapShotValue = snapshot.value as! [String: AnyObject]
        pastorImage = snapShotValue["pastorImage"] as? String
        firstName = snapShotValue["pastorFirstName"] as? String
        lastName = snapShotValue["pastorLastName"] as? String
        pastorTitle = snapShotValue["pastoralTitle"] as? String
        creatorId = snapShotValue["creatorId"] as? String
    }
    
    func toAnyObject() -> Any{
        return [
            "pastorImage": pastorImage!,
            "pastorFirstName": firstName!,
            "pastorLastName": lastName!,
            "pastoralTitle": pastorTitle!,
            "creatorId": creatorId!
        ]
    }
    
}

class PastorsBlogListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var pastorImage = ""
    var pastorTitle = ""
    var pastorFirstName = ""
    var pastorLastName = ""
    var administrator = ""
    var associate = ""
    var pastors: [Pastor] = []
    
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "hasViewedPastoralWalkthrough"){
            return
        }
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            present(pageViewController, animated: true, completion: nil)
            
            pageViewController.viewingPastoralWalkthrough = true
        }
    }
    
    @IBAction func unwindToPastorsList(segue: UIStoryboardSegue){
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        //.......
        
        if FIRAuth.auth()?.currentUser?.uid == self.administrator {
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
            button.addTarget(self, action:#selector(informationButton), for:.touchUpInside)
            button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
            let barButton = UIBarButtonItem.init(customView: button)
            //self.navigationItem.rightBarButtonItem = barButton
            barButton.tintColor = UIColor.blue
            
            let rightAddBarButtonItem:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addPastor))
            
            self.navigationItem.setRightBarButtonItems([rightAddBarButtonItem, barButton], animated: true)
        } else {
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage.init(named: "Information button"), for: UIControlState.normal)
            button.addTarget(self, action:#selector(informationButton), for:.touchUpInside)
            
            button.frame = CGRect.init(x: 0, y: 0, width: 24, height: 24) //CGRectMake(0, 0, 30, 30)
            let barButton = UIBarButtonItem.init(customView: button)
            barButton.tintColor = UIColor.blue
            self.navigationItem.rightBarButtonItem = barButton
            
        }
        
         //.......
        
        
        
        let pastorRef = FIRDatabase.database().reference()
        
        pastorRef.child("blog-items").child("pastors").observe(.value, with: { snapshot in
            
        
            var thisNewPastor: [Pastor] = []
            /*
            for i in snapshot.children{
                for ii in (i as AnyObject).children {
                    print(ii)
                    let thisInfo = (ii as AnyObject).key!
                    if thisInfo == "info"{
                        print(ii)
                        let info = Pastor(snapshot: ii as! FIRDataSnapshot)
                        thisNewPastor.append(info)
                    }
                }
            }
 */

            
            self.pastors = thisNewPastor
            self.tableView.reloadData()
        })
        
        // Do any additional setup after loading the view.
    }

    
    
    @objc func addPastor(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "AddPastorTableViewController") as! AddPastorTableViewController
        
        //self.present(controller, animated: true, completion: nil)
        show(controller, sender: self)
    }
    
    
    @objc func informationButton() {
        UserDefaults.standard.set(false, forKey: "hasViewedPastoralWalkthrough")
        information()
    }
    
    
    func information(){
        print("Calling Information")
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "WalkthroughController") as? walkthroughPageViewController {
            pageViewController.viewingPastoralWalkthrough = true
            present(pageViewController, animated: true, completion: nil)
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pastors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? PastorsListTableViewCell
        
        let thisPastor = pastors[indexPath.row]
        cell?.getPastor(pastor: thisPastor)
        
        cell?.pastorImage.layer.cornerRadius = 37.5
        cell?.pastorImage.layer.masksToBounds = true
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowPastor", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // deleting cells
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SocialTableViewCell
        
        //let thisClass = blogs[indexPath.row]
        
        if FIRAuth.auth()?.currentUser?.uid == administrator {
            if editingStyle == .delete{
                self.pastors.remove(at: indexPath.row)
                let thisPastor = pastors[indexPath.row]
                
                let pastorRef = FIRDatabase.database().reference(withPath: "blog-items").child("pastors").child("\(thisPastor.firstName!)\(thisPastor.lastName!)")
                
                pastorRef.removeValue()
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let thisPastor = pastors[indexPath.row]
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler: {(action, indexPath)-> Void in
            // Delete the row from the dataSource
            
            
            let pastorRef = FIRDatabase.database().reference(withPath: "blog-items").child("pastors").child("\(thisPastor.firstName!)\(thisPastor.lastName!)")
            
            pastorRef.removeValue()
            
            self.pastors.remove(at: indexPath.row)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPastor"{
            if let indexPath = tableView.indexPathForSelectedRow{
                let destinationController = segue.destination as! PastorialBlogViewController
                
                destinationController.pastor = pastors[indexPath.row]
                destinationController.administrator = administrator
            }
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
