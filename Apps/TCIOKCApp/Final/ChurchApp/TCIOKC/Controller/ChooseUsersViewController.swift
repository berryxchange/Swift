//
//  ChooseUsersViewController.swift
//  OKCityChurch
//
//  Created by Quinton Quaye on 12/14/18.
//  Copyright © 2018 City Church. All rights reserved.
//

import UIKit

class ChooseUsersViewController: UIViewController {

    @IBOutlet weak var newStudentButton: UIButton!
    @IBOutlet weak var existingStudentButton: UIButton!
    var group: Group!
    var currentSelection = ""
    
    
    @IBAction func unwindToStudentSelection(segue: UIStoryboardSegue){
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newStudentButton.isEnabled = false
        newStudentButton.setTitleColor(#colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1), for: .normal)
        newStudentButton.setTitle("unavailable", for: .normal)
        newStudentButton.churchAppButtonRegular()
        existingStudentButton.churchAppButtonRegular()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func NewStudentButton(_ sender: Any) {
        
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "AddStudentController") as!
            
        AddStudentViewController
        
        destinationController.thisGroupKey = group.key
        print(group.key)
        destinationController.group = group
        destinationController.currentSelection = currentSelection
        self.navigationController?.present(destinationController, animated: true, completion: nil)
        
    }
    
    @IBAction func ExistingStudentButton(_ sender: Any) {
        
        let destinationController = self.storyboard?.instantiateViewController(withIdentifier: "newMessage") as!
            
        newMessageController
        destinationController.style = "chooseStudent"
        destinationController.group = group
         show(destinationController, sender: self)
        
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
