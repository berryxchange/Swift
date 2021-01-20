//
//  profileCollectionViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 4/28/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class profileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionTitle: UILabel!
    @IBOutlet weak var collectionImage: UIImageView!
    
    // for prayers
    func getPrayer(prayer: Prayer){
        self.collectionTitle.text = prayer.prayerPostTitle
        self.collectionImage.image = UIImage(named: "prayer")
    }
    
    //for social likes
    func getSocialLikes(social: SocialMediaPost){
        self.collectionTitle.text = social.userPostTitle
        self.collectionImage.image = UIImage(named: social.userUploadImage!)
        
    }
    //for pastorial blog likes
    func getPastorialBlogLikes(blog: Blog){
        self.collectionTitle.text = blog.blogTitle
        self.collectionImage.image = UIImage(named: blog.blogImage!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
