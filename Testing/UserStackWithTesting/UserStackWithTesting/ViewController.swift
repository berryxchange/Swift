//
//  ViewController.swift
//  UserStackWithTesting
//
//  Created by Quinton Quaye on 3/25/21.
//

import UIKit

class ViewController: UIViewController {

    var userStack = UserStack()
    
    //var CoolPeople: [UserStack] = []
    
    var thisUser: UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        thisUser = UserModel(firstName: "", lastName: "", age: 0, userName: "")
    }

    @IBAction func addUserButton(_ sender: Any) {
        addUser()
    }
    
    func addUser(){
        userStack.pushToUserStack(user: thisUser)
        print("There are \(userStack.userArrayCount) users")
    }
    
}

