
import UIKit
import MBProgressHUD
import CoreLocation
import AudioToolbox
class ViewController: UIViewController, OpenWeatherMapDelegate, OpenWeatherMapDayDelegate, DarkSkyWeekDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var weekTableView: UITableView!
    @IBOutlet weak var dayCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIView!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var informationView: UIView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var heightConstrain: NSLayoutConstraint!
    @IBOutlet weak var rightConstrain: NSLayoutConstraint!
    @IBOutlet weak var leftConstrain: NSLayoutConstraint!
    
    let locationManager = CLLocationManager()
    let inputCityView = InputCityView.instanceFromNib()
    let dayInformationView = DayInformationView.instanceFromNib()
    let alertView = AlertView.instanceFromNib()
    var openWeather = OpenWeatherMap()
    var openWeatherDay = OpenWeatherMapDay()
    var darkSky = DarkSkyWeek()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        self.openWeather.delegate = self
        self.openWeatherDay.delegate = self
        self.darkSky.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.requestWhenInUseAuthorization()
        locationManager.activityType =  .automotiveNavigation
        locationManager.startUpdatingLocation()
        informationView.dropShadow(color: .black, shadowOpacity: 10, shadowRadius: 10)
        self.view.backgroundColor = #colorLiteral(red: 0.06081704795, green: 0.6599709988, blue: 0.8518591523, alpha: 1)
        inputCityView.okButton.dropShadow(color: .black, shadowOpacity: 5, shadowRadius: 5)
        inputCityView.mainView.dropShadow(color: .black, shadowOpacity: 5, shadowRadius: 5)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(touchBlur(sender:)))
        recognizer.numberOfTapsRequired = 1
        self.inputCityView.blur.addGestureRecognizer(recognizer)
    }
    
    func activityIndicator(){
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        openWeather.hud = hud
        hud.mode = .indeterminate
        hud.bezelView.blurEffectStyle = .light
        hud.label.text = "loading"
        hud.show(animated: true)
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.inputCityView.blur.alpha = 0.7
        }) { (true) in
            UIView.animate(withDuration: 0.2, animations: {
                self.inputCityView.mainView.alpha = 1
            })}
        inputCityView.frame = self.view.frame
        inputCityView.center.x = view.center.x
        inputCityView.center.y = view.center.y
        inputCityView.mainView.layer.cornerRadius = 10
        inputCityView.mainView.backgroundColor = self.view.backgroundColor
        inputCityView.cityTextField.attributedPlaceholder = NSAttributedString(string: "Input city", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]) 
        inputCityView.okButton.backgroundColor = self.view.backgroundColor
        inputCityView.okButton.layer.cornerRadius = 10
        inputCityView.okButton.layer.borderWidth = 1
        inputCityView.okButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        inputCityView.delegate = self
        view.addSubview(inputCityView)
    }
    
    @IBAction func myLocationButtonPressed(_ sender: UIButton) {
        
        locationManager.startUpdatingLocation()
    }
    
    func updateWeatherInfo() {
        
        openWeather.hud.hide(animated: true)        
        self.darkSky.getWeekRequest(lat: openWeather.latitude!, lon: openWeather.lontitude!)
        self.weatherIconImageView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveLinear, animations: {
            self.weatherIconImageView.alpha = 0.5
            self.heightConstrain.constant = 230
            self.leftConstrain.constant = 70
            self.rightConstrain.constant = 70
            self.view.layoutIfNeeded()
        })
        { (true) in
            UIView.animate(withDuration: 0.3) {
                self.weatherIconImageView.alpha = 1
                self.heightConstrain.constant = 260
                self.leftConstrain.constant = 50
                self.rightConstrain.constant = 50
                self.view.layoutIfNeeded()
            }
        }
        self.weatherIconImageView.image = UIImage(named: openWeather.icon!)
        self.cityLabel.text = "\(openWeather.nameCity!), \(openWeather.nameCountry!)"
        self.temperatureLabel.text = "\(openWeather.temp! - 273)º"
        self.humidityLabel.text = "Влажность: \(openWeather.humidity!)%"
        self.pressureLabel.text = "Давление: \(openWeather.pressure!) гПа"
        self.windSpeedLabel.text = "Скорость ветра: \(openWeather.windSpeed!) м/с"
        self.cloudCoverLabel.text = "Облачность: \(openWeather.clouds!)%"
        self.visibilityLabel.text = "Видимость: \(openWeather.visibility!) м"
        self.descriptionLabel.text = openWeather.description
        self.dateLabel.text = openWeather.currentTime
        
        if self.openWeather.nigthTime! {
            
            self.view.backgroundColor = #colorLiteral(red: 0.0541562736, green: 0.05518737435, blue: 0.1716684103, alpha: 1)
            self.weekTableView.backgroundColor = self.view.backgroundColor
            self.informationView.backgroundColor = self.view.backgroundColor
            self.scrollView.backgroundColor = self.view.backgroundColor
            dayCollectionView.backgroundColor = self.view.backgroundColor
            
            informationView.dropShadow(color: .white, shadowOpacity: 20, shadowRadius: 5)
            inputCityView.okButton.dropShadow(color: .white, shadowOpacity: 5, shadowRadius: 5)
            inputCityView.mainView.dropShadow(color: .white, shadowOpacity: 5, shadowRadius: 5)
            dayInformationView.mainView.dropShadow(color: .white, shadowOpacity: 5, shadowRadius: 5)
        }else{
            
            self.view.backgroundColor = #colorLiteral(red: 0.06081704795, green: 0.6599709988, blue: 0.8518591523, alpha: 1)
            self.weekTableView.backgroundColor = self.view.backgroundColor
            self.informationView.backgroundColor = self.view.backgroundColor
            self.scrollView.backgroundColor = self.view.backgroundColor
            dayCollectionView.backgroundColor = self.view.backgroundColor
            
            informationView.dropShadow(color: .black, shadowOpacity: 20, shadowRadius: 5)
            inputCityView.okButton.dropShadow(color: .black, shadowOpacity: 5, shadowRadius: 5)
            inputCityView.mainView.dropShadow(color: .black, shadowOpacity: 5, shadowRadius: 5)
            dayInformationView.mainView.dropShadow(color: .black, shadowOpacity: 5, shadowRadius: 5)
            
        }
    }
    
    func failure(errorName: String?) {
       openWeather.hud.hide(animated: true)
        self.alertView.mainView.alpha = 1
        alertView.frame = self.view.frame
        alertView.blur.alpha = 0.7
        alertView.mainView.layer.cornerRadius = 10
        alertView.mainView.backgroundColor = self.view.backgroundColor
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        alertView.errorTextLabel.text = errorName!
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.alertView.mainView.frame.origin.x -= 10
        }) { (true) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.alertView.mainView.frame.origin.x += 20
            }) { (true) in
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                    self.alertView.mainView.frame.origin.x -= 10
                })
            }
        }
        alertView.okButton.backgroundColor = self.view.backgroundColor
        alertView.okButton.layer.cornerRadius = 10
        alertView.okButton.layer.borderWidth = 1
        alertView.okButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        if  self.view.backgroundColor == #colorLiteral(red: 0.06081704795, green: 0.6599709988, blue: 0.8518591523, alpha: 1) {
            alertView.okButton.dropShadow(color: .black, shadowOpacity: 5, shadowRadius: 5)
            alertView.mainView.dropShadow(color: .black, shadowOpacity: 5, shadowRadius: 5)
        }else {
            alertView.okButton.dropShadow(color: .white, shadowOpacity: 5, shadowRadius: 5)
            alertView.mainView.dropShadow(color: .white, shadowOpacity: 5, shadowRadius: 5)
        }
        view.addSubview(alertView)
        
    }
    
    func updateDayWeatherInfo() {
        dayCollectionView.reloadData()
        
    }
    func updateMonthWeatherInfo() {
        
        self.weekTableView.reloadData()
    }
    
    @IBAction func touchBlur( sender: UITapGestureRecognizer){
        
        UIView.animate(withDuration: 0.3, animations: {
            self.inputCityView.mainView.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 0.25, animations: {
                self.inputCityView.blur.alpha = 0
            }) { (true) in
                self.inputCityView.removeFromSuperview()
            }}
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let currentLocation = locations.first{
            locationManager.stopUpdatingLocation()
            let coords = CLLocationCoordinate2DMake(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            
            self.openWeatherDay.getDayWeatherFor(geo: coords)
            self.openWeather.getWeatherFor(geo: coords)
            self.activityIndicator()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        self.alertView.mainView.alpha = 1
        alertView.frame = self.view.frame
        alertView.blur.alpha = 0.7
        alertView.mainView.layer.cornerRadius = 10
        alertView.mainView.backgroundColor = self.view.backgroundColor
        
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        
        alertView.errorTextLabel.text = "Can't get your location!"
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            self.alertView.mainView.frame.origin.x -= 10
        }) { (true) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.alertView.mainView.frame.origin.x += 20
            }) { (true) in
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                    self.alertView.mainView.frame.origin.x -= 10
                })
            }
        }
        
        alertView.okButton.backgroundColor = self.view.backgroundColor
        alertView.okButton.layer.cornerRadius = 10
        alertView.okButton.layer.borderWidth = 1
        alertView.okButton.layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        if  self.view.backgroundColor == #colorLiteral(red: 0.06081704795, green: 0.6599709988, blue: 0.8518591523, alpha: 1) {
            alertView.okButton.dropShadow(color: .black, shadowOpacity: 5, shadowRadius: 5)
            alertView.mainView.dropShadow(color: .black, shadowOpacity: 5, shadowRadius: 5)
        }else {
            alertView.okButton.dropShadow(color: .white, shadowOpacity: 5, shadowRadius: 5)
            alertView.mainView.dropShadow(color: .white, shadowOpacity: 5, shadowRadius: 5)
        }
        view.addSubview(alertView)
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        openWeatherDay.dateArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customcell", for: indexPath) as? CustomDayCell
            else {
                return UICollectionViewCell()
        }
        cell.tempLabel.text = "\(String(openWeatherDay.tempArray[indexPath.row]))°"
        cell.dateLabel.text = openWeatherDay.dateArray[indexPath.row]
        cell.iconImage.image = UIImage(named: openWeatherDay.iconArray[indexPath.row])
        cell.layer.cornerRadius = 10
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let size = CGSize(width: 70, height: 90)
        return size
    }
    
}

