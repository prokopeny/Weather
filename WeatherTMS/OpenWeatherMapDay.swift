import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation
protocol OpenWeatherMapDayDelegate {
    func updateDayWeatherInfo()
}
class OpenWeatherMapDay{
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/forecast"
    var tempArray = [0, 0, 0, 0, 0, 0, 0, 0]
    var dateArray = ["", "", "", "", "", "", "", ""]
    var iconArray = ["none","none","none","none","none","none","none","none"]
    var delegate: OpenWeatherMapDayDelegate!
    
    func getDayWeatherFor(city: String){
        
        let appid = "dd34a6dca1947747c5658412d8c829a1"
        let params = ["q": city, "appid": appid, "lang": "ru"]
        setDayRequest(params: params as [String : AnyObject])
    }
    
    func getDayWeatherFor(geo: CLLocationCoordinate2D){
        
        let appid = "dd34a6dca1947747c5658412d8c829a1"
        let params = ["lat": geo.latitude, "lon": geo.longitude, "appid": appid, "lang": "ru"] as [String : Any]
        setDayRequest(params: params as [String : AnyObject])
    }
    
    func setDayRequest(params: [String: AnyObject]?){
        
        AF.request(weatherUrl, method: .get, parameters: params).responseJSON(queue: .main, options: .allowFragments) { (response) in
            
            switch response.result {
            case .success:
                print("Validation Successful Map Day")
                let weatherJson = JSON(response.value!)

                for element in 0...7{
                    if let tempResult = weatherJson["list"][element]["main"]["temp"].int{
                        self.tempArray[element] = tempResult - 273
                    }
                    if let dtResult = weatherJson["list"][element]["dt"].int{
                        self.dateArray[element] = self.timeFromUnix(unixTime: dtResult)!
                    }
                    if let iconResult = weatherJson["list"][element]["weather"][0]["icon"].string{
                        self.iconArray[element] = iconResult
                    }}
                   
                    DispatchQueue.main.async {
                        self.delegate.updateDayWeatherInfo()
                }
            case let .failure(error):
                print(error)
            }}
        
    }
    
    func timeFromUnix(unixTime: Int) -> String? {
        let timeInSecond = TimeInterval(unixTime)
        let weatherDate = Date(timeIntervalSince1970: timeInSecond)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: weatherDate)
    }
    
}

