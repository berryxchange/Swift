//
//  ChurchInfoViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/30/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase
import SafariServices

class ChurchInfoViewController: UIViewController {
    @IBOutlet weak var churchAddress: UILabel!
    @IBOutlet weak var churchTelephone: UILabel!
    @IBOutlet weak var churchMission: UILabel!
    @IBOutlet weak var churchPastor: UILabel!
    @IBOutlet weak var churchWebsite: UIButton!
    
    
    
    var churchData: Church?
    var administrator = ""
    var associate = ""
    
    
    @IBAction func unwindToChurchInfo(segue: UIStoryboardSegue){
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("this is the administrator\(administrator)")

        // Do any additional setup after loading the view.
        
        let churchRef = FIRDatabase.database().reference().child("ChurchInfo")
        churchRef.observe(.value, with: { snapshot in
            print("This is the snapshot: \(snapshot)")
            
            let churchItem = Church(snapshot: snapshot )
            self.churchData = churchItem
            self.churchAddress.text = churchItem.address
            self.churchTelephone.text = churchItem.telephone
            self.churchMission.text = churchItem.mission
            self.churchPastor.text = churchItem.pastor
            self.churchWebsite.setTitle("\(churchItem.website!)", for: .normal)
            
            //print(item as! FIRDataSnapshot)
                //thisChurchData.append(churchItem)
       
            
        })
        
        if FIRAuth.auth()?.currentUser?.uid == self.administrator{
        let rightButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.editButton))
       self.navigationItem.rightBarButtonItem = rightButton
        }
        churchAddress.text = churchData?.address
        churchTelephone.text = churchData?.telephone
        churchMission.text = churchData?.mission
        churchPastor.text = churchData?.pastor
        self.churchWebsite.setTitle("\(churchData?.website!)", for: .normal)
    }

    @objc func editButton(){
        let controller = storyboard?.instantiateViewController(withIdentifier: "EditChurchInfo") as! ChurchEditInfoViewController
        
        
        controller.churchData = churchData
        
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func goToWebsite(_ sender: Any) {
        let churchWebsite = "http://\(churchData!.website!)"
        
        print(churchWebsite)
        
        if let url = URL(string: churchWebsite){
            let safariController = SFSafariViewController(url:url)
            present(safariController, animated: true, completion: nil)
        }
    }
    
   
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
