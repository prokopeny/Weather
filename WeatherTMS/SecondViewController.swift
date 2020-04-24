
import UIKit
import MBProgressHUD
import CoreLocation
class SecondViewController: UIViewController, OpenWeatherMapWeekDelegate, CLLocationManagerDelegate {
    

    var openWeather = OpenWeatherMapWeek()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        self.openWeather.delegate = self

    }
    
    func activityIndicator(){
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        openWeather.hud = hud
        hud.mode = .indeterminate
        hud.bezelView.blurEffectStyle = .light
        hud.label.text = "loading"
        hud.show(animated: true)
    }
    
    func displayCity(){
        
        let alert = UIAlertController(title: "City", message: "enter name city", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "OK", style: .default) {
            (action) -> Void in
            if let textField  = alert.textFields?.first {
                self.activityIndicator()
                self.openWeather.getWeatherFor(city: textField.text!)
            }
        }
        alert.addTextField { (textField) in
            textField.placeholder = "City name"
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        displayCity()
    }
    @IBAction func myLocationButtonPressed(_ sender: UIButton) {
        locationManager.startUpdatingLocation()
    }
    
    func updateWeatherInfo() {
        
        openWeather.hud.hide(animated: true)
        print ("**************")
        print(openWeather.nameCity)

    

    }
    
    func failure() {
        
        // No connection to Internet
        let alertNetwork = UIAlertController(title: "Error", message: "No connection !", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (_) in
            self.openWeather.hud.hide(animated: true)
        }
        alertNetwork.addAction(ok)
        self.present(alertNetwork, animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.activityIndicator()
        if let currentLocation = locations.last{
            print (currentLocation.coordinate)
            locationManager.stopUpdatingLocation()
            let coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            self.openWeather.getWeatherFor(geo: coords)
            print(coords)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        print("cant get your location")
    }
    
}

