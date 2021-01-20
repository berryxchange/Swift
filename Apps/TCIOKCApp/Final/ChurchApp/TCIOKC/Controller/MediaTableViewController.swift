//
//  MediaTableViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit

class MediaTableViewController: UITableViewController, videoModelDelegate, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate{

    
    //for class videos
    var isClass = false
    // for server info...
    var videos: [Video] = [Video]()
    var selectedVideo: Video?
    let model: VideoModel = VideoModel()
    
    var data = MinistryData()
    
    var searchController: UISearchController!
    var searchResults : [Video] = []
    var searchContent = ""
    
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
        
        self.model.delegate = self
        //self.videos = model.getVideos()
        
        
        // use with search
        // fire off request to get videos
        if isClass == true{
            searchController = UISearchController(searchResultsController: nil)
            tableView.tableHeaderView = searchController.searchBar
            
            searchController.searchResultsUpdater = self
            self.searchController.delegate = self
            searchController.dimsBackgroundDuringPresentation = false
            
            model.isClass = true
            model.getVideoFeed(title: searchContent)
        }else{
            model.isClass = false
            model.getVideoFeed(title: "")
        }
        //...
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isClass == true{
        }else{
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(addTapped))
        }
    }
    
    @objc func addTapped(){
        performSegue(withIdentifier: "UnwindToMainController", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - VideoModel Delegate Methods
    
    func dataReady() {
        // Access the video objects that have beeen downloaded
        
        self.videos = self.model.videoArray
        // tell the tableView to reload
        self.tableView.reloadData()
    }
    
    //MARK: - TableView Delegate Methods
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var count : Int?
        if isClass == true{
            if searchController.isActive {
                count = searchResults.count
            }else {
                count = 0
            }
        }else{
            count = videos.count
        }
        return count!
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as?
        MediaTableViewCell
        if isClass == true{
            let thisVideo = searchResults[indexPath.row]
            
            if searchController.isActive{
                
                cell?.getMedia(video: thisVideo)
            }else{
                //do nothing
                
            }
            
        }else{
            let thisVideo = videos[indexPath.row]
            cell?.getMedia(video: thisVideo)
        }
        
        
        
        // Construct a video thumbnail url
        //let videoThumbnailURLString = "https://i.ytimg.com/vi/" + thisVideo.videoId + "/mqdefault.jpg"
        
        return cell!
    }
    
    func filterContent(for searchText: String){
        // put the searchContent in the search text
        searchContent = searchText
        // then
        
        searchResults = videos.filter({ (video) -> Bool in
            
            let thisVideoName: String? = "\(video.videoTitle!)"
            
            if let videoName = thisVideoName{
                let isMatch = videoName.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            searchResults = []
            tableView.reloadData()
            model.isClass = true
            model.getVideoFeed(title: searchText)
            //filterContent(for: searchText)
            searchResults = videos
            tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isClass == true{
            print("this is a class")
            if searchController.isActive {
                
                performSegue(withIdentifier: "unwindVideoToMeetup", sender: self)
                selectedVideo = videos[indexPath.row]
            }else{
                //do something
            }
        }else{
            print("this is not a class")
            let destinationController = storyboard?.instantiateViewController(withIdentifier: "ShowMediaDetail") as!
            MediaDetailViewController
            
            //destinationController.videos = videos
            destinationController.mediaTitle = videos[indexPath.row].videoTitle!
            destinationController.player = videos[indexPath.row].videoImage!
            
            destinationController.selectedVideo = self.selectedVideo
            
            
            destinationController.videoEmbedString = videos[indexPath.row].videoId!
            
            
            AppUtility.lockOrientation(.landscape)
            show(destinationController, sender: self)
            
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
        if isClass == true{
            if searchController.isActive {
                if let indexPath = tableView.indexPathForSelectedRow{
                    selectedVideo = videos[indexPath.row]
                }else{
                    //do something
                }
            }
            
        }else{
            //if segue.identifier == "ShowMediaDetail" {
            //  if let indexPath = tableView.indexPathForSelectedRow {
            //}
            //}
        }
    }
}
