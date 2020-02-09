//  Created by dasdom on 09.02.20.
//  
//

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
  
  public var currentValue: T? {
    get {
      return self.storedCurrentValue ?? defaultValue
    }
    set {
      print("newValue: \(String(describing: newValue)), min \(String(describing: minimumValue)), max \(String(describing: maximumValue))")
      
      guard let value = newValue, value.isValid(min: minimumValue, max: maximumValue) else {
        return
      }
      switch newValue {
      case is Bool,
           is Int,
           is Float,
           is CGFloat,
           is Double,
           is String,
           is UIColor:
        storedCurrentValue = newValue
        value.store(key: tweakIdentifier)
      default:
        assert(false, "This is not a valid tweak default value. Use Bool, Int, Float, Double, String, UIColor")
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
