//
//  MediaDetailViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit

class MediaDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var videoPlayer: UIWebView!
    
    var selectedVideo: Video?
    var videoEmbedString = ""
    var isClass = false
    
    var mediaTitle = ""
    var player = ""
    var videoWidth = 0
    var videoHeight = 0
    
    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .portrait
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        print("\(videoEmbedString)")
        
        title = mediaTitle
        
        getVideoCode(code: videoEmbedString)
        
        
    }
    
    func getVideoCode(code: String){
        let url = URL(string: "https://www.youtube.com/embed/\(code)")
        self.videoPlayer.loadRequest(URLRequest(url: url!))
        videoPlayer.scalesPageToFit = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .portrait
        
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        /* Don't forget to reset when view is being removed
         AppUtility.lockOrientation(.all)
         */
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.myOrientation = .portrait
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
