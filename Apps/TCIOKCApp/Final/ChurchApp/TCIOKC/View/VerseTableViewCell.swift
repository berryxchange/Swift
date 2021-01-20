//
//  VerseTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 2/26/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class VerseTableViewCell: UITableViewCell {

    @IBOutlet weak var chapterNameAndVerse: UILabel!
    
    @IBOutlet weak var verseText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getVerse(verse: Chapters, verseTitle: Chapters){
        self.chapterNameAndVerse.text = verseTitle.name
        self.verseText.text = verse.text
    }

}
