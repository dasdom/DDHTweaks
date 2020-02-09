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
    let sortedIdentifiers = identifierTweaks.keys.sorted()
    for identifier in sortedIdentifiers {
      if let tweak = identifierTweaks[identifier] {
        tweaks.append(tweak)
      }
    }
    return tweaks
  }
  
  func addTweak<T>(_ tweak: Tweak<T>) {
    identifierTweaks[tweak.tweakIdentifier] = tweak
  }
  
  func removeTweak<T>(_ tweak: Tweak<T>) {
    tweak.remove()
    identifierTweaks.removeValue(forKey: tweak.tweakIdentifier)
  }
  
  func tweakWithIdentifier(_ identifier: String) -> AnyObject? {
    return identifierTweaks[identifier]
  }
}
