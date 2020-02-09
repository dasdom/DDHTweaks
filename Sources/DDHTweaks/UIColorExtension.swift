//  Created by dasdom on 09.02.20.
//  
//

import UIKit

extension UIColor {
  /**
   Creates UIColor from hex string
   
   - parameter hexString: a string like #ffa533 or ffa533
   
   - returns: a UIColor instance
   */
  class func colorFromHex(_ hexString: String) -> UIColor {
    let scanner = Scanner(string: hexString)
    
    scanner.charactersToBeSkipped = CharacterSet.alphanumerics.inverted
    
    var value = UInt32()
    scanner.scanHexInt32(&value)
    
    let red: CGFloat = CGFloat((value & 0xFF0000) >> 16) / CGFloat(255.0)
    let green: CGFloat = CGFloat((value & 0xFF00) >> 8) / CGFloat(255.0)
    let blue: CGFloat = CGFloat((value & 0xFF)) / CGFloat(255.0)
    
    print("red \(red) green \(green) blue \(blue)")
    
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
  }
  
  /**
   Creates the hex string representing the color
   
   - returns: the hex string
   */
  func hexString() -> String {
    var redComponent = CGFloat()
    var greenComponent = CGFloat()
    var blueComponent = CGFloat()
    var alphaComponent = CGFloat()
    
    getRed(&redComponent, green: &greenComponent, blue: &blueComponent, alpha: &alphaComponent)
    
    let redInt = (UInt32(redComponent*255)) << 16
    let greenInt = (UInt32(greenComponent*255)) << 8
    let blueInt = UInt32(blueComponent*255)
    
    let colorInt = redInt+greenInt+blueInt
    let colorString = NSString(format: "%06X", colorInt) as String
    
    return colorString
  }
  
}
