//
//  ComplaintNotesViewController.swift
//  OKCityChurch
//
//  Created by Quinton Quaye on 12/18/18.
//  Copyright © 2018 City Church. All rights reserved.
//

import UIKit
import Firebase

class ComplaintNotesViewController: UIViewController {

    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var complaint: Complaint!
    var note = ""
    
    override func viewDidAppear(_ animated: Bool) {
         FIRDatabase.database().reference().child("Complaints").child("\(complaint.complaintType!)").child(complaint.key).observe(.value, with: { snapshot in
            
            var newProfile: Complaint!
            let complaintItem = Complaint(snapshot: snapshot)
            
            newProfile = complaintItem
            
            
            self.note = newProfile.complaintNotes!
            self.noteText.text = self.note
            print("this is the note: \(self.note)")
            
         })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        
        noteText.layer.cornerRadius = 4
        noteText.layer.borderWidth = 1
        noteText.layer.borderColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        
        saveButton.churchAppButtonRegular()
        cancelButton.churchAppButtonRegular()
        
        // Do any additional setup after loading the view.
        
        noteText.text = note
    }

    @IBAction func saveNote(_ sender: Any) {
        let complaintRef = FIRDatabase.database().reference().child("Complaints").child("\(complaint.complaintType!)").child(complaint.key)
        
        let note = ["complaintNotes": noteText.text!]
        
        complaintRef.updateChildValues(note)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelNote(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
