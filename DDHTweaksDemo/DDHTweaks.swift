//  Created by dasdom on 24.01.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import Foundation
import UIKit

open class DDHTweak<T: Any> {
  let tweakIdentifier: String
  let name: String
  
  typealias Action = ((DDHTweak) -> ())
  fileprivate var action: Action?
  fileprivate let defaultValue: T
  fileprivate var storedCurrentValue: T?
  
  fileprivate var minimumValue: T?
  fileprivate var maximumValue: T?
  fileprivate var stepValue: T?
  
  var currentValue: T? {
    get {
      return self.storedCurrentValue ?? defaultValue
    }
    set {
      print("newValue: \(newValue), min \(minimumValue), max \(maximumValue)")
      if newValue != nil {
        
        switch newValue {
        case let value as Bool:
          storedCurrentValue = newValue
          UserDefaults.standard.set(value, forKey: tweakIdentifier)
          print("Bool")
        case let value as Int:
          if let minimumValue = minimumValue as? Int, value < minimumValue {
            print("value out of range")
          } else if let maximumValue = maximumValue as? Int, value > maximumValue {
            print("value out of range")
          } else {
            storedCurrentValue = newValue
            UserDefaults.standard.set(value, forKey: tweakIdentifier)
          }
          print("Int")
        case let value as Float:
          if let minimumValue = minimumValue as? Float, value < minimumValue {
            print("value out of range")
          } else if let maximumValue = maximumValue as? Float, value > maximumValue {
            print("value out of range")
          } else {
            storedCurrentValue = newValue
            UserDefaults.standard.set(value, forKey: tweakIdentifier)
          }
          print("Float")
        case let value as CGFloat:
          if let minimumValue = minimumValue as? CGFloat, value < minimumValue {
            print("value out of range")
          } else if let maximumValue = maximumValue as? CGFloat, value > maximumValue {
            print("value out of range")
          } else {
            storedCurrentValue = newValue
            UserDefaults.standard.set(Float(value), forKey: tweakIdentifier)
          }
          print("Float")
        case let value as Double:
          if let minimumValue = minimumValue as? Double, value < minimumValue {
            print("value out of range")
          } else if let maximumValue = maximumValue as? Double, value > maximumValue {
            print("value out of range")
          } else {
            storedCurrentValue = newValue
            UserDefaults.standard.set(value, forKey: tweakIdentifier)
          }
          print("Double")
        case let value as String:
          storedCurrentValue = newValue
          UserDefaults.standard.set(value, forKey: tweakIdentifier)
          print("String")
        case let value as UIColor:
          storedCurrentValue = newValue
          let stringValue = value.hexString()
          UserDefaults.standard.set(stringValue, forKey: tweakIdentifier)
          print("UIColor: \(stringValue)")
        default:
          assert(false, "This is not a valid tweak default value. Use Bool, Int, Float, Double or String")
        }
        
        let valueHasBeenSetKey = "\(tweakIdentifier).valueHasBeenSet"
        UserDefaults.standard.set(true, forKey: valueHasBeenSetKey)
        UserDefaults.standard.synchronize()
        
        if let action = action {
          action(self)
        }
      }
    }
  }
  
  
  
  init(identifier: String, name: String, defaultValue: T) {
    self.tweakIdentifier = identifier
    self.defaultValue = defaultValue
    self.name = name
    let userDefaults = UserDefaults.standard
    
    let valueHasBeenSetKey = "\(tweakIdentifier).valueHasBeenSet"
    if userDefaults.bool(forKey: valueHasBeenSetKey) == true {
      if defaultValue is Bool {
        self.currentValue = UserDefaults.standard.bool(forKey: identifier) as? T
        print("Bool")
      } else if defaultValue is Int {
        self.currentValue = UserDefaults.standard.integer(forKey: identifier) as? T
        print("Int")
      } else if defaultValue is Float {
        self.currentValue = UserDefaults.standard.float(forKey: identifier) as? T
        print("Float")
      } else if defaultValue is CGFloat {
        self.currentValue = UserDefaults.standard.float(forKey: identifier) as? T
        print("CGFloat")
      } else if defaultValue is Double {
        self.currentValue = UserDefaults.standard.double(forKey: identifier) as? T
        print("Double")
      } else if defaultValue is String {
        self.currentValue = UserDefaults.standard.string(forKey: identifier) as? T
        print("String")
      } else if defaultValue is UIColor {
        if let hexString = UserDefaults.standard.string(forKey: identifier) {
          self.currentValue = UIColor.colorFromHex(hexString) as? T
        }
      } else {
        assert(false, "This is not a valid tweak default value. Use Bool, Int, Float, Double or String")
      }
    }
    
    print("identifer: \(identifier)")
  }
  
  func remove() {
    UserDefaults.standard.removeObject(forKey: tweakIdentifier)
    UserDefaults.standard.synchronize()
  }
  
  //    class func reset() {
  //        let store = TweakStore.sharedTweakStore
  //
  //        store.removeAllCategories()
  //        NSUserDefaults.resetStandardUserDefaults()
  //    }
  
