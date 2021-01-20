//
//  TermsAndPoliciesViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 8/1/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit

class TermsAndPoliciesViewController: UIViewController {
    
    var agreement = "Terms of Use (Terms) \nLast updated: 7/29/2018 \n \nPlease read these Terms of Use (Terms, Terms of Use) carefully before using the Mobile App TCIApp (The Service) operated by BerryXChange.LLC & BerryXChange-Innovations. \n \nYour access to and use of the Service is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all visitors, users and others who access or use the Service. \n \nBy accessing or using the Service, you agree to be bound by these Terms. If you disagree with any part of the terms then you may not access the Service.  \n \nContent \n \nOur Service allows you to post, like, store, share and otherwise make available certain information, text, graphics, images, or other material (Content). You are responsible for the material you provide and post. \n \nLinks To Other Web Sites \n \nOur Service may contain links to third-party web sites or services that are not owned or controlled by BerryXChange.LLC or BerryXChange-Innovations. \n \nBerryXChange.LLC & BerryXChange-Innovations has no control over, and assumes no responsibility for, the content, privacy policies, or practices of any third party web sites or services. You further acknowledge and agree that BerryXChange.LLC & BerryXChange-Innovations shall not be responsible or liable, directly or indirectly, for any damage or loss caused or alleged to be caused by or in connection with use of or reliance on any such content, goods or services available on or through any such web sites or services.\n \nTermination \n \nWe may terminate or suspend access to our Service immediately, without prior notice or liability, for any reason whatsoever of bullying, inappropriate behavior, language, images that harm or objectify others in any manner, including without limitation if you breach these Terms. \n \nAll provisions of the Terms which by their nature should survive termination shall survive termination, including, without limitation, ownership provisions, warranty disclaimers, indemnity and limitations of liability. Should any user be subject to any of these objectifications or inappropriate behavior, you have the right and responsibility to report it to berryxchange.innovations@gmail.com or use the in-app chat to report to your administrator. \n \nChanges \n \nWe reserve the right, at our sole discretion, to modify or replace these Terms at any time. If a revision is material, we will try to provide at least 30 days' notice prior to any new terms taking effect. What constitutes a material change will be determined at our sole discretion. \n \nContact Us \n \nIf you have any questions about these Terms, please contact us at berryxchange.innovations@gmail.com"
    
    var policy = ""
    var isTerms = false
    var isPrivacy = false
    
   
    @IBOutlet weak var dataText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isTerms == true{
            dataText.text = agreement
        }else if isPrivacy == true{
            dataText.text = policy
        }
    }
    
    
    
}
