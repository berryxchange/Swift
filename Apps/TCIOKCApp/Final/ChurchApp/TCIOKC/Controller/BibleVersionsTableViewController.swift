//
//  BibleVersionsTableViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 3/1/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class BibleVersionsTableViewController: UITableViewController {
   
    
    var bibleVersions = ["American Standard Version", "King James Version", "King James Version (1769)\n including Apocrypha", "和合本 (简体字)", "New English Translation", "English Standard Version"]
    var bibleVersionsAddresses = ["https://firebasestorage.googleapis.com/v0/b/TCIApp.appspot.com/o/bibleJsonFiles%2FASV.json?alt=media&token=4a954bb5-d9e5-456f-9090-d53e7895c85a", "https://firebasestorage.googleapis.com/v0/b/TCIApp.appspot.com/o/bibleJsonFiles%2FBiblekjv.json?alt=media&token=afaad37b-ac91-499a-960d-e6c984dc4057", "https://firebasestorage.googleapis.com/v0/b/TCIApp.appspot.com/o/bibleJsonFiles%2FKJVA.json?alt=media&token=458ad502-8545-418c-9d78-20b20fa89012", "https://firebasestorage.googleapis.com/v0/b/TCIApp.appspot.com/o/bibleJsonFiles%2FChiUns.json?alt=media&token=0c3395d4-c57c-4251-af85-610400f3e0b7"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 1000
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
        return bibleVersions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as?
            BibleVersionsTableViewCell
        
        cell?.bibleVersionName.text = bibleVersions[indexPath.row]
        cell?.bibleVersionName.textAlignment = .center
        cell?.bibleVersionName.lineBreakMode = .byWordWrapping
        cell?.bibleVersionName.numberOfLines = 0
        cell?.bibleVersionImage.image = UIImage(named: "bible")
        // Configure the cell...

        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let storyboard = UIStoryboard(name: "Main", bundle: nil)
       // let controller = storyboard.instantiateViewController(withIdentifier: "BibleBooksViewController") as UIViewController
        
        //self.present(controller, animated: true, completion: nil)
        //show(controller, sender: self)
        performSegue(withIdentifier: "BibleBooksViewController", sender: self)
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
        if segue.identifier == "BibleBooksViewController"{
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as!
                BibleViewController
                
                switch bibleVersions[indexPath.row]{
                case "American Standard Version":
                    destinationController.bibleVersion = "ASV"
                case "King James Version":
                    destinationController.bibleVersion = "KJV"
                case "King James Version (1769)\n including Apocrypha":
                    destinationController.bibleVersion = "KJVA"
                case "和合本 (简体字)":
                    destinationController.bibleVersion = "ChiUns"
                case "New English Translation":
                    destinationController.bibleVersion = "NETfree"
                case "English Standard Version":
                    destinationController.bibleVersion = "ESV"
                default:
                break
                }
                //destinationController.jsonLink = self.bibleVersionsAddresses[indexPath.row]
            }
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
