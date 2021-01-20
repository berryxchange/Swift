//
//  ComplaintTableViewCell.swift
//  ChurchAppOne
//
//  Created by Quinton Quaye on 11/9/18.
//  Copyright © 2018 Transformation Church International. All rights reserved.
//

import UIKit

class ComplaintTableViewCell: UITableViewCell {

    @IBOutlet weak var complaintType: UILabel!
    @IBOutlet weak var plaintiffImage: UIImageView!
    @IBOutlet weak var plaintiffName: UILabel!
    @IBOutlet weak var complaintDate: UILabel!
    
    func getComplaint(complaint: Complaint){
        self.complaintType.text = "\(complaint.complaintType!) Complaint"
        self.plaintiffName.text = "By: \(complaint.reporterName!)"
        self.complaintDate.text = "Date: \(complaint.complaintDate!)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
