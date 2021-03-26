//
//  UserStackWithTestingTests.swift
//  UserStackWithTestingTests
//
//  Created by Quinton Quaye on 3/25/21.
//

import XCTest
@testable import UserStackWithTesting

class UserStackWithTestingTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

   //Stack testing
    //the array if not filePrivate
    /*func testUserArrayIsNotNull(){
        // setup userStack
        let userStack = UserStack()
        
        //check the userArray is not null
        XCTAssertNotNil(userStack.userArray)
        
    }
 */
    
    //the array count is not null
    func testArrayCountIsNotNull(){
        //initialize the stack
        let userStack = UserStack()
        
        //check if not null
        XCTAssertNotNil(userStack.arrayIsEmpty)
    }
    
    // the array count is zero
    func testArrayCountIsZero(){
        //initialize the stack
        let userStack = UserStack()
        
        //check if stack is at zero users
        XCTAssertEqual(userStack.userArrayCount, 0)
    }
    
    
    //the array is not empty
    func testArrayIsNotEmpty(){
        //initialize UserStack
        let userStack = UserStack()
        
        //check if userStack is not empty
        
        //create initialized usercount
        let userCount = userStack.userArrayCount + 1
        
        //add a user
        userStack.pushToUserStack(user: UserModel(firstName: "Carl", lastName: "Mosby", age: 30, userName: "CMosby"))
        
        
        //check if user is not empty
        XCTAssertEqual(userStack.userArrayCount, userCount)
        
    }
    
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}


//Test adding a user to the stack
extension UserStackWithTestingTests{
    
    //test pushToUserStack
    func testPushToUserStack(){
        //initialize userStack
        let userStack = UserStack()
        
        //check if array is empty
        XCTAssertTrue(userStack.arrayIsEmpty)
        
        
        //initialize userCount with one addition
        let userCount = userStack.userArrayCount + 1
        
        //add user to stack
        userStack.pushToUserStack(user: UserModel(firstName: "Carl", lastName: "Mosby", age: 30, userName: "CMosby"))
        
        //check if user stack is not empty
        XCTAssertEqual(userStack.userArrayCount, userCount)
        
    }
}



