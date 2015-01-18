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
    
    /// Dictionary containing the variables to append to the query string of each request
    private var extraParams: [String: String] {
        var params: [String: String] = ["lang": self.locale!]
        
        if let key = apiKey {
            params = params | ["APPID": key]
        }
        
        if units.length > 0 {
            params = params | ["units": units]
        }
        
        return params
    }
    
    /// Data units format
    public var units: String = "metric"
    
    /// Locale sent to OpenWeatherMap to localize the response
    private var _locale: String? = nil
    public var locale: String? {
        get {
            if let currentLocale = _locale {
                return currentLocale
            }
            
            return NSLocale.preferredLanguages().first as String!
        }
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
    private func request(endpoint: String, params: [String: String], completion: OpenWeatherRequestCompletionFunction) -> Alamofire.Request {
        
        //  Send the request
        return Alamofire.request(.GET, "\(baseUrl)/\(endpoint)", parameters: (params | extraParams)).responseJSON { (_, _, JSON, requestError) -> Void in
            
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
    public func weather(#city: String, completion: OpenWeatherRequestCompletionFunction) -> Alamofire.Request? {
        if city.isEmpty {
            let error = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "OpenWeather",
                                  code: OpenWeatherError.InvalidInputData.rawValue,
                              userInfo: nil)
            completion(nil, error);
            return nil
        }
        
        return request("weather", params: ["q": city], completion: completion)
    }
    
    /**
        Gets the weather condition given a city id
    
        :param: id City id
    */
    public func weather(#id: UInt, completion: OpenWeatherRequestCompletionFunction) -> Alamofire.Request {
        return request("weather", params: ["id": String(id)], completion: completion)
    }
    
    /**
        Gets the weather condition given the (latitude, longitude) coordinates
    
        :param: latitude
        :param: longitude
    */
    public func weather(#latitude: Int, longitude: Int, completion: OpenWeatherRequestCompletionFunction) -> Alamofire.Request {
        return request("weather", params: ["lat": String(latitude), "lon": String(longitude)], completion: completion)
    }
    
    /**
        Gets the weather forecast given a city name
    
        :param: city City name
    */
    public func forecast(#city: String, daily: Bool = true, completion: OpenWeatherRequestCompletionFunction) -> Alamofire.Request? {
        if city.isEmpty {
            let error = NSError(domain: NSBundle.mainBundle().bundleIdentifier ?? "OpenWeather",
                                  code: OpenWeatherError.InvalidInputData.rawValue,
                              userInfo: nil)
            completion(nil, error);
            return nil
        }

        return request("forecast" + (daily ? "/daily" : ""), params: ["q": city], completion: completion)
    }
    
    /**
        Gets the weather forecast given the (latitude, longitude) coordinates
    
        :param: latitude
        :param: longitude
    */
    public func forecast(#latitude: Int, longitude: Int, daily: Bool = true, completion: OpenWeatherRequestCompletionFunction) -> Alamofire.Request {
        return request("forecast" + (daily ? "/daily" : ""), params: ["lat": String(latitude), "lon": String(longitude)], completion: completion)
    }
    
    /**
        Gets the weather forecast given a city id
    
        :param: id City id
    */
    public func forecast(#id: UInt, daily: Bool = true, completion: OpenWeatherRequestCompletionFunction) -> Alamofire.Request {
        return request("forecast" + (daily ? "/daily" : ""), params: ["id": String(id)], completion: completion)
    }
    
    /**
        Searches a city by name
    
        :param: city City name
    */
    public func search(#city: String, type: String = "like", sort: String = "population", completion: OpenWeatherRequestCompletionFunction) -> Alamofire.Request {
        return request("find", params: ["q": city, "type": type, "sort": sort], completion: completion)
    }
}
