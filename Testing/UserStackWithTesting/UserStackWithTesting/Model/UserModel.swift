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
    var age: Int
    var userName: String
    var password: String
    
    init(firstName: String, lastName: String, age: Int, userName: String, password: String){
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.userName = userName
        self.password = password
    }
}
