//
//  PastorialBlogDetailTableViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/28/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit

class PastorialBlogDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var blogTitle: UILabel!
    @IBOutlet weak var blogDate: UILabel!
    @IBOutlet weak var blogMessage: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getBlogDetail(blogDetail: Blog){
        self.blogTitle.text = blogDetail.blogTitle
        self.blogDate.text = blogDetail.blogDate
        self.blogMessage.text = blogDetail.blogMessage
    }

}
