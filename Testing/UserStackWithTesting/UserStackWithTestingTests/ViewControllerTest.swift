//
//  ViewControllerTest.swift
//  UserStackWithTestingTests
//
//  Created by Quinton Quaye on 3/29/21.
//

import XCTest

class ViewControllerTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddUserFunction(){
        //initialize viewController
        let viewController = ViewController()
        
        //initialize StackController
        let userStack = viewController.userStack
        
        //add a mock user
        viewController.thisUser = UserModel(
            firstName: "Bob",
            lastName:"Doe",
            age: 39,
            userName: "BDoe",
            password: "1234567890"
        )

        userStack.pushToUserStack(user: viewController.thisUser)
        
        //test if user is added to the stack
        XCTAssertEqual(userStack.userArrayCount, 1)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

extension ViewControllerTest{
    func testRemovingAUser(){
        
    }
}
