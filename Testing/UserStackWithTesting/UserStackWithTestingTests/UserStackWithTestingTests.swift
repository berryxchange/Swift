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
    //the array is not empty
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
