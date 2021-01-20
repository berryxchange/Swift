//
//  AudioTableViewController.swift
//  ChurchAppOne
//
//  Created by Quinton Quaye on 11/7/18.
//  Copyright © 2018 Transformation Church International. All rights reserved.
//

import UIKit
import AVFoundation
import FirebaseStorage
import FirebaseDatabase

class AudioTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    
    @IBOutlet weak var audioPlayerView: UIView!
    
    @IBOutlet weak var songTableView: UITableView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var rewind: UIBarButtonItem!
    
    @IBOutlet weak var play: UIBarButtonItem!
    
    @IBOutlet weak var pause: UIBarButtonItem!
    
    @IBOutlet weak var currentAudioTime: UILabel!
    
    @IBOutlet weak var totalAudioTime: UILabel!
    @IBOutlet weak var audioTimeBar: UIProgressView!
    
    @IBOutlet weak var currentAudioImage: UIImageView!
    @IBOutlet weak var currentAudioTitle: UILabel!
    @IBOutlet weak var audioPlayerViewBottomConstraint: NSLayoutConstraint!
    
    var audioFiles: [ChurchAudioTrack] = []
    
    
    var songPlayer = AVAudioPlayer()
    
    var hasBeenPaused = false
    var isPlaying = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentAudioImage.layer.masksToBounds = true
        audioPlayerViewBottomConstraint.constant = -130
        
        totalAudioTime.text = "0.00"
        currentAudioTime.text = "0.00"
        audioTimeBar.progress = 0.0
        
        
        // download tracks
        let audioTrackRef = FIRDatabase.database().reference(withPath: "ChurchAudioFiles")
        // for main database
        audioTrackRef.observe(.value, with: {snapshot in
            
            //2 new items are an empty array
            var newTracks: [ChurchAudioTrack] = []
            
            for track in snapshot.children{
                let trackItem = ChurchAudioTrack(snapshot: track as! FIRDataSnapshot)
                print(trackItem)
                newTracks.insert(trackItem, at: 0)
            }
            
            
            self.audioFiles = newTracks.sorted(by: { $0.trackTitle! < $1.trackTitle! })
            self.songTableView.reloadData()
            
        })
        
        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return audioFiles.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? AudioListTableViewCell
       
        let thisCell = audioFiles[indexPath.row]
        cell?.getAudio(audio: thisCell)
        cell?.trackImage.layer.masksToBounds = true
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          audioPlayerViewBottomConstraint.constant = 5
        
        
        // Downloading a song from FB
        
        let audioPath = audioFiles[indexPath.row]
        let pathString = "\(audioPath.trackTitle!).mp3" //"SongsPath.mp3"
        let storageReference = FIRStorage.storage().reference().child("Audio").child(audioPath.trackTitle!).child("Audio").child(pathString)
        
        let fileUrls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let fileUrl = fileUrls.first?.appendingPathComponent(pathString) else {
            return
        }
        
        let downloadTask = storageReference.write(toFile: fileUrl)
        
        downloadTask.observe(.success) { _ in
            do {
                self.currentAudioImage.loadImageUsingCacheWithURLString(urlString: audioPath.trackImage!)
                self.currentAudioTitle.text = audioPath.trackTitle
                self.songPlayer = try AVAudioPlayer(contentsOf: fileUrl)
                self.songPlayer.prepareToPlay()
                self.songPlayer.play()
                
                let totalDuration: TimeInterval = self.songPlayer.duration
                let totalTimeformatter = DateComponentsFormatter()
                totalTimeformatter.unitsStyle = .positional
                totalTimeformatter.allowedUnits = [ .minute, .second ]
                totalTimeformatter.zeroFormattingBehavior = [ .pad ]
                
                let totalFormattedDuration = totalTimeformatter.string(from: totalDuration)
                self.totalAudioTime.text = totalFormattedDuration
                
                Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateAudioProgressView), userInfo: nil, repeats: true)
                self.audioTimeBar.setProgress(Float(self.songPlayer.currentTime/self.songPlayer.duration), animated: false)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    @IBAction func rewind(_ sender: Any) {
        if songPlayer.isPlaying || hasBeenPaused{
            songPlayer.stop()
            songPlayer.currentTime = 0
            
            songPlayer.play()
        }else{
            songPlayer.play()
        }
    }
    
    
    @IBAction func play(_ sender: Any) {
        songPlayer.play()
        isPlaying = true
        
        let totalDuration: TimeInterval = songPlayer.duration
        let totalTimeformatter = DateComponentsFormatter()
        totalTimeformatter.unitsStyle = .positional
        totalTimeformatter.allowedUnits = [ .minute, .second ]
        totalTimeformatter.zeroFormattingBehavior = [ .pad ]
        
        let totalFormattedDuration = totalTimeformatter.string(from: totalDuration)
        totalAudioTime.text = totalFormattedDuration
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateAudioProgressView), userInfo: nil, repeats: true)
        audioTimeBar.setProgress(Float(songPlayer.currentTime/songPlayer.duration), animated: false)
    }
    
    @objc func updateAudioProgressView(){
        if songPlayer.isPlaying{
            audioTimeBar.setProgress(Float(songPlayer.currentTime/songPlayer.duration), animated: true)
            
            let duration: TimeInterval = songPlayer.currentTime
            
            let currentTimeformatter = DateComponentsFormatter()
            currentTimeformatter.unitsStyle = .positional
            currentTimeformatter.allowedUnits = [ .minute, .second ]
            currentTimeformatter.zeroFormattingBehavior = [ .pad ]
            
            let formattedDuration = currentTimeformatter.string(from: duration)
            currentAudioTime.text = "\(formattedDuration!)"
            
            
        }
    }
    
    @IBAction func pause(_ sender: Any) {
        if songPlayer.isPlaying{
            songPlayer.pause()
            hasBeenPaused = true
        }else {
            hasBeenPaused = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if isPlaying == true{
            if songPlayer.isPlaying{
                songPlayer.pause()
                hasBeenPaused = true
            } else {
            
            }
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
