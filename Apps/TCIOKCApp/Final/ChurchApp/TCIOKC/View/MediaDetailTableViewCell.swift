//
//  MediaDetailTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit

class MediaDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var mediaName: UILabel!
    @IBOutlet weak var hostName: UILabel!
    @IBOutlet weak var mediaDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func getMediaDetail(videoDetail: Video){
        self.mediaName.text = videoDetail.videoTitle
         self.mediaDate.text = videoDetail.videoDate
        
    }

}
