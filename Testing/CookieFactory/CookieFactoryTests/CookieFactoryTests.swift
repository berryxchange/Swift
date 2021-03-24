//
//  CookieFactoryTests.swift
//  CookieFactoryTests
//
//  Created by Quinton Quaye on 3/23/21.
//

import XCTest
@testable import CookieFactory

class CookieFactoryTests: XCTestCase {

    //var mainView = CookieController()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
   
    //test to make sure cookie jar arrays are not nil
    func testInit_GingrbreadCookieArray_IsNotNil(){
        //initialize cookie
        let cookieJar = CookieController()
        //test if the cookie jar array is nil or not
        XCTAssertNotNil(cookieJar.gingerbreadCookies)
    }
    
    func testInit_ShortbreadCookieArray_IsNotNil(){
        //initialize cookie
        let cookieJar = CookieController()
        //test if the cookie jar array is nil or not
        XCTAssertNotNil(cookieJar.shortbreadCookies)
    }
    
    func testInit_ChocolateChipCookieArray_IsNotNil(){
        //initialize cookie
        let cookieJar = CookieController()
        //test if the cookie jar array is nil or not
        XCTAssertNotNil(cookieJar.chocolateChipCookies)
    }
    
    
    //test to make sure cookie count is zero
    func testInit_GingrbreadCookieArray_IsZero(){
        //initialize cookie
        let cookieJar = CookieController()
        //test if the cookie jar array is nil or not
        XCTAssertEqual(cookieJar.gingerbreadCookies!.count, 0)
    }
    
    func testInit_ShortbreadCookieArray_IsZero(){
        //initialize cookie
        let cookieJar = CookieController()
        //test if the cookie jar array is nil or not
        XCTAssertEqual(cookieJar.shortbreadCookies!.count, 0)
    }
    
    func testInit_ChocolateChipCookieArray_IsZero(){
        //initialize cookie
        let cookieJar = CookieController()
        //test if the cookie jar array is nil or not
        XCTAssertEqual(cookieJar.chocolateChipCookies!.count, 0)
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}



//Gingerbread Cookie Tests
//test adding cookies works correctly
extension CookieFactoryTests{
    func testAddGingerbreadCookie_Increments_numberOfCookies_ByOne(){
        //initialize the cookieJar
        let cookieJar = CookieController()
        
        //set the number of cookies
        let numberOfCookies = cookieJar.gingerbreadCookies!.count
        
        //add a cookie to the jar
        cookieJar.addGingerbreadCookie()
        
        //compare the number of cookies in the cookie jar to expected number of cookies
        let expectedNumberOfCookies = numberOfCookies + 1
        XCTAssertEqual(cookieJar.gingerbreadCookies!.count, expectedNumberOfCookies)
    }
    
    func testAddGingerbreadCookie_DoesNotIncrement_numberOfShortbreadCookies(){
        //initialize the cookieJar
        let cookieJar = CookieController()
        
        //set the number of cookies
        let numberOfCookies = cookieJar.shortbreadCookies!.count
        
        // add the intended cookie to the cookie jar of Gingerbread
        cookieJar.addGingerbreadCookie()
        
        //check to make sure that adding gingerbread cookies to its jar
        //doesnt increment the shortbread cookies jar
        XCTAssertEqual(cookieJar.shortbreadCookies!.count, numberOfCookies)
        
    }
    
    func testAddGingerbreadCookie_DoesNotIncrement_NumberOfChocolateChipCookies(){
        //initialize the cookie jar of chocolateChip cookies
        let cookieJar = CookieController()
        
        //set the number of cookies in the cookieJar
        let numberOfCookies = cookieJar.chocolateChipCookies!.count
        
        //add the gingerbread cookie to the jar
        cookieJar.addGingerbreadCookie()
        
        //check to make sure that addding the gingerbread cookie to its jar
        //doesnt increment the chocolateChip cookies jar
        XCTAssertEqual(cookieJar.chocolateChipCookies!.count, numberOfCookies)
        
    }
}


//Shortbread cookie tests
extension CookieFactoryTests{
    
    func testAddShortbreadCookie_Increments_numberOfCookies_ByOne(){
        //initialize the cookieJar
        let cookieJar = CookieController()
        
        //set the number of cookies
        let numberOfCookies = cookieJar.shortbreadCookies!.count
        
        // add a cookie to the cookie jar
        cookieJar.addShortbreadCookie()
        
        //set the expected cookie count
        let expectedNumberOfCookies = numberOfCookies + 1
        
        //compare the amount of cookies in the jar to the expected amount
        XCTAssertEqual(cookieJar.shortbreadCookies!.count, expectedNumberOfCookies)
        
    }
    
    func testAddShortbreadCookie_DoesNotIncrement_GingerbreadCookie(){
        //initialize cookieJar
        let cookieJar = CookieController()
        
        //set the number of cookies
        let numberOfCookies = cookieJar.gingerbreadCookies!.count
        
        //add shortbread
        cookieJar.addShortbreadCookie()
        
        
        //check to make sure adding shortbread cookies to its jar
        //does not increment the gingerbread cookies jar
        XCTAssertEqual(cookieJar.gingerbreadCookies!.count, numberOfCookies)
        
    }
    
