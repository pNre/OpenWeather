//
//  OpenWeatherTests.swift
//  OpenWeatherTests
//
//  Copyright (c) 2015 pNre. All rights reserved.
//

import UIKit
import XCTest
import OpenWeather

class OpenWeatherTests: XCTestCase {
    
    private var openWeather: OpenWeather?;
    
    let operationTimeout: NSTimeInterval = 15
    
    override func setUp() {
        super.setUp()
        
        //  Setup an instance of OpenWeather
        openWeather = OpenWeather()
    }

    func testQueryString() {

    }
    
    func testWeatherByCity_EmptyCity() {
        let result = openWeather!.weather(city: "", completion: { (data: AnyObject) -> () in
            XCTFail("The completion function should not be called")
        })
        
        XCTAssertFalse(result, "OpenWeather.weather should return false if called with invalid data")
    }
    
    func testWeatherByCity_NonExistentCity() {
        let expectation = expectationWithDescription("Completion function")
        
        let result = openWeather!.weather(city: "Random, fictional, city", completion: { (data: AnyObject) -> () in
            
            XCTAssert(data.isKindOfClass(NSDictionary), "Invalid data format")
            
            XCTAssertNotNil(data["message"], "message key missing from the resulting data dictionary")
            XCTAssertNotNil(data["cod"], "cod key missing from the resulting data dictionary")

            expectation.fulfill()
        })
        
        XCTAssertTrue(result, "OpenWeather.weather should return true")
        
        waitForExpectationsWithTimeout(operationTimeout, handler: { (error) -> Void in
            if error != nil {
                XCTFail("Completion handler not called")
            }
        })
    }
    
    func testWeatherByCity_ValidCity() {
        let expectation = expectationWithDescription("Completion function")
        
        let result = openWeather!.weather(city: "Rome, IT", completion: { (data: AnyObject) -> () in
            
            XCTAssert(data.isKindOfClass(NSDictionary), "Invalid data format")
            
            XCTAssertNotNil(data["name"], "name key missing from the resulting data dictionary")
            XCTAssertNotNil(data["weather"], "weather key missing from the resulting data dictionary")

            XCTAssertEqual(data["name"] as String, "Rome")
            
            expectation.fulfill()
            
        })
        
        XCTAssertTrue(result, "OpenWeather.weather should return true")
        
        waitForExpectationsWithTimeout(operationTimeout, handler: { (error) -> Void in
            if error != nil {
                XCTFail("Completion handler not called")
            }
        })
    }
    
}
