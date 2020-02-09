//  Created by dasdom on 09.02.20.
//  
//

import UIKit

extension UIColor: Tweakable {
  public func store(key: String) {
    let stringValue = self.hexString()
    UserDefaults.standard.set(stringValue, forKey: key)
  }
}
extension String: Tweakable {}
extension Bool: Tweakable {}
extension Int: Tweakable {
  public func isValid(min: Int?, max: Int?) -> Bool {
    if let min = min, min > self {
      return false
    }
    if let max = max, max < self {
      return false
    }
    return true
  }
}
extension Float: Tweakable {
  public func isValid(min: Float?, max: Float?) -> Bool {
    if let min = min, min > self {
      return false
    }
    if let max = max, max < self {
      return false
    }
    return true
  }
}
extension CGFloat: Tweakable {
  public func isValid(min: CGFloat?, max: CGFloat?) -> Bool {
    if let min = min, min > self {
      return false
    }
    if let max = max, max < self {
      return false
    }
    return true
  }
  
  public func store(key: String) {
    UserDefaults.standard.set(Float(self), forKey: key)
  }
}
extension Double: Tweakable {
  public func isValid(min: Double?, max: Double?) -> Bool {
    if let min = min, min > self {
      return false
    }
    if let max = max, max < self {
      return false
    }
    return true
  }
}
