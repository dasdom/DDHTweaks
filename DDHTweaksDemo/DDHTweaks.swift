//  Created by dasdom on 24.01.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import Foundation
import UIKit

public class DDHTweak<T: Tweakable> {
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
      
      guard let value = newValue, value.isValid(min: minimumValue, max: maximumValue) else {
        return
      }
      switch newValue {
      case is Bool: fallthrough
      case is Int: fallthrough
      case is Float: fallthrough
      case is CGFloat: fallthrough
      case is Double: fallthrough
      case is String: fallthrough
      case is UIColor:
        storedCurrentValue = newValue
        value.store(key: tweakIdentifier)
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
    
    let identifier = category + "." + collection + "." + (name.isEmpty ? String(describing: type(of: defaultValue)) : name)
    
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

public protocol Tweakable {
  func isValid(min: Self?, max: Self?) -> Bool
  func store(key: String)
  //  func tweak(_ category: String, collection: String, name: String, min: Self?, max: Self?, action: ((DDHTweak<Self>) -> Void)?) -> Self
}

public extension Tweakable {
  func isValid(min: Self?, max: Self?) -> Bool {
    return true
  }
  
  public func store(key: String) {
    UserDefaults.standard.set(self, forKey: key)
  }
  
  @discardableResult func tweak(_ category: String, collection: String, name: String, min: Self? = nil, max: Self? = nil, action: ((DDHTweak<Self>) -> Void)? = nil) -> Self {
    return DDHTweak.value(category: category, collection: collection, name: name, defaultValue: self, min: min, max: max, action: action)
  }
  
  @discardableResult func tweak(_ id: String, file: String = #file, min: Self? = nil, max: Self? = nil, action: ((DDHTweak<Self>) -> Void)? = nil) -> Self {
    
    guard !id.isEmpty else { fatalError("id is not allowed to be empty") }
    let components = id.components(separatedBy: "/")
    let category: String
    let collection: String
    let name: String
    if components.count > 2 {
      category = components[0]
      collection = components[1]
      name = components[2]
    } else if components.count > 1 {
      let className = file.components(separatedBy: "/").last
      category = className ?? "Default"
      collection = components[0]
      name = components[1]
    } else {
      let className = file.components(separatedBy: "/").last
      category = className ?? "Default"
      collection = components[0]
      name = ""
    }
    return DDHTweak.value(category: category, collection: collection, name: name, defaultValue: self, min: min, max: max, action: action)
  }
}

//MARK: - Extenstions
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
