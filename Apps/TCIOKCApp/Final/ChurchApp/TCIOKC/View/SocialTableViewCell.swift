//
//  SocialTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/27/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit

class SocialTableViewCell: UITableViewCell {

    @IBOutlet weak var socialMediaIcon: UIImageView!
    
    @IBOutlet weak var socialMediaName: UILabel!
    
    @IBOutlet weak var timeAndDate: UILabel!
    
    @IBOutlet weak var userUploadImage: UIImageView!
    
    @IBOutlet weak var userPostLikes: UILabel!
    @IBOutlet weak var cellBackground: UIView!
    
    @IBOutlet weak var socialLikesIcon: UIImageView!
    @IBOutlet weak var socialPostTitle: UILabel!
    
    //@IBOutlet weak var userIcon: UIImageView!
    
    
    func getSocialPost(social: SocialMediaPost) {
        self.socialMediaIcon.image = UIImage(named: social.socialMediaIcon!)
        self.socialMediaName.text = social.byUserName
        self.timeAndDate.text = social.timeAndDate
        self.userUploadImage.image = UIImage(named: social.userUploadImage!)
        self.socialPostTitle.text = social.userPostTitle
        switch social.userPostLikes {
        case 0:
            self.userPostLikes.text = "still waiting..."
        case 1..<1000:
            self.userPostLikes.text = "\(social.userPostLikes)"
        case 1000..<1500:
            self.userPostLikes.text = "1K+"
        case 1500..<2000:
            self.userPostLikes.text = "1.5K+"
        case 2000..<2500:
            self.userPostLikes.text = "2K+"
        case 2500..<3000:
            self.userPostLikes.text = "2.5K+"
        case 3000..<3500:
            self.userPostLikes.text = "3K+"
        case 3500..<4000:
            self.userPostLikes.text = "3.5K+"
        case 4000..<4500:
            self.userPostLikes.text = "4K+"
        case 4500..<5000:
            self.userPostLikes.text = "4.5K+"
        case 5000..<5500:
            self.userPostLikes.text = "5K+"
        case 5500..<6000:
            self.userPostLikes.text = "5.5K+"
        case 6000..<6500:
            self.userPostLikes.text = "6K+"
        case 6500..<7000:
            self.userPostLikes.text = "6.5K+"
        case 7000..<7500:
            self.userPostLikes.text = "7K+"
        case 7500..<8000:
            self.userPostLikes.text = "7.5K+"
        case 8000..<8500:
            self.userPostLikes.text = "8K+"
        case 8500..<9000:
            self.userPostLikes.text = "8.5K+"
        case 9000..<9500:
            self.userPostLikes.text = "9K+"
        case 9500..<10000:
            self.userPostLikes.text = "9.5K+"
        case 10000..<100000:
            self.userPostLikes.text = "10K+"
        default:
            break
            
        }
        
        
        //self.userIcon.image = UIImage(named: social.userIcon!)
    }
}
