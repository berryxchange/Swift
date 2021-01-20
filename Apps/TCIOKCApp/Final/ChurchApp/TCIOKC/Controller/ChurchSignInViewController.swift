//
//  ChurchSignInViewController.swift
//  TCIApp
//
//  Created by Quinton Quaye on 1/19/18.
//  Copyright © 2018 Quinton Quaye. All rights reserved.
//

import UIKit
import FirebaseAuth


class ChurchSignInViewController: UIViewController, UITextFieldDelegate {
    
    //Outlets
    @IBOutlet var mainView: UIView!
    
        //Inputs
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    
        //Forgotten Password
    @IBOutlet weak var resetEmailTextInput: UITextField!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var passwordRecoveryPad: UIView!

    @IBOutlet weak var passwordRecoveryBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var forgotPasswordCancelButton: UIButton!
    
    //Main Variables
    var data = MinistryData()
    var usersViewController: MessagesController?
    
    //End.....
    
    // view will load

    
    //View
    override func viewDidLoad() {
        super.viewDidLoad()
        //Initials
       //forgotPassword.isHidden = true
        //signupButton.isHidden = true
        
        
        passwordRecoveryBottomConstraint.constant = -1000
            // hides keyboard when tapped anywhere
        self.hideKeyboardWhenTappedAround()
        //...
        
        //Delegates
        emailTextField.delegate = self
        passwordTextField.delegate = self
        resetEmailTextInput.delegate = self
        //...
        
       
        
        //Visuals
        emailTextField.underlined()
        passwordTextField.underlined()
        resetEmailTextInput.underlined()
        
        loginButton.churchAppButtonRegular()
    
        resetButton.churchAppButtonRegular()
        
        
        
        forgotPasswordCancelButton.layer.cornerRadius = 20
        forgotPasswordCancelButton.layer.masksToBounds = true
        //...
        
        //Firebase
            //Listeners
        FIRAuth.auth()?.addStateDidChangeListener() { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "ShowChurchMinistries", sender: self)
            }//End of if statement
            
        }//End of listener
    
    }//End of ViewDidLoad
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //End.....
    
    
    //Actions
    
    @IBAction func loginButton(_ sender: Any) {
        //Access Firebase
        recheck()
    }
        //...
    
    
    @IBAction func signupButton(_ sender: Any) {
        //segues to new view to sign up
        performSegue(withIdentifier: "ShowSignup", sender: self)
    }
        //...
 
    
        // for adjusting text field distance from bottom
    func animateTextField(textField: UITextField, up: Bool) {
        let movementDistance: CGFloat = -200
        let movementDuration: Double = 0.3
        var movement: CGFloat = 0
        
        if up {
            movement = movementDistance
        }else {
            movement = -movementDistance
        }
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
    }
        //...
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up:true)
    }
        //...
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.animateTextField(textField: textField, up:false)
    }
        //...
    
    
    func recheck(){
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){ (user, error) in
            
            if self.emailTextField.text == "" || self.passwordTextField.text == "" {
                //Make alert
                let alert = UIAlertController(title: "Registration", message: "One or more fields are empty.", preferredStyle: .alert)
                
                let returnAction = UIAlertAction(title: "Return", style: .default) { action in
                }
                
                // actions of the alert controller
                alert.addAction(returnAction)
                
                self.usersViewController?.fetchUserAndSetupNavBarTitle()
                // action to present the alert controller
                self.present(alert, animated: true, completion: nil)
                
                //end of if statement
            }else {
                if self.isValidEmail(email: self.emailTextField.text!) == true{
                    if  user != nil{ // if the user exists
                        // login
                    }else {
                        // post that the user doesnt exist
                        let alert = UIAlertController(title: "Registration", message: "Sorry, this username or password is incorrect.", preferredStyle: .alert)
                        
                        let returnAction = UIAlertAction(title: "Return", style: .default) { action in
                        }
                        // actions of the alert controller
                        alert.addAction(returnAction)
                        
                        self.usersViewController?.fetchUserAndSetupNavBarTitle()
                        // action to present the alert controller
                        self.present(alert, animated: true, completion: nil)
                        print(error!)
                    }
                }else{
                    let alert = UIAlertController(title: "Registration", message: "Please enter a valid email address", preferredStyle: .alert)
                    
                    let returnAction = UIAlertAction(title: "Return", style: .default) { action in
                    }
                    
                    // actions of the alert controller
                    alert.addAction(returnAction)
                    
                    self.usersViewController?.fetchUserAndSetupNavBarTitle()
                    // action to present the alert controller
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
        //...
   
    
    @IBAction func forgotPassword(_ sender: Any) {
        
      self.passwordRecoveryBottomConstraint.constant = 100
       
    }
        //...
    
    
    @IBAction func resetButton(_ sender: Any) {
        FIRAuth.auth()?.sendPasswordReset(withEmail: resetEmailTextInput.text!) { (error) in
                print("recovery password email has been sent!")
            }//End of reset text
        
        let alert = UIAlertController(title: "Passsword Reset", message: "Your password reset instructions have been emailed to you.", preferredStyle: .alert)
        
        let returnAction = UIAlertAction(title: "Ok", style: .default) { action in
            UIView.animate(withDuration: 0.5) {
                self.passwordRecoveryBottomConstraint.constant = 1000
            }
        }
        
        // actions of the alert controller
        alert.addAction(returnAction)
        
        self.usersViewController?.fetchUserAndSetupNavBarTitle()
        // action to present the alert controller
        present(alert, animated: true, completion: nil)
    }
        //...
    
    @IBAction func cancelResetButton(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.passwordRecoveryBottomConstraint.constant = 1000
        }
    }
        //...
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            textField.resignFirstResponder()
        }
        
        if textField == resetEmailTextInput {
            textField.resignFirstResponder()
        }
        
        return true
    }//End of textShouldReturn
    
    // validate an email for the right format
    func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
}
//End...

extension UITextField {
    func underlined(){
        
        self.borderStyle = .none
        self.layer.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9843137255, blue: 0.9960784314, alpha: 1)
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 0.6509803922, green: 0.6745098039, blue: 0.7019607843, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}


