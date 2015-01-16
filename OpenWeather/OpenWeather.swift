//
//  OpenWeather.swift
//  OpenWeather
//
//  Copyright (c) 2015 pNre. All rights reserved.
//

import Foundation
import Alamofire

enum OpenWeatherError: Int {
    case InvalidInputData = -1
}

public class OpenWeather {
    public typealias OpenWeatherRequestCompletionFunction = (AnyObject?, NSError?) -> ()

    /// URL of the OpenWeatherMap API endpoint
    private let baseUrl = "http://api.openweathermap.org/data/2.5"
    
    /// OpenWeatherMap API key
    var apiKey: String?
    
    /// If the apiKey is not nil, returns a dictionary containing 
    /// the variables to append to the query string of each request
    private var apiKeyParam: [String: String] {
        if let key = apiKey {
            return ["APPID": key]
        }
        
        return [String: String]()
    }

    /// Requests timeout, in seconds
    var timeoutInterval: NSTimeInterval {
        didSet {
            Alamofire.Manager.sharedInstance.session.configuration.timeoutIntervalForRequest = timeoutInterval
        }
    }
    
    /**
        Initializes an instance of the OpenWeather class
    
        :param: apiKey Optional OpenWeatherMap API key
    */
    public init(apiKey: String? = nil) {
        self.apiKey = apiKey
        self.timeoutInterval = 10
    }
    
    /**
        Sends an HTTP GET request to the OpenWeatherMap API service
    */
    private func request(endpoint: String, params: [String: String], completion: OpenWeatherRequestCompletionFunction) {
        
        //  Send the request
        Alamofire.request(.GET, "\(baseUrl)/\(endpoint)", parameters: (params | apiKeyParam)).responseJSON { (_, _, JSON, requestError) -> Void in
            
            //  Alamofire error
            if requestError != nil {
                return completion(nil, requestError)
            }
            
            //  API error message
            switch (JSON!["message"], JSON!["cod"]) {
            case (let message, let cod) where message is String && cod is String:
                let error = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "OpenWeather",
                                      code: (cod as String).toInt() ?? 0,
                                  userInfo: [
                                                NSLocalizedDescriptionKey: message as String!,
                                                "RemoteErrorCode": cod as String!
                                            ])
                
                return completion(JSON, error)
            default:
                return completion(JSON, nil)
            }
            
        }

    }

    /**
        Gets the weather condition given a city name
    
        :param: city City name
    */
    public func weather(#city: String, completion: OpenWeatherRequestCompletionFunction) {
        if city.isEmpty {
            let error = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "OpenWeather",
                                  code: OpenWeatherError.InvalidInputData.rawValue,
                              userInfo: nil)
            return completion(nil, error);
        }
        
        request("weather", params: ["q": city], completion: completion)
    }
    
    /**
        Gets the weather condition given the (latitude, longitude) coordinates
    
        :param: latitude
        :param: longitude
    */
    public func weather(#latitude: Int, longitude: Int, completion: OpenWeatherRequestCompletionFunction) {
        request("weather", params: ["lat": String(latitude), "lon": String(longitude)], completion: completion)
    }
    
    /**
        Gets the weather forecast given a city name
    
        :param: city City name
    */
    public func forecast(#city: String, daily: Bool = true, completion: OpenWeatherRequestCompletionFunction) {
        if city.isEmpty {
            let error = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "OpenWeather",
                                  code: OpenWeatherError.InvalidInputData.rawValue,
                              userInfo: nil)
            return completion(nil, error);
        }

        request("forecast" + (daily ? "/daily" : ""), params: ["q": city], completion: completion)
    }
    
    /**
        Gets the weather forecast given the (latitude, longitude) coordinates
    
        :param: latitude
        :param: longitude
    */
    public func forecast(#latitude: Int, longitude: Int, daily: Bool = true, completion: OpenWeatherRequestCompletionFunction) {
        request("forecast" + (daily ? "/daily" : ""), params: ["lat": String(latitude), "lon": String(longitude)], completion: completion)
    }
    
}
