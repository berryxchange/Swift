//
//  VideoModel.swift
//  TCIApp
//
//  Created by Quinton Quaye on 1/13/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Alamofire

protocol videoModelDelegate {
    func dataReady()
}

class VideoModel: NSObject {
    var isClass = false
    
    
    //let apiKey = "AIzaSyBubYxckkLXqwS5aCn-6AkqprwFY6j3WUU"
    //let uploadsPlaylistId = "UUn_7ulL_jOwalHyAsxT4DNg"
    //.........
    
    //let youtubeUrlOne = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems")!
    //let parameters = ["maxResults":"25",  "part":"snippet,contentDetails", "playlistId":"PLHf67yzljRu6kGE8X7Qs_tZTmwhuqe4MU", "key":"AIzaSyDdUBdq21fOKJT77U_8OSjJ9Ovuy82siLo"]
    
    //let youtubeUrlOne = URL(string: "https://www.googleapis.com/youtube/v3/search")!
    //let parameters = ["maxResults":"25", "forMine": "true",  "part":"snippet,contentDetails", "q":"someSearchName", "type":"video"]
    
    
    var videoArray = [Video]()
    
    var delegate: videoModelDelegate?
    
    func getVideoFeed(title: String){
        var newTitle = ""
        if title == ""{
            newTitle = ""
        }else if title != ""{
            newTitle = title
        }
        var youtubeUrlOne = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems")!
        var parameters = ["maxResults":"25",  "part":"snippet,contentDetails", "playlistId":"PLHf67yzljRu6kGE8X7Qs_tZTmwhuqe4MU", "key":"AIzaSyDdUBdq21fOKJT77U_8OSjJ9Ovuy82siLo"]
        
        if isClass == true{
            //user search method
            print("isClass!")
            
            print("this is the newTitle: \(newTitle)")
            
            //youtubeUrlOne = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems")!
            
            //parameters = ["maxResults":"25",  "part":"snippet,contentDetails", "playlistId":"PLHf67yzljRu6kGE8X7Qs_tZTmwhuqe4MU", "key":"AIzaSyDdUBdq21fOKJT77U_8OSjJ9Ovuy82siLo"]
            
            youtubeUrlOne = URL(string: "https://www.googleapis.com/youtube/v3/search")!
            parameters = ["maxResults":"25",  "part":"snippet", "channelId":"UCn_7ulL_jOwalHyAsxT4DNg", "q":"\(newTitle)", "type":"video", "key":"AIzaSyDdUBdq21fOKJT77U_8OSjJ9Ovuy82siLo"]
            
            
            Alamofire.request(youtubeUrlOne, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
                debugPrint(response)
                
                if let json = response.result.value as? NSDictionary {
                    
                    
                    var arrayOfVideos : [Video] = []
                    var pendingArray : [Date] = []
                    
                    for video in json["items"] as! [AnyObject]{
                        
                        // TODO Create video objects off the json response
                        
                        let videoObj = Video()
                        
                        videoObj.videoId = video.value(forKeyPath: "id.videoId") as! String
                        
                        videoObj.videoTitle = video.value(forKeyPath:"snippet.title") as! String
                        videoObj.videoDescription = video.value(forKeyPath:"snippet.description") as! String
                        videoObj.videoThumbnailUrl = video.value(forKeyPath:"snippet.thumbnails.high.url") as! String
                        
                        // videoObj.videoDate = video.value(forKeyPath: "contentDetails.videoPublishedAt") as! String
                        //arrayOfVideos.append(videoObj)
                        
                        let thisVideoDate = video.value(forKeyPath: "snippet.publishedAt")// as! String
                        
                        print(thisVideoDate!)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                        dateFormatter.formatterBehavior = .default
                        //-----
                        
                        let thisVideoDateFormat = dateFormatter.date(from: thisVideoDate as! String)
                        
                        //let dateStringFormatter = DateFormatter()
                        //dateStringFormatter.dateFormat = "MM/dd/yyyy"
                        
                        //let thisVideoStringFormat = dateStringFormatter.string(from: thisVideoDate as! Date)
                        
                        
                        //print(thisVideoDateFormat!)
                        
                        videoObj.videoDate = "\(thisVideoDateFormat!)"
                        
                        arrayOfVideos.insert(videoObj, at: 0)
                        
                        
                        
                        arrayOfVideos.sort(by: { $0.videoDate!.compare($1.videoDate!) == .orderedDescending})
                        
                        
                        
                        
                    }
                    
                    // when all the video objects have been constructed, assign the array to the VideoModel property
                    
                    self.videoArray = arrayOfVideos
                    
                    // notify the delegate tha the data is ready
                    if self.delegate != nil {
                        self.delegate!.dataReady()
                    }
                }
            }
        }else{
            // not use search method
            /*
            youtubeUrlOne = URL(string: "https://www.googleapis.com/youtube/v3/playlistItems")!
            parameters = ["maxResults":"25",  "part":"snippet,contentDetails",  "playlistId":"PLHf67yzljRu6kGE8X7Qs_tZTmwhuqe4MU", "key":"AIzaSyDdUBdq21fOKJT77U_8OSjJ9Ovuy82siLo"]
            
            Alamofire.request(youtubeUrlOne, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
                debugPrint(response)
                
                if let json = response.result.value as? NSDictionary {
                    
                    
                    var arrayOfVideos : [Video] = []
                    var pendingArray : [Date] = []
                    
                    for video in json["items"] as! [AnyObject]{
                        
                        // TODO Create video objects off the json response
                        let videoObj = Video()
                        
                        videoObj.videoId = video.value(forKeyPath: "snippet.resourceId.videoId") as! String
                        
                        videoObj.videoTitle = video.value(forKeyPath:"snippet.title") as! String
                        videoObj.videoDescription = video.value(forKeyPath:"snippet.description") as! String
                        videoObj.videoThumbnailUrl = video.value(forKeyPath:"snippet.thumbnails.high.url") as! String
                        
                        // videoObj.videoDate = video.value(forKeyPath: "contentDetails.videoPublishedAt") as! String
                        //arrayOfVideos.append(videoObj)
                        
                        let thisVideoDate = video.value(forKeyPath: "contentDetails.videoPublishedAt")// as! String
                        
                        print(thisVideoDate!)
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
                        dateFormatter.formatterBehavior = .default
                        //-----
                        
                        let thisVideoDateFormat = dateFormatter.date(from: thisVideoDate as! String)
                        
                        //let dateStringFormatter = DateFormatter()
                        //dateStringFormatter.dateFormat = "MM/dd/yyyy"
                        
                        //let thisVideoStringFormat = dateStringFormatter.string(from: thisVideoDate as! Date)
                        
                        
                        //print(thisVideoDateFormat!)
                        
                        videoObj.videoDate = "\(thisVideoDateFormat!)"
                        
                        arrayOfVideos.insert(videoObj, at: 0)
                        
                        
                        
                        arrayOfVideos.sort(by: { $0.videoDate!.compare($1.videoDate!) == .orderedDescending})
                      
                    }
                    
                    // when all the video objects have been constructed, assign the array to the VideoModel property
                    
                    self.videoArray = arrayOfVideos
                    
                    // notify the delegate tha the data is ready
                    if self.delegate != nil {
                        self.delegate!.dataReady()
                    }
                }
            }
 */
        }
    }
}
