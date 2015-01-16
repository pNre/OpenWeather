//
//  OpenWeather.swift
//  OpenWeather
//
//  Copyright (c) 2015 pNre. All rights reserved.
//

import Foundation
import Alamofire

extension String {
    func URLEncodedString() -> String? {
        return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())?
    }
}

public class OpenWeather {
    public typealias OpenWeatherRequestCompletionFunction = (AnyObject) -> ()
    
    private let baseUrl = "http://api.openweathermap.org/data/2.5"
    
    //! OpenWeatherMap API key
    var apiKey: String?
    
    //! Requests timeout interval, in seconds
    var timeoutInterval: NSTimeInterval = 10
    
    /**
        Initializes an instance of the OpenWeather class
    
        :param: apiKey Optional OpenWeatherMap API key
    */
    public init(apiKey: String? = nil) {
        self.apiKey = apiKey
    }
    
    /**
        Sends a generic request for weather conditions
    
        :param: params Dictionary of [parameter: value] to add to the HTTP request
    */
    private func weather(#params: [String: String], completion: OpenWeatherRequestCompletionFunction) -> Bool {
        
        //  Send the request
        Alamofire.request(.GET, "\(baseUrl)/weather", parameters: params).responseJSON { (_, _, JSON, error) -> Void in

            if let gotError = error {
                return completion(["message": gotError.description, "cod": gotError.code])
            }
            
            if let JSONObject: AnyObject = JSON {
                return completion(JSONObject)
            }
            
            return completion(["message": "Invalid data", "cod": 0])
        }

        return true
        
    }
    
    /**
        Gets the weather condition given a city name
    
        :param: city City name
    */
    public func weather(#city: String, completion: OpenWeatherRequestCompletionFunction) -> Bool {
        if city.isEmpty {
            return false
        }
        
        return weather(params: ["q": city], completion: completion)
    }
}
