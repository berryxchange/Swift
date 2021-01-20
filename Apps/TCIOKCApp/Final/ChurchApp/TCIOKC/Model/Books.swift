//
//  Books.swift
//  TCIApp
//
//  Created by Quinton Quaye on 2/25/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import Foundation
class Books: NSObject {
    var name: String = ""
    var chapters = [AnyObject]()
    var chapter: Int = 0
    var verses = [AnyObject]()
    var text: String = ""
    var verse: Int = 0
    var totalBookName: String = ""
}

class Chapters: NSObject{
    var name: String = ""
    var chapters = [AnyObject]()
    var chapter: Int = 0
    var verses = [AnyObject]()
    var text: String = ""
    var verse: Int = 0
    var totalBookName: String = ""
}

class NewBooks: NSObject{
    var bookName: String = ""
    var chapter: String = ""
    var verse: String = ""
    var text: String = ""
    
}
