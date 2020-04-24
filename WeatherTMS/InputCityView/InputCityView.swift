
import UIKit
protocol InputCityViewDelegate: AnyObject{
    func sendCity(data:String?)
}

class InputCityView: UIView{
    
    class func instanceFromNib() -> InputCityView{
        return UINib (nibName: "InputCityView", bundle: nil).instantiate(withOwner: nil, options: nil).first as! InputCityView
    }
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet var blur: UIVisualEffectView!
    weak var delegate: InputCityViewDelegate?
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        
        delegate?.sendCity(data: cityTextField.text)
        UIView.animate(withDuration: 0.2, animations: {
            self.mainView.alpha = 0
        }) { (true) in
            UIView.animate(withDuration: 0.2, animations: {
                self.blur.alpha = 0
            }) { (true) in
                self.removeFromSuperview()
            }}
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
}
