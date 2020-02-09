//  Created by dasdom on 09.02.20.
//  
//

import Foundation

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
    return collections.sorted { $0.name < $1.name }
  }
  
  func addCollection(_ collection: TweakCollection) {
    namedCollection[collection.name] = collection
  }
  
  func collectionWithName(_ name: String) -> TweakCollection? {
    return namedCollection[name]
  }
}
