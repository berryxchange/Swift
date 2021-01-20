//
//  AddClassViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 5/17/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import Firebase

class AddClassViewController: UIViewController, UITextFieldDelegate {

    // outputs
    
    @IBOutlet weak var className: UITextField!
    @IBOutlet weak var teacherName: UITextField!
    @IBOutlet weak var classStartTime: UITextField!
    @IBOutlet weak var classEndTime: UITextField!
    @IBOutlet weak var classDays: UITextField!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    //end-----
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        doneButton.layer.cornerRadius = 20
        doneButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 20
        cancelButton.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        
        classStartTime.delegate = self
        classEndTime.delegate = self
        className.delegate = self
        
        teacherName.delegate = self
        classDays.delegate = self
        
        
        let startTimePickerView: UIDatePicker = UIDatePicker()
        startTimePickerView.datePickerMode = UIDatePickerMode.time
        classStartTime.inputView = startTimePickerView
        startTimePickerView.addTarget(self, action: #selector(self.startTimePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let endTimePickerView: UIDatePicker = UIDatePicker()
        endTimePickerView.datePickerMode = UIDatePickerMode.time
        classEndTime.inputView = endTimePickerView
        endTimePickerView.addTarget(self, action: #selector(self.endTimePickerValueChanged), for: UIControlEvents.valueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Actions
    @IBAction func doneButton(_ sender: Any) {
        if className.text == "" || teacherName.text == ""{
            let alert = UIAlertController(title: "Error", message: "One or more fields are empty.", preferredStyle: .alert)
            
            let returnAction = UIAlertAction(title: "Ok", style: .default) { action in
            }
            
            // actions of the alert controller
            alert.addAction(returnAction)
            
            // action to present the alert controller
            self.present(alert, animated: true, completion: nil)
            
        }else {
        let classRef = FIRDatabase.database().reference().child("Classes")
        
        let thisClass = ClassRoom(className: className.text!, classTeacher: teacherName.text!, classStartTime: classStartTime.text!, classEndTime: classEndTime.text!, classDays: classDays.text!, classBeginningDate: "\(Date())", classNumberOfStudents: 0 )
        
        //let post =  ["className": className.text! , "classTeacher": teacherName.text!,"classStartTime": classStartTime.text!, "classEndTime": classEndTime.text!, "classDays": classDays.text!, "classBeginningDate": "\(Date())", "classNumberOfStudents": 0] as [String : Any]
        
        let classItem = classRef.childByAutoId()
        classItem.setValue(thisClass.toAnyObject())
        
        dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //end-----
    
    
    // for time picker
    
    
    
    @objc func startTimePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        classStartTime.text = dateFormatter.string(from: sender.date)
        
    }
    
    @objc func endTimePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.none
        
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        classEndTime.text = dateFormatter.string(from: sender.date)
        
    }
    
    //end-----
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        if textField == className {
            teacherName.becomeFirstResponder()
        }
        if textField == teacherName {
            classStartTime.becomeFirstResponder()
        }
        if textField == classStartTime {
            classEndTime.becomeFirstResponder()
        }
        if textField == classEndTime {
            classDays.becomeFirstResponder()
        }
        
        if textField == classDays{
            textField.resignFirstResponder()
        }
        
        return true
    }

    
    // for adjusting text field distance from bottom
    func animateTextField(textField: UITextField, up: Bool)
    {
        let movementDistance:CGFloat = -100
        let movementDuration: Double = 0.3
        
        var movement:CGFloat = 0
        if up
        {
            movement = movementDistance
        }
        else
        {
            movement = -movementDistance
        }
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        self.animateTextField(textField: textField, up:false)
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
