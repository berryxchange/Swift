//
//  BibleViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 2/25/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class BibleViewController: UIViewController, bibleModelDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
        // for server info...
        var bibles: [Books] = [Books]()
        var verses: [Chapters] = [Chapters]()
        var selectedBook: Books?
        //let model: BibleModel = BibleModel()
        let model: NewBibleModel = NewBibleModel() // the model we are using!!!!
        //var jsonLink = ""
        var bibleVersion = ""
        
        var data = MinistryData()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.model.delegate = self
            //self.videos = model.getVideos()
            
            // fire off request to get videos
            //model.thisBibleURL = jsonLink
            model.thisBibleVersion = bibleVersion
            //print(model.thisBibleURL)
            model.getBibleFeed()
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        //MARK: - VideoModel Delegate Methods
        
        func dataReady() {
            // Access the video objects that have beeen downloaded
            
            self.bibles = self.model.booksOfBible
            self.verses = self.model.chaptersOfBible
            // tell the tableView to reload
            self.tableView.reloadData()
        }
        
        //MARK: - TableView Delegate Methods
        
        
        // MARK: - Table view data source
        
        func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return bibles.count
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as?
            BibleTableViewCell
            
            let thisBible = bibles[indexPath.row]
            cell?.getBooks(book: thisBible)
            
        
            
            return cell!
        }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(bibles[indexPath.row].chapter)
        performSegue(withIdentifier: "ShowChapters", sender: self)
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
            if segue.identifier == "ShowChapters" {
                if let indexPath = tableView.indexPathForSelectedRow {
                    
                    let destinationController = segue.destination as!
                    BibleChaptersTableViewController
                    
                    //destinationController.books = bibles
                    
                    destinationController.chapters = bibles[indexPath.row].chapters
                    destinationController.title = bibles[indexPath.row].name
                    
                }
            }
        }
}



