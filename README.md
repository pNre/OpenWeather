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

##Extra parameters

#####Request timeout
The `timeoutInterval` property (default value `10`) defines a timeout (in seconds) for the HTTP requests.

```
//	5 seconds timeout
ow.timeoutInterval = 5
```

#####Locale
OpenWeatherMap supports a bunch of different locales. 

The library automatically appends to each request the current system locale unless a custom one is set through the `locale` property.

```
//	Uses the current locale
ow.locale = nil

//	Always use english
ow.locale = "en"
```

For a list of supported locales refer to: [http://openweathermap.org/current#multi](http://openweathermap.org/current#multi)

#####Units
OpenWeatherMap supports 2 different unit systems:

* `metric` (default in OpenWeather)
* `imperial`

```
//	Use the imperial system
ow.units = "imperial"
```