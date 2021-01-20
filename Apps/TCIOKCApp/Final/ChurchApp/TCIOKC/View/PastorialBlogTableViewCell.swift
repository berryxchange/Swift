//
//  PastorialBlogTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit

class PastorialBlogTableViewCell: UITableViewCell {

    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogImage: UIImageView!
    
    
    func getBlog(blog: Blog){
        self.blogTitle.text = blog.blogTitle
        
        self.blogImage.loadImageUsingCacheWithURLString(urlString: blog.blogImage!)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
