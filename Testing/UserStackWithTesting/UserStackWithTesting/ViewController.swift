//
//  ViewController.swift
//  UserStackWithTesting
//
//  Created by Quinton Quaye on 3/25/21.
//

import UIKit

class ViewController: UIViewController {

    //userCollectionStack
    var userStack = UserStack()
    
    //Models
    var thisUser: UserModel!
    
    //Connections
    @IBOutlet weak var firstNameInput: UITextField!
    @IBOutlet weak var lastNameInput: UITextField!
    @IBOutlet weak var ageInput: UITextField!
    @IBOutlet weak var userNameInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    
    //initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        thisUser = UserModel(firstName: "", lastName: "", age: 0, userName: "", password: "")
    }

    
    
    //Action Connections
    @IBAction func addUserButton(_ sender: Any) {
        addUser()
    }
    
    func addUser(){
        thisUser = UserModel(
            firstName: firstNameInput.text!,
            lastName: lastNameInput.text!,
            age: Int(ageInput.text!)!,
            userName: userNameInput.text!,
            password: passwordInput.text!
        )
        
        userStack.pushToUserStack(user: thisUser)
        
        print("There are \(userStack.userArrayCount) users")
        print("All set!")
    }
    
    func clearUserInfo(){
        thisUser = UserModel(firstName: "", lastName: "", age: 0, userName: "", password: "")
    }
    
}
