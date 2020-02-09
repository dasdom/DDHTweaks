//  Created by dasdom on 09.02.20.
//  
//

import Foundation

class TweakCollection {
  let name: String
  
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
