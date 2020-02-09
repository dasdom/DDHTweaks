//  Created by dasdom on 09.02.20.
//  
//

import UIKit

public class ShakeableWindow: UIWindow {
  
  var isShaking = false
  
  override public func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == UIEvent.EventSubtype.motionShake {
      isShaking = true
      let sec = 0.4 * Float(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(sec)) / Double(NSEC_PER_SEC), execute: {
        if self.shouldPresentTweaksController() {
          self.presentTweaks()
        }
      })
    }
  }
  
  override public func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    isShaking = false
  }
  
  func shouldPresentTweaksController() -> Bool {
    #if targetEnvironment(simulator)
      return true
    #else
      return self.isShaking && UIApplication.shared.applicationState == .active
    #endif
  }
  
  func presentTweaks() {
    let visibleViewController = self.visibleViewController
//    while let presentingViewController = visibleViewController?.presentingViewController {
//      visibleViewController = presentingViewController
//    }
    
    if (visibleViewController is CategoriesTableViewController) == false {
      let navigationController = UINavigationController(rootViewController: CategoriesTableViewController())
      navigationController.modalPresentationStyle = .fullScreen
      visibleViewController?.present(navigationController, animated: true, completion: nil)
    }
  }
}

//http://stackoverflow.com/a/21848247/498796
public extension UIWindow {
  var visibleViewController: UIViewController? {
    return UIWindow.getVisibleViewController(from: self.rootViewController)
  }
  
  static func getVisibleViewController(from viewController: UIViewController?) -> UIViewController? {
    if let navigationController = viewController as? UINavigationController {
      return UIWindow.getVisibleViewController(from: navigationController.visibleViewController)
    } else if let tabBarController = viewController as? UITabBarController {
      return UIWindow.getVisibleViewController(from: tabBarController.selectedViewController)
    } else {
      if let presentedViewController = viewController?.presentedViewController {
        return UIWindow.getVisibleViewController(from: presentedViewController)
      } else {
        return viewController
      }
    }
  }
}

