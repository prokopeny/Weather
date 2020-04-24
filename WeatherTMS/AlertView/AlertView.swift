
import UIKit

class AlertView: UIView {
    var openWeather = OpenWeatherMap()
    class func instanceFromNib() -> AlertView{
        return UINib (nibName: "AlertView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! AlertView
    }
    
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var errorTextLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        self.openWeather.hud.hide(animated: true)
        UIView.animate(withDuration: 0.2, animations: {
            self.mainView.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 0.2, animations: {
                self.blur.alpha = 0
            }) { (true) in
                self.removeFromSuperview()
            }}
    }
}
