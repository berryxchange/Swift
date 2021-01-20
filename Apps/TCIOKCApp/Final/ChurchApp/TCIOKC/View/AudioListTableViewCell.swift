//
//  AudioListTableViewCell.swift
//  ChurchAppOne
//
//  Created by Quinton Quaye on 11/23/18.
//  Copyright © 2018 Transformation Church International. All rights reserved.
//

import UIKit

class AudioListTableViewCell: UITableViewCell {

    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackDetail: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getAudio(audio: ChurchAudioTrack){
        self.trackImage.loadImageUsingCacheWithURLString(urlString: audio.trackImage!)
        self.trackTitle.text = audio.trackTitle
        self.trackDetail.text = audio.trackDetails
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