extension ViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        darkSky.iconArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomWeekCell else {
            return UITableViewCell()
        }
        cell.layer.cornerRadius = 10
        cell.tempView.layer.cornerRadius = 10
        cell.backgroundColor = .clear
        cell.tempView.addGradient(arrayColor: [#colorLiteral(red: 0.06081704795, green: 0.6599709988, blue: 0.8518591523, alpha: 1), #colorLiteral(red: 0.0541562736, green: 0.05518737435, blue: 0.1716684103, alpha: 1)])
        cell.weatherIconImage.image = UIImage(named: darkSky.iconArray[indexPath.row])
        cell.dayNameLabel.text = darkSky.timeArray[indexPath.row]
        if cell.dayNameLabel.text == "Saturday"  {
            cell.dayNameLabel.textColor = .red
        } else if  cell.dayNameLabel.text == "Sunday"{
            cell.dayNameLabel.textColor = .red
        }else{
            cell.dayNameLabel.textColor = .white
        }
        cell.selectionStyle = .none
        cell.dayTempLabel.text = "\(String(darkSky.dayTempArray[indexPath.row]))°"
        cell.nightTempLabel.text = "\(String(darkSky.nightTempArray[indexPath.row]))°"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.2, animations: {
            
            self.dayInformationView.blur.alpha = 0.7
        }) { (true) in
            UIView.animate(withDuration: 0.2, animations: {
                self.dayInformationView.mainView.alpha = 1
            })}
        dayInformationView.frame = self.view.frame
        dayInformationView.center.x = view.center.x
        dayInformationView.center.y = view.center.y
        dayInformationView.mainView.backgroundColor = self.view.backgroundColor      
        dayInformationView.mainView.layer.cornerRadius = 10
        dayInformationView.iconImageView.image = UIImage(named: darkSky.iconArray[indexPath.row])
        dayInformationView.sunriceLabel.text = darkSky.sunriceTimeArray[indexPath.row]
        dayInformationView.sunsetLabel.text = darkSky.sunsetTimeArray[indexPath.row]
        dayInformationView.dayLabel.text = darkSky.timeArray[indexPath.row]
        dayInformationView.descriptionLabel.text = darkSky.summaryArray[indexPath.row]
        dayInformationView.maxTempLabel.text = "\(darkSky.dayTempArray[indexPath.row])° в \(darkSky.dayTempTimeArray[indexPath.row])"
        dayInformationView.minTempLabel.text = "\(darkSky.nightTempArray[indexPath.row])° в \(darkSky.nightTempTimeArray[indexPath.row])"
        dayInformationView.humidityLabel.text = "\(String(Int(darkSky.humidityArray[indexPath.row] * 100)))%"
        dayInformationView.pressureLabel.text = "\(String(darkSky.pressureArray[indexPath.row])) гПА"
        dayInformationView.cloudCoverLabel.text = "\(String(Int(darkSky.cloudCoverArray[indexPath.row] * 100)))%"
        dayInformationView.precipProbabilityLabel.text = "\(String(Int(darkSky.precipProbabilityArray[indexPath.row] * 100)))%"
        dayInformationView.visibilityLabel.text = "\(String(darkSky.visibilityArray[indexPath.row] * 1000)) м"
        dayInformationView.windSpeedLabel.text = "\(String(darkSky.windSpeedArray[indexPath.row])) м/c"
        view.addSubview(dayInformationView)
    }
    
}

extension ViewController: InputCityViewDelegate{
    
    func sendCity(data: String?) {
        
        self.activityIndicator()
        self.openWeather.getWeatherFor(city: data!)
        self.openWeatherDay.getDayWeatherFor(city: data!)
    }
    
}
