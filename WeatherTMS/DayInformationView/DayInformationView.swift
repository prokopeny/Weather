
import UIKit

class DayInformationView: UIView {

    class func instanceFromNib() -> DayInformationView{
           return UINib (nibName: "DayInformationView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! DayInformationView
       }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.mainView.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 0.2, animations: {
                self.blur.alpha = 0
            }) { (true) in
                self.removeFromSuperview()
            }}
    }
 
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    @IBOutlet weak var fifthView: UIView!

    @IBOutlet weak var sixView: UIView!
    @IBOutlet weak var blur: UIVisualEffectView!
     @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var precipProbabilityLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunriceLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var minTempLabel: UILabel!
    
    
    @IBOutlet weak var maxTempLabel: UILabel!
    
    
}
