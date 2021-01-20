//
//  ChurchEditInfoViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/30/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase

class ChurchEditInfoViewController: UIViewController {
    @IBOutlet weak var churchAddress: UITextField!
    
    @IBOutlet weak var churchTelephone: UITextField!
    @IBOutlet weak var churchMission: UITextField!
    @IBOutlet weak var churchPastor: UITextField!
    @IBOutlet weak var churchWebsite: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var churchData: Church?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default)
            
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        hideKeyboardWhenTappedAround()
        doneButton.layer.cornerRadius = 20
        doneButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 20
        cancelButton.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
        churchAddress.text = churchData?.address
        churchTelephone.text = churchData?.telephone
        churchMission.text = churchData?.mission
        churchPastor.text = churchData?.pastor
        churchWebsite.text = churchData?.website
        
    }
    @IBAction func doneButton(_ sender: Any) {
       
         let churchRef = FIRDatabase.database().reference().child("ChurchInfo")
        
        let post = Church(address: churchAddress.text!, telephone: churchTelephone.text!, mission: churchMission.text!, pastor: churchPastor.text!, website: churchWebsite.text!)
        
        churchRef.setValue(post.toAnyObject())
        
         performSegue(withIdentifier: "unwindToChurchInfo", sender: self)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        performSegue(withIdentifier: "unwindToChurchInfo", sender: self)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
