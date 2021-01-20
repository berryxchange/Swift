//
//  BibleModel.swift
//  TCIApp
//
//  Created by Quinton Quaye on 2/25/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import Foundation

import Alamofire

protocol bibleModelDelegate {
    func dataReady()
}

/*class BibleModel: NSObject {
    
    var thisBibleURL = ""
    
    //let apiKey = "AIzaSyBubYxckkLXqwS5aCn-6AkqprwFY6j3WUU"
    //let uploadsPlaylistId = "UUn_7ulL_jOwalHyAsxT4DNg"
    //let bibleUrl = URL(string: "https://firebasestorage.googleapis.com/v0/b/TCIApp.appspot.com/o/bibleJsonFiles%2FBiblekjv.json?alt=media&token=afaad37b-ac91-499a-960d-e6c984dc4057")!
    
    
    var booksOfBible = [Books]()
    var chaptersOfBible = [Chapters]()
    
    var delegate: bibleModelDelegate?
    
    func getBibleFeed(){
        
        
        // this fetches the videos dynamically through the youtube Data ApI
        
        Alamofire.request(URL(string: thisBibleURL)!, encoding: URLEncoding.default).responseJSON { (response) in
            debugPrint(response)
            
            if let json = response.result.value as? NSDictionary {
                
                var arrayOfBooks = [Books]()
                var arrayOfChapters = [Chapters]()
                
                for book in json["books"] as! [AnyObject]{
                    
                    // TODO Create video objects off the json response
                    let books = Books()
                    
                    books.name = book.value(forKey: "name") as! String
                    
                    books.chapters = book.value(forKey: "chapters") as! [AnyObject]
                   
                    arrayOfBooks.append(books)
                    
                    for verses in book["chapters"] as! [AnyObject]{
                        let chapters = Chapters()
                        //chapters.name = verses.value(forKey: "name") as! String
                        //chapters.chapters = verses.value(forKey: "chapters") as! [AnyObject]
                        chapters.verses = verses.value(forKey: "verses") as! [AnyObject]
                        
                        
                        arrayOfChapters.append(chapters)
                     
                    }
 
                }
                
                // when all the video objects have been constructed, assign the array to the VideoModel property
                
                self.booksOfBible = arrayOfBooks
                self.chaptersOfBible = arrayOfChapters
                
                // notify the delegate tha the data is ready
                if self.delegate != nil {
                    self.delegate!.dataReady()
                }
            }
            
        }
    }
}
 */

// the model we use

class NewBibleModel: NSObject {
    
    var thisBibleVersion = ""
    
    var booksOfBible = [Books]()
    var chaptersOfBible = [Chapters]()
    
    var delegate: bibleModelDelegate?
    
    func getBibleFeed(){
        
        var arrayOfBooks = [Books]()
        var arrayOfChapters = [Chapters]()
        
        // this fetches the bible dynamically from file
        
        if let path = Bundle.main.path(forResource: thisBibleVersion, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let json = jsonResult as? Dictionary<String, AnyObject>, let books = json["books"] as? [AnyObject] {
                    // do stuff
                    for book in books {
                        
                        // TODO Create video objects off the json response
                        let books = Books()
                        
                        books.name = book.value(forKey: "name") as! String
                        
                        books.chapters = book.value(forKey: "chapters") as! [AnyObject]
                        
                        arrayOfBooks.append(books)
                        
                        for verses in book["chapters"] as! [AnyObject]{
                            let chapters = Chapters()
                            //chapters.name = verses.value(forKey: "name") as! String
                            //chapters.chapters = verses.value(forKey: "chapters") as! [AnyObject]
                            chapters.verses = verses.value(forKey: "verses") as! [AnyObject]
                            
                            
                            arrayOfChapters.append(chapters)
                            
                       }
                    }
               }
            }catch {
                // handle error
            }
            self.booksOfBible = arrayOfBooks
            self.chaptersOfBible = arrayOfChapters
            
            // notify the delegate tha the data is ready
            if self.delegate != nil {
                self.delegate!.dataReady()
                
            }
        }
    }
}
        
            /*
            if let json = response.result.value as? NSDictionary {
                
                var arrayOfBooks = [Books]()
                var arrayOfChapters = [Chapters]()
                
                for book in json["books"] as! [AnyObject]{
                    
                    // TODO Create video objects off the json response
                    let books = Books()
                    
                    books.name = book.value(forKey: "name") as! String
                    
                    books.chapters = book.value(forKey: "chapters") as! [AnyObject]
                    
                    arrayOfBooks.append(books)
                    
                    for verses in book["chapters"] as! [AnyObject]{
                        let chapters = Chapters()
                        //chapters.name = verses.value(forKey: "name") as! String
                        //chapters.chapters = verses.value(forKey: "chapters") as! [AnyObject]
                        chapters.verses = verses.value(forKey: "verses") as! [AnyObject]
                        
                        
                        arrayOfChapters.append(chapters)
                        
                    }
                    
                }
                
                // when all the video objects have been constructed, assign the array to the VideoModel property
                
                self.booksOfBible = arrayOfBooks
                self.chaptersOfBible = arrayOfChapters
                
                // notify the delegate tha the data is ready
                if self.delegate != nil {
                    self.delegate!.dataReady()
                }
            }
            
        }
    }
}
*/