  /**
   Creates a tweak if it is not already created and returns the current value. If the current value isn't set yet it
   returns the default value. The value of a tweak is stored in NSUserDefauls and survives relaunch of the app.
   
   - parameter category:     name for the category; for example "Login View"
   - parameter collection:   name for the collection; for example "Text"
   - parameter name:         name for the tweak; for example "Color"
   - parameter defaultValue: the default value
   - parameter min:          the minimal value
   - parameter max:          the maximal value
   - parameter action:       a closure which is executed every time the value is changed
   
   - returns: the current value or the default value if there is no current value
   */
  class func value(category: String, collection: String, name: String, defaultValue: T, min: T? = nil, max: T? = nil, action: Action? = nil) -> T {
    
    let identifier = category + "." + collection + "." + name
    
    let collection = collectionWithName(collection, categoryName: category)
    
    var tweak = collection.tweakWithIdentifier(identifier) as? DDHTweak
    if tweak == nil {
      tweak = DDHTweak(identifier: identifier, name: name, defaultValue: defaultValue) as DDHTweak
      
      collection.addTweak(tweak!)
    }
    
    if let min = min, let max = max {
      tweak?.minimumValue = min
      tweak?.maximumValue = max
    }
    
    tweak?.action = action
    
    if let action = action {
      action(tweak!)
    }
    
    return (tweak!.currentValue ?? tweak!.defaultValue) as T
  }
  
  //    class func removeForCategory(categoryName: String, collectionName: String, name: String) {
  //        let identifier = categoryName.lowercaseString + "." + collectionName.lowercaseString + "." + name
  //
  //        let collection = collectionWithName(collectionName, categoryName: categoryName)
  //
  //        if let tweak = collection.tweakWithIdentifier(identifier) as Tweak? {
  //            tweak.remove()
  //        }
  //
  //    }
  
  class func collectionWithName(_ collectionName: String, categoryName: String) -> TweakCollection {
    let store = TweakStore.sharedTweakStore
    
    var category = store.categoryWithName(categoryName)
    if category == nil {
      category = TweakCategory(name: categoryName)
      store.addCategory(category!)
    }
    
    var collection = category!.collectionWithName(collectionName)
    if collection == nil {
      collection = TweakCollection(name: collectionName)
      category!.addCollection(collection!)
    }
    return collection!
  }
}

//MARK: - Collection
class TweakCollection {
  let name: String
  //    var tweaks = [AnyObject]()
  
  fileprivate var identifierTweaks = [String:AnyObject]()
  
  init(name: String) {
    self.name = name
  }
  
  func allTweaks() -> [AnyObject] {
    var tweaks = [AnyObject]()
    for (_, value) in identifierTweaks {
      tweaks.append(value)
    }
    return tweaks
  }
  
  func addTweak<T>(_ tweak: DDHTweak<T>) {
    //        tweaks.append(tweaks)
    identifierTweaks[tweak.tweakIdentifier] = tweak
  }
  
  func removeTweak<T>(_ tweak: DDHTweak<T>) {
    tweak.remove()
    identifierTweaks.removeValue(forKey: tweak.tweakIdentifier)
  }
  
  func tweakWithIdentifier(_ identifier: String) -> AnyObject? {
    return identifierTweaks[identifier]
  }
}

//MARK: - Category
class TweakCategory {
  let name: String
  
  fileprivate var namedCollection = [String:TweakCollection]()
  
  init(name: String) {
    self.name = name
  }
  
  func allCollections() -> [TweakCollection] {
    var collections = [TweakCollection]()
    for (_, value) in namedCollection {
      collections.append(value)
    }
    return collections
  }
  
  func addCollection(_ collection: TweakCollection) {
    namedCollection[collection.name] = collection
  }
  
  //  func removeCollection(collection: TweakCollection) {
  //    namedCollection.removeValueForKey(collection.name)
  //  }
  
  func collectionWithName(_ name: String) -> TweakCollection? {
    return namedCollection[name]
  }
}

//MARK: - Store
private let _TweakStoreSharedInstance = TweakStore(name: "DefaultTweakStore")

/**
 This class is a singleton and it's responsible for storing the tweak categories.
 */
open class TweakStore {
  class var sharedTweakStore: TweakStore {
    return _TweakStoreSharedInstance
  }
  
  let name: String
  
  fileprivate var namedCategories = [String:TweakCategory]()
  
  init(name: String) {
    self.name = name
  }
  
  func allCategories() -> [TweakCategory] {
    var categories = [TweakCategory]()
    for (_, value) in namedCategories {
      categories.append(value)
    }
    return categories
  }
  
  func addCategory(_ category: TweakCategory) {
    namedCategories[category.name] = category
  }
  
  func categoryWithName(_ name: String) -> TweakCategory? {
    return namedCategories[name]
  }
}

// MARK: - Extensions
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

protocol Tweakable {
    
}

extension Tweakable {
    func tweak(_ category: String, collection: String, name: String, min: Self? = nil, max: Self? = nil, action: ((DDHTweak<Self>) -> Void)? = nil) -> Self {
        return DDHTweak.value(category: category, collection: collection, name: name, defaultValue: self, min: min, max: max, action: action)
    }
}

//MARK: - Extenstions
extension UIColor: Tweakable {}
extension String: Tweakable {}
extension Bool: Tweakable {}
extension Int: Tweakable {}
