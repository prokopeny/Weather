import Foundation
import UIKit
extension UIView {
    
    func roundCorners(radius: CGFloat? = 10) {
        
        self.layer.cornerRadius = radius ?? 10
    }
    
    func dropShadow(color: UIColor, shadowOpacity: Float, shadowRadius: CGFloat){
    
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func addGradient(arrayColor: [CGColor]) {
        
        let gradient = CAGradientLayer()
        gradient.colors = arrayColor
        gradient.startPoint = CGPoint(x: 0.4, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.6, y: 0.5)
        gradient.frame = self.bounds
        gradient.cornerRadius = 10
        gradient.borderWidth = 1
        gradient.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.addSublayer(gradient)
       
    }
    
}
