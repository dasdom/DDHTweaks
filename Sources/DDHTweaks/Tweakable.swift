//  Created by dasdom on 24.01.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import Foundation
import UIKit

public protocol Tweakable {
  func isValid(min: Self?, max: Self?) -> Bool
  func store(key: String)
}

public extension Tweakable {
  func isValid(min: Self?, max: Self?) -> Bool {
    return true
  }
  
  func store(key: String) {
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
