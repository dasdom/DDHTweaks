//  Created by dasdom on 09.02.20.
//  
//

import Foundation

//MARK: - Store
private let _TweakStoreSharedInstance = TweakStore(name: "DefaultTweakStore")

/**
 This class is a singleton and it's responsible for storing the tweak categories.
 */
open class TweakStore {
  class var shared: TweakStore {
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
    return categories.sorted { $0.name < $1.name }
  }
  
  func addCategory(_ category: TweakCategory) {
    namedCategories[category.name] = category
  }
  
  func categoryWithName(_ name: String) -> TweakCategory? {
    return namedCategories[name]
  }
}
