//
//  MediaTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {

    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var videoDate: UILabel!
    @IBOutlet weak var videoImage: UIImageView!
    
    var video = Video()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getMedia(video: Video ){
        self.videoTitle.text = video.videoTitle
        
        let thisMediaImage = video.videoThumbnailUrl
        self.videoImage.loadImageUsingCacheWithURLString(urlString: thisMediaImage!)
        self.videoDate.text = "" //video.videoDate
        
    }
    
}
