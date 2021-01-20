//
//  MainCollectionViewCell.swift
//  TCIApp
//
//  Created by Quinton Quaye on 12/13/17.
//  Copyright © 2017 Quinton Quaye. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ministryIcon: UIImageView!
    
    @IBOutlet weak var ministryTitle: UILabel!
    @IBOutlet weak var ministrySubtitle: UILabel!
    
    func getMinistry(ministry: Ministry){
        self.ministryIcon.image = UIImage(named: ministry.ministryIcon)
        self.ministryTitle.text = ministry.ministryTitle
        self.ministrySubtitle.text = ministry.ministrySubtitle
    }
}
