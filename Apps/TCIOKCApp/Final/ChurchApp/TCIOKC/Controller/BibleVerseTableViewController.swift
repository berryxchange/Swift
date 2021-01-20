//
//  BibleVerseTableViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 2/26/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class BibleVerseTableViewController: UITableViewController {

    var verses: [AnyObject] = []
    var books: [Books] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // for self sizing cell
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 1000
        
        print(verses.count)
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
        return verses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? VerseTableViewCell

        //*****************  The Correct code to access the root verse material!! *******************
         /*let verseName = verses[indexPath.row] as! [AnyObject]
        for verse in verseName {
            //print(verse["name"] as! String)
            
           cell?.chapterNameAndVerse.text = verse["name"] as? String
            
           cell?.verseText.text = verse["text"] as? String
            
        }
 */
        
        if let verseName = verses[indexPath.row] as? [String: AnyObject]{
            print(verseName)
            cell?.verseText.text = "\(String(describing: verseName["text"]!))"
            cell?.chapterNameAndVerse.text = "\(String(describing: verseName["name"]!))"
        //for verse in verseName {
            //print(verse["name"] as! String)
            
            //cell?.chapterNameAndVerse.text = verseName.v["name"] as? String
            
           // cell?.verseText.text = verse.value["text"] as? String
            
            //}
        }
        
        
        
        
        
        
        //let thisVerseLabel = verseName[indexPath.row]["name"] as? String
        
        //print(thisVerseLabel!)
        
       // cell?.chapterNameAndVerse.text = thisVerseLabel
        
       // let thisVerseText = verseName[indexPath.row]["text"] as? String
        //cell?.verseText.text = thisVerseText
        
        // Configure the cell...
        
        //cell?.chapterNameAndVerse.text = thisVerseLabel as? String
        
        //cell?.getVerse(verse: thisVerse, verseTitle: thisVerseLabel )
        return cell!
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(verses)
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
