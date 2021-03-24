//
//  cookieTest.swift
//  CookieFactoryTests
//
//  Created by Quinton Quaye on 3/23/21.
//

import XCTest

class cookieTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    //test to make sure the cookies are not nil
    func testInit_ChocolateChipCookieType_DoesNotReturnNil(){
        //initialize cookie
        let cookie = Cookie(type: .chocolateChip)
        // test cookie if nil or not
        XCTAssertNotNil(cookie)
    }
    
    func testInit_ShortbreadCookieType_DoesNotReturnNil(){
        //initialize cookie
        let cookie = Cookie(type: .shortbread)
        // test cookie if nil or not
        XCTAssertNotNil(cookie)
    }
    
    func testInit_GingerbreadCookieType_DoesNotReturnNil(){
        //initialize cookie
        let cookie = Cookie(type: .gingerbread)
        // test cookie if nil or not
        XCTAssertNotNil(cookie)
    }
    
    
    //check to make sure cookie is of the correct type
    func testInit_chocolateCookieType_IsSetCorretly(){
        //initialize cookie
        let cookie = Cookie(type: .chocolateChip)
        //text and make sure the iniialized type is correct
        XCTAssertEqual(cookie.type, .chocolateChip)
    }
    
    func testInit_shortbreadCookieType_IsSetCorretly(){
        //initialize cookie
        let cookie = Cookie(type: .shortbread)
        //text and make sure the iniialized type is correct
        XCTAssertEqual(cookie.type, .shortbread)
    }
    
    func testInit_GingerbreadCookieType_IsSetCorretly(){
        //initialize cookie
        let cookie = Cookie(type: .gingerbread)
        //text and make sure the iniialized type is correct
        XCTAssertEqual(cookie.type, .gingerbread)
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
