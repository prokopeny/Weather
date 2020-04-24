import Foundation
import SystemConfiguration
import Alamofire
struct Reachability {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}
