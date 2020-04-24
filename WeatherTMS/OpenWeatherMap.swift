import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CoreLocation
protocol OpenWeatherMapDelegate {
    func updateWeatherInfo()
    func failure(errorName:String?)
}
class OpenWeatherMap{
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather"
    var nameCity: String?
    var lontitude: Double?
    var latitude: Double?
    var nameCountry: String?
    var temp: Int?
    var description: String?
    var windSpeed: Double?
    var clouds: Int?
    var humidity: Int?
    var pressure: Int?
    var visibility: Int?
    var currentTime: String?
    var icon: String?
    var nigthTime: Bool?
    var delegate: OpenWeatherMapDelegate!
    var hud = MBProgressHUD()
    
    func getWeatherFor(city: String){
        let appid = "dd34a6dca1947747c5658412d8c829a1"
        let params = ["q": city, "appid": appid, "lang": "ru"]
        setRequest(params: params as [String : AnyObject])
    }
    
    func getWeatherFor(geo: CLLocationCoordinate2D){
        let appid = "dd34a6dca1947747c5658412d8c829a1"
        let params = ["lat": geo.latitude, "lon": geo.longitude, "appid": appid, "lang": "ru"] as [String : Any]
        setRequest(params: params as [String : AnyObject])
    }
    
    func setRequest(params: [String: AnyObject]?){
        AF.request(weatherUrl, method: .get, parameters: params).responseJSON(queue: .main, options: .allowFragments) { (response) in
            
            switch response.result {
            case .success:
                print("Validation Successful")
                let weatherJson = JSON(response.value!)
                
                if let nameC = weatherJson["sys"]["country"].string{
                    self.nameCountry = nameC
                }
                if let lon = weatherJson["coord"]["lon"].double{
                    self.lontitude = lon
                }
                if let lat = weatherJson["coord"]["lat"].double{
                    self.latitude = lat
                }
                if let speed = weatherJson["wind"]["speed"].double{
                    self.windSpeed = speed
                }
                if let cloud = weatherJson["clouds"]["all"].int{
                    self.clouds = cloud
                }
                if let hum = weatherJson["main"]["humidity"].int{
                    self.humidity = hum
                }
                if let pres = weatherJson["main"]["pressure"].int{
                    self.pressure = pres
                }
                if let visib = weatherJson["visibility"].int{
                    self.visibility = visib
                }
                if let temperature = weatherJson["main"]["temp"].int {
                    self.temp = temperature
                }
                if let descript = weatherJson["weather"][0]["description"].string{
                    self.description = descript
                }
                if let dt = weatherJson["dt"].int{
                    self.currentTime = self.timeFromUnix(unixTime: dt)
                }
                if let icon = weatherJson["weather"][0]["icon"].string{
                    self.icon = icon
                } else {
                    self.icon = "none"
                }
                if let name = weatherJson["name"].string{
                    self.nameCity = name
                    self.nigthTime = self.isTimeNight(weatherJson: weatherJson)
                    
                    DispatchQueue.main.async {
                        self.delegate.updateWeatherInfo()
                    }} else {
                    self.delegate.failure(errorName: "Wrong Input City!")
                   }
            case let .failure(error):
                self.delegate.failure(errorName: "No connection!")
                print(error)
            }}
    }
    
    func timeFromUnix(unixTime: Int) -> String? {
        let timeInSecond = TimeInterval(unixTime)
        let weatherDate = Date(timeIntervalSince1970: timeInSecond)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMMM d, yyyy"
        return dateFormatter.string(from: weatherDate)
    }

    func isTimeNight(weatherJson: JSON)-> Bool{
        var nightTime = false
        let nowTime = Double (NSDate().timeIntervalSince1970)
        if let sunrise = weatherJson["sys"]["sunrise"].double{
            if let sunset = weatherJson["sys"]["sunset"].double{
                if (nowTime < sunrise || nowTime > sunset) {
                    nightTime = true
                }
            }} else{
            print("Error")
        }
        return nightTime
    }
    
}

