//
//  PastorsListTableViewCell.swift
//  ChurchAppOne
//
//  Created by Quinton Quaye on 10/17/18.
//  Copyright © 2018 Transformation Church International. All rights reserved.
//

import UIKit


class PastorsListTableViewCell: UITableViewCell {

    @IBOutlet weak var pastorName: UILabel!
    @IBOutlet weak var pastorImage: UIImageView!
    @IBOutlet weak var pastorTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func getPastor(pastor: Pastor){
        self.pastorTitle.text = pastor.pastorTitle
        self.pastorName.text = "\(pastor.firstName!) \(pastor.lastName!)"
        self.pastorImage.loadImageUsingCacheWithURLString(urlString: pastor.pastorImage!)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