    func testAddShortbreadCookie_DoesNotIncrement_ChocolateChipCookies(){
        //initialize cookieJar
        let cookieJar = CookieController()
        
        //set the number of cookies
        let numberOfCookies = cookieJar.chocolateChipCookies!.count
        
        //add shortbread
        cookieJar.addShortbreadCookie()
        
        //check to make sure adding shortbread cookies to its jar
        //does not increment the gingerbread cookies jar
        XCTAssertEqual(cookieJar.chocolateChipCookies!.count, numberOfCookies)
    }
}

//ChocolateChip cookie tests
extension CookieFactoryTests{
    func testAddChocolateChipCookie_Increments_numberOfCookies_ByOne(){
        //initialize the cookieJar
        let cookieJar = CookieController()
        
        //set the number of cookies
        let numberOfCookies = cookieJar.chocolateChipCookies!.count
        
        // add a cookie to the cookie jar
        cookieJar.addChocolateChipCookie()
        
        //set the expected cookie count
        let expectedNumberOfCookies = numberOfCookies + 1
        
        //compare the amount of cookies in the jar to the expected amount
        XCTAssertEqual(cookieJar.chocolateChipCookies!.count, expectedNumberOfCookies)
        
    }
    
    func testAddChocolateChipCookie_DoesNotIncrement_GingerbreadCookies(){
        //initialize cookieJar
        let cookieJar = CookieController()
        
        //set the number of cookies
        let numberOfCookies = cookieJar.gingerbreadCookies!.count
        
        //add chocolateChip Cookies
        cookieJar.addChocolateChipCookie()
        
        
        //check to make sure adding  chocolateChip cookies to its jar
        //does not increment the gingerbread cookies jar
        XCTAssertEqual(cookieJar.gingerbreadCookies!.count, numberOfCookies)
    }
    
    
    func testAddChocolateChipCookie_DoesNotIncrement_ShortbreadCookies(){
        //initialize cookieJar
        let cookieJar = CookieController()
        
        //set the number of cookies
        let numberOfCookies = cookieJar.shortbreadCookies!.count
        
        //add chocolateChip Cookies
        cookieJar.addChocolateChipCookie()
        
        //check to make sure adding chocolateChip Cookies to its jar
        //does not increment the gingerbread cookies jar
        XCTAssertEqual(cookieJar.shortbreadCookies!.count, numberOfCookies)
    }
}


//Reset Tests
extension CookieFactoryTests{
    func testReset_GingerbreadCookieArray_WithZeroElements_RemainsEmpty(){
        //initialize the cookie jar
        let cookieJar = CookieController()
        
        //reset the gingerbread cookie array
        cookieJar.reset()
        
        // check the total of the gingerbread cookies
        XCTAssertEqual(cookieJar.gingerbreadCookies!.count, 0)
    }
    
    func testReset_ShortbreadCookieArray_WithZeroElements_RemainsEmpty(){
        //initialize the cookie jar
        let cookieJar = CookieController()
        
        //reset the shortbread cookie array
        cookieJar.reset()
        
        // check the total of the shortbread cookies
        XCTAssertEqual(cookieJar.shortbreadCookies!.count, 0)
    }
    
    func testReset_ChocolateChipCookieArray_WithZeroElements_RemainsEmpty(){
        //initialize the cookie jar
        let cookieJar = CookieController()
        
        //reset the chocolate chip cookie array
        cookieJar.reset()
        
        // check the total of the chocolate chip cookies
        XCTAssertEqual(cookieJar.chocolateChipCookies!.count, 0)
    }
    
    //check to make sure the array resets with elements inside the array
    func testReset_GingerbreadCookieArray_WithElements_BecomeEmpty(){
        //initialize the cookie jar
        let cookieJar = CookieController()
        
        //add item to the array, then reset the gingerbread cookie array
        cookieJar.addGingerbreadCookie()
        cookieJar.reset()
        
        // check the total of the gingerbread cookies
        XCTAssertEqual(cookieJar.gingerbreadCookies!.count, 0)
    }
    
    func testReset_ShortbreadCookieArray_WithElements_BecomeEmpty(){
        //initialize the cookie jar
        let cookieJar = CookieController()
        
        //add item to the array, then reset the shortbread cookie array
        cookieJar.addShortbreadCookie()
        cookieJar.reset()
        
        // check the total of the shortbread cookies
        XCTAssertEqual(cookieJar.shortbreadCookies!.count, 0)
    }
    
    func testReset_ChocolateChipCookieArray_WithElements_BecomeEmpty(){
        //initialize the cookie jar
        let cookieJar = CookieController()
        
        //add item to the array, then reset the chocolate chip cookie array
        cookieJar.addChocolateChipCookie()
        cookieJar.reset()
        
        // check the total of the chocolate chip cookies
        XCTAssertEqual(cookieJar.chocolateChipCookies!.count, 0)
    }
}
