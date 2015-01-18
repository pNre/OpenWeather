#OpenWeather
Swift library for the [OpenWeatherMap API](http://openweathermap.org/api).

##Usage examples
###Initalization
```swift
// Initializes an instance
let ow = OpenWeather()

// Initializes an instance with an API key
let ow = OpenWeather(apiKey: "something")
```

####Extra parameters
#####Request timeout
The instance variable `timeoutInterval` defines a timeout (in seconds) for the HTTP requests.

```
//	5 seconds timeout
ow.timeoutInterval = 5
```

###Weather by city
```swift
let ow = OpenWeather()
ow.weather(city: "Rome, Italy", completion: { (data: AnyObject?, error: NSError?) -> Void in
	if error != nil {
		println("Error \(error!.message)")
		return
	}
	
	let weatherData = data as NSDictionary!
	let temp = weatherData["main"]["temp"]
	println("Temperature in Rome: \(temp)")
})
```