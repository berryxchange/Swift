//
//  UserModel.swift
//  UserStackWithTesting
//
//  Created by Quinton Quaye on 3/25/21.
//

import Foundation

class UserModel{
    var firstName: String
    var lastName: String
    var age: int
    var userName: String
    
    init(firstName: String, lastName: String, age: Int, userName: String){
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.userName = userName
    }
}
