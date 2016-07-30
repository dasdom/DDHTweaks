//
//  DDHTweaks.swift
//  DDHTweaksDemo
//
//  Created by dasdom on 24.01.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import Foundation
import UIKit

public class DDHTweak<T: Any> {
  let tweakIdentifier: String
  let name: String
  
  typealias Action = ((DDHTweak) -> ())
  private var action: Action?
  private let defaultValue: T
  private var storedCurrentValue: T?
  
  private var minimumValue: T?
  private var maximumValue: T?
  private var stepValue: T?
  
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
          NSUserDefaults.standardUserDefaults().setBool(value, forKey: tweakIdentifier)
          print("Bool")
        case let value as Int:
          if (minimumValue != nil && value < (minimumValue as? Int)) || (maximumValue != nil && value > (maximumValue as? Int)) {
            print("value out of range")
          } else {
            storedCurrentValue = newValue
            NSUserDefaults.standardUserDefaults().setInteger(value, forKey: tweakIdentifier)
          }
          print("Int")
        case let value as Float:
          if (minimumValue != nil && value < (minimumValue as? Float)) || (maximumValue != nil && value > (maximumValue as? Float)) {
            print("value out of range")
          } else {
            storedCurrentValue = newValue
            NSUserDefaults.standardUserDefaults().setFloat(value, forKey: tweakIdentifier)
          }
          print("Float")
        case let value as CGFloat:
          if (minimumValue != nil && value < (minimumValue as? CGFloat)) || (maximumValue != nil && value > (maximumValue as? CGFloat)) {
            print("value out of range")
          } else {
            storedCurrentValue = newValue
            NSUserDefaults.standardUserDefaults().setFloat(Float(value), forKey: tweakIdentifier)
          }
          print("Float")
        case let value as Double:
          if (minimumValue != nil && value < (minimumValue as? Double)) || (maximumValue != nil && value > (maximumValue as? Double)) {
            print("value out of range")
          } else {
            storedCurrentValue = newValue
            NSUserDefaults.standardUserDefaults().setDouble(value, forKey: tweakIdentifier)
          }
          print("Double")
        case let value as String:
          storedCurrentValue = newValue
          NSUserDefaults.standardUserDefaults().setObject(value, forKey: tweakIdentifier)
          print("String")
        case let value as UIColor:
          storedCurrentValue = newValue
          let stringValue = value.hexString()
          NSUserDefaults.standardUserDefaults().setObject(stringValue, forKey: tweakIdentifier)
          print("UIColor: \(stringValue)")
        default:
          assert(false, "This is not a valid tweak default value. Use Bool, Int, Float, Double or String")
        }
        
        let valueHasBeenSetKey = "\(tweakIdentifier).valueHasBeenSet"
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: valueHasBeenSetKey)
        NSUserDefaults.standardUserDefaults().synchronize()
        
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
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    let valueHasBeenSetKey = "\(tweakIdentifier).valueHasBeenSet"
    if userDefaults.boolForKey(valueHasBeenSetKey) == true {
      if defaultValue is Bool {
        self.currentValue = NSUserDefaults.standardUserDefaults().boolForKey(identifier) as? T
        print("Bool")
      } else if defaultValue is Int {
        self.currentValue = NSUserDefaults.standardUserDefaults().integerForKey(identifier) as? T
        print("Int")
      } else if defaultValue is Float {
        self.currentValue = NSUserDefaults.standardUserDefaults().floatForKey(identifier) as? T
        print("Float")
      } else if defaultValue is CGFloat {
        self.currentValue = NSUserDefaults.standardUserDefaults().floatForKey(identifier) as? T
        print("CGFloat")
      } else if defaultValue is Double {
        self.currentValue = NSUserDefaults.standardUserDefaults().doubleForKey(identifier) as? T
        print("Double")
      } else if defaultValue is String {
        self.currentValue = NSUserDefaults.standardUserDefaults().stringForKey(identifier) as? T
        print("String")
      } else if defaultValue is UIColor {
        if let hexString = NSUserDefaults.standardUserDefaults().stringForKey(identifier) {
          self.currentValue = UIColor.colorFromHex(hexString) as? T
        }
      } else {
        assert(false, "This is not a valid tweak default value. Use Bool, Int, Float, Double or String")
      }
    }
    
    print("identifer: \(identifier)")
  }
  
  func remove() {
    NSUserDefaults.standardUserDefaults().removeObjectForKey(tweakIdentifier)
    NSUserDefaults.standardUserDefaults().synchronize()
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
  class func value(category category: String, collection: String, name: String, defaultValue: T, min: T? = nil, max: T? = nil, action: Action? = nil) -> T {
    
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
  
  class func collectionWithName(collectionName: String, categoryName: String) -> TweakCollection {
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
  
  private var identifierTweaks = [String:AnyObject]()
  
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
  
  func addTweak<T>(tweak: DDHTweak<T>) {
    //        tweaks.append(tweaks)
    identifierTweaks[tweak.tweakIdentifier] = tweak
  }
  
  func removeTweak<T>(tweak: DDHTweak<T>) {
    tweak.remove()
    identifierTweaks.removeValueForKey(tweak.tweakIdentifier)
  }
  
  func tweakWithIdentifier(identifier: String) -> AnyObject? {
    return identifierTweaks[identifier]
  }
}

//MARK: - Category
class TweakCategory {
  let name: String
  
  private var namedCollection = [String:TweakCollection]()
  
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
  
  func addCollection(collection: TweakCollection) {
    namedCollection[collection.name] = collection
  }
  
  //  func removeCollection(collection: TweakCollection) {
  //    namedCollection.removeValueForKey(collection.name)
  //  }
  
  func collectionWithName(name: String) -> TweakCollection? {
    return namedCollection[name]
  }
}

//MARK: - Store
private let _TweakStoreSharedInstance = TweakStore(name: "DefaultTweakStore")

/**
 This class is a singleton and it's responsible for storing the tweak categories.
 */
public class TweakStore {
  class var sharedTweakStore: TweakStore {
    return _TweakStoreSharedInstance
  }
  
  let name: String
  
  private var namedCategories = [String:TweakCategory]()
  
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
  
  func addCategory(category: TweakCategory) {
    namedCategories[category.name] = category
  }
  
  func categoryWithName(name: String) -> TweakCategory? {
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
  class func colorFromHex(hexString: String) -> UIColor {
    let scanner = NSScanner(string: hexString)
    
    scanner.charactersToBeSkipped = NSCharacterSet.alphanumericCharacterSet().invertedSet
    
    var value = UInt32()
    scanner.scanHexInt(&value)
    
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
    func tweak(category: String, collection: String, name: String, min: Self? = nil, max: Self? = nil, action: ((DDHTweak<Self>) -> Void)? = nil) -> Self {
        return DDHTweak.value(category: category, collection: collection, name: name, defaultValue: self, min: min, max: max, action: action)
    }
}

//MARK: - Extenstions
extension UIColor: Tweakable {}
extension String: Tweakable {}
extension Bool: Tweakable {}
extension Int: Tweakable {}
