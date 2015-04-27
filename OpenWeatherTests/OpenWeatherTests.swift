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

        openWeather = OpenWeather()
    }

    func testWeatherByCity_EmptyCity() {
        let expectation = expectationWithDescription("Completion function")
        
        let request = openWeather!.weather(city: "", completion: { (data: AnyObject?, error: NSError?) -> () in
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        
        XCTAssertNil(request)
        
        waitForExpectationsWithTimeout(operationTimeout, handler: { (error) -> Void in
            XCTAssertNil(error)
        })
    }
    
    func testWeatherByCity_NonExistentCity() {
        let expectation = expectationWithDescription("Completion function")
        
        let request = openWeather!.weather(city: "Random, fictional, city", completion: { (data: AnyObject?, error: NSError?) -> () in
            XCTAssertNotNil(error, "Error shouldn't be nil")
            expectation.fulfill()
        })
        
        XCTAssertNotNil(request)
        
        waitForExpectationsWithTimeout(operationTimeout, handler: { (error) -> Void in
            XCTAssertNil(error, "Completion handler not called")
        })
    }
    
    func testWeatherByCity_ValidCity() {
        let expectation = expectationWithDescription("Completion function")
        
        let request = openWeather!.weather(city: "Rome, Italy", completion: { (data: AnyObject?, error: NSError?) -> () in
            
            XCTAssertNotNil(data, "Data shouldn't be nil")
            XCTAssertNil(error, "Error should be nil")
            
            XCTAssertNotNil(data!["name"], "name key missing from the resulting data dictionary")
            XCTAssertNotNil(data!["weather"], "weather key missing from the resulting data dictionary")

            XCTAssertEqual(data!["name"] as! String, "Rome")
            
            expectation.fulfill()
            
        })
        
        XCTAssertNotNil(request)
        
        waitForExpectationsWithTimeout(operationTimeout, handler: { (error) -> Void in
            XCTAssertNil(error, "Completion handler not called")
        })
    }
    
    func testWeatherByLatLon() {
        let expectation = expectationWithDescription("Completion function")
        
        let request = openWeather!.weather(latitude: 0, longitude: 0, completion: { (data: AnyObject?, error: NSError?) -> () in
            
            XCTAssertNotNil(data, "Data shouldn't be nil")
            XCTAssertNil(error, "Error should be nil")
            
            XCTAssertNotNil(data!["name"], "name key missing from the resulting data dictionary")
            XCTAssertNotNil(data!["weather"], "weather key missing from the resulting data dictionary")
            
            expectation.fulfill()
            
        })
        
        XCTAssertNotNil(request)
        
        waitForExpectationsWithTimeout(operationTimeout, handler: { (error) -> Void in
            XCTAssertNil(error, "Completion handler not called")
        })
    }
    
    func testForecastByLatLon_Daily() {
        let expectation = expectationWithDescription("Completion function")

        openWeather!.forecast(latitude: 0, longitude: 0, completion: { (data: AnyObject?, error: NSError?) -> () in

            XCTAssertNotNil(data, "Data shouldn't be nil")
            XCTAssertNil(error, "Error should be nil")
            
            XCTAssertNotNil(data!["city"], "city key missing from the resulting data dictionary")
            XCTAssertNotNil(data!["list"], "list key missing from the resulting data dictionary")

            expectation.fulfill()

        })

        waitForExpectationsWithTimeout(operationTimeout, handler: { (error) -> Void in
            XCTAssertNil(error, "Completion handler not called")
        })
    }
}
