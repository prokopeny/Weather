import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation
protocol DarkSkyWeekDelegate {
    func updateMonthWeatherInfo()
}
class DarkSkyWeek{
    
    var delegate: DarkSkyWeekDelegate!
    var iconArray = [ "none","none","none","none","none","none","none"]
    var timeArray = [ "", "", "", "", "", "", ""]
    var sunriceTimeArray = [ "", "", "", "", "", "", ""]
    var sunsetTimeArray = [ "", "", "", "", "", "", ""]
    var summaryArray = [ "", "", "", "", "", "", ""]
    var humidityArray = [0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    var pressureArray = [0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    var cloudCoverArray = [0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    var precipProbabilityArray = [0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    var windSpeedArray = [0.0,0.0,0.0,0.0,0.0,0.0,0.0]
    var dayTempArray = [0,0,0,0,0,0,0]
    var dayTempTimeArray = [ "", "", "", "", "", "", ""]
    var nightTempArray = [0,0,0,0,0,0,0]
    var nightTempTimeArray = [ "", "", "", "", "", "", ""]
    var visibilityArray = [0,0,0,0,0,0,0]
    
    func getWeekRequest(lat: Double, lon: Double){
        
        let openWeatherMapBaseURL = "https://api.darksky.net/forecast/23285b24f119cebb62a95cf079dd0ffd/"
        let urlStr = "\(openWeatherMapBaseURL)\(lat),\(lon)?exclude=currently,minutely,alerts,flag&lang=ru&units=si"
        
        AF.request(urlStr, method: .get, parameters: nil).responseJSON(queue: .main, options: .allowFragments) { (response) in
            
            switch response.result {
            case .success:
                print("Validation Successful Dark Sky")
                let weatherJson = JSON(response.value!)
                
                for element in 1...7{
                    if let timeResult = weatherJson["daily"]["data"][element]["time"].int{
                        self.timeArray[element - 1] = self.timeFromUnix(unixTime: timeResult, dateFormat: "EEEE")!
                    }
                    if let nightTimeResult = weatherJson["daily"]["data"][element]["temperatureMinTime"].int{
                        self.nightTempTimeArray[element - 1] = self.timeFromUnix(unixTime: nightTimeResult, dateFormat: "HH:mm")!
                    }
                    if let dayTimeResult = weatherJson["daily"]["data"][element]["temperatureMaxTime"].int{
                        self.dayTempTimeArray[element - 1] = self.timeFromUnix(unixTime: dayTimeResult, dateFormat: "HH:mm")!
                    }
                    if let sunricetimeResult = weatherJson["daily"]["data"][element]["sunriseTime"].int{
                        self.sunriceTimeArray[element - 1] = self.timeFromUnix(unixTime: sunricetimeResult, dateFormat: "HH:mm")!
                    }
                    if let sunsettimeResult = weatherJson["daily"]["data"][element]["sunsetTime"].int{
                        self.sunsetTimeArray[element - 1] = self.timeFromUnix(unixTime: sunsettimeResult, dateFormat: "HH:mm")!
                    }
                    if let iconResult = weatherJson["daily"]["data"][element]["icon"].string{
                        self.iconArray[element - 1] = self.updateWeatherIcon(icon: iconResult)
                    }
                    if let summaryResult = weatherJson["daily"]["data"][element]["summary"].string{
                        self.summaryArray[element - 1] = summaryResult
                    }
                    if let humidityResult = weatherJson["daily"]["data"][element]["humidity"].double{
                        self.humidityArray[element - 1] = humidityResult
                    }
                    if let pressureResult = weatherJson["daily"]["data"][element]["pressure"].double{
                        self.pressureArray[element - 1] = pressureResult
                    }
                    if let cloudCoverResult = weatherJson["daily"]["data"][element]["cloudCover"].double{
                        self.cloudCoverArray[element - 1] = cloudCoverResult
                    }
                    if let windSpeedResult = weatherJson["daily"]["data"][element]["windSpeed"].double{
                        self.windSpeedArray[element - 1] = windSpeedResult
                    }
                    if let visibilityResult = weatherJson["daily"]["data"][element]["visibility"].int{
                        self.visibilityArray[element - 1] = visibilityResult
                    }
                    if let precipProbabilityResult = weatherJson["daily"]["data"][element]["precipProbability"].double{
                        self.precipProbabilityArray[element - 1] = precipProbabilityResult
                    }
                    if let dayTemp = weatherJson["daily"]["data"][element]["temperatureMax"].double{
                        self.dayTempArray[element - 1] = Int(dayTemp )
                    }
                    if let dayTemp = weatherJson["daily"]["data"][element]["temperatureMin"].double{
                        self.nightTempArray[element - 1] = Int((dayTemp))
                        
                    }
                    DispatchQueue.main.async {
                        self.delegate.updateMonthWeatherInfo()
                    }
                }
                
            case let .failure(error):
                print(error)
            }}
    }
    
    func timeFromUnix(unixTime: Int, dateFormat: String) -> String? {
        
        let timeInSecond = TimeInterval(unixTime)
        let weatherDate = Date(timeIntervalSince1970: timeInSecond)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: weatherDate)
    }
    
    func updateWeatherIcon(icon: String) -> String {
        
        var correctIcon: String
        switch icon {
        case "clear-day": correctIcon = "01d"
        case "clear-night": correctIcon = "01n"
        case "rain": correctIcon = "09d"
        case "snow": correctIcon = "13d"
        case "sleet": correctIcon = "13d"
        case "wind": correctIcon = "20d"
        case "fog": correctIcon = "50d"
        case "cloudy": correctIcon = "03n"
        case "partly-cloudy-day": correctIcon = "02d"
        case "partly-cloudy-night": correctIcon = "02n"
        case "hail": correctIcon = "11d"
        case "thunderstorm": correctIcon = "11d"
        case "tornado": correctIcon = "11d"
        default:
            correctIcon = "none"
        }
        return correctIcon
    }
}


