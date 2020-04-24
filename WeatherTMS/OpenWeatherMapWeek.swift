import UIKit
import Foundation
import Alamofire
import SwiftyJSON
import MBProgressHUD
import CoreLocation
protocol OpenWeatherMapWeekDelegate {
    func updateWeekWeatherInfo()
    func weekFailure()
}
class OpenWeatherMapWeek{
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/forecast"
    var nameCity: String?
    var tempArray = [0, 0, 0, 0, 0, 0, 0, 0]
    var dtArray = ["", "", "", "", "", "", "", ""]
    var iconArray = ["none","none","none","none","none","none","none","none"]
    var delegate: OpenWeatherMapWeekDelegate!
    var hud = MBProgressHUD()
    var count: Int?
    
    func getWeekWeatherFor(city: String){
        let appid = "dd34a6dca1947747c5658412d8c829a1"
        let params = ["q": city, "appid": appid, "lang": "ru"]
        setWeekRequest(params: params as [String : AnyObject])
    }
    
    func getWeekWeatherFor(geo: CLLocationCoordinate2D){
        let appid = "dd34a6dca1947747c5658412d8c829a1"
        let params = ["lat": geo.latitude, "lon": geo.longitude, "appid": appid, "lang": "ru"] as [String : Any]
        setWeekRequest(params: params as [String : AnyObject])
    }
    
    func setWeekRequest(params: [String: AnyObject]?){
        AF.request(weatherUrl, method: .get, parameters: params).responseJSON(queue: .main, options: .allowFragments) { (response) in
            
            switch response.result {
            case .success:
                print("Validation Successful")
                let weatherJson = JSON(response.value!)
                if let cnt = weatherJson["cnt"].int{
                    self.count = cnt
                }
                for element in 0...7{
                    if let tempResult = weatherJson["list"][element]["main"]["temp"].int{
                        self.tempArray[element] = tempResult
                    }
                    if let dtResult = weatherJson["list"][element]["dt"].int{
                        self.dtArray[element] = self.timeFromUnix(unixTime: dtResult)!
                    }
                    if let iconResult = weatherJson["list"][element]["weather"][0]["icon"].string{
                        self.iconArray[element] = iconResult
                    }
                }
    
                if let name = weatherJson["city"]["name"].string{
                    self.nameCity = name
                    
                    DispatchQueue.main.async {
                        self.delegate.updateWeekWeatherInfo()
                    }
                } else {
                    print("Wrong Inpur City!")
                    DispatchQueue.main.async {
                        self.hud.hide(animated: true)
                    }
                }
                
            case let .failure(error):
                self.delegate.weekFailure()
                print(error)
            }
            
        }
    }
    
    func timeFromUnix(unixTime: Int) -> String? {
        let timeInSecond = TimeInterval(unixTime)
        let weatherDate = Date(timeIntervalSince1970: timeInSecond)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: weatherDate)
    }
    
}


