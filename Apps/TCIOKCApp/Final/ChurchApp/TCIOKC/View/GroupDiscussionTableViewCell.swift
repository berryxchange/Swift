//
//  GroupDiscussionTableViewCell.swift
//  OKCityChurch
//
//  Created by Quinton Quaye on 12/21/18.
//  Copyright © 2018 City Church. All rights reserved.
//

import UIKit

class GroupDiscussionTableViewCell: UITableViewCell {

    @IBOutlet weak var chatImage: UIImageView!
    @IBOutlet weak var chatName: UILabel!
    @IBOutlet weak var chatMessage: UILabel!
    @IBOutlet weak var chatPostTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getPost(message: GroupMessage){
    self.chatImage.loadImageUsingCacheWithURLString(urlString: message.chatImage!)
        self.chatName.text = message.chatName!
        self.chatMessage.text = message.chatMessage!
        self.chatPostTime.text = message.chatPostTime!
    }

}
