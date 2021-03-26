//
//  UserStack.swift
//  UserStackWithTesting
//
//  Created by Quinton Quaye on 3/25/21.
//

import Foundation

class UserStack{
    // the user array
    fileprivate var userArray: [UserModel]
    
    //initialize the array
    init(){
        self.userArray = []
    }
    
    //setup the array count
    public var userArrayCount: Int {
        return userArray.count
    }
    
    //check if array is empty
    public var arrayIsEmpty: Bool {
        return userArray.isEmpty
    }
    
    //setup the push to array
    public func pushToUserStack(user: UserModel){
        userArray.append(user)
    }
    
    //setup the peek on the top item of the array
    public func peekLastUser() -> UserModel{
        var thisUser: UserModel!
        
        if !userArray.isEmpty{
            thisUser = userArray.last!
        }
        
        return thisUser
    }
    
    //setup the pop on the top item of the array
    public func popLastUser() -> UserModel{
        return userArray.popLast()!
    }
}
