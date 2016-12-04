//  Created by dasdom on 04/12/2016.
//  Copyright © 2016 Dominik Hauser. All rights reserved.
//

import UIKit
import DDHTweaks

class LoginViewController: UIViewController {

  @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var labelUsernameConstraint: NSLayoutConstraint!
  @IBOutlet weak var usernamePasswordConstraint: NSLayoutConstraint!
  @IBOutlet weak var passwordButtonConstraint: NSLayoutConstraint!
  
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    setup()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    labelTopConstraint.constant = 30
    let duration = 0.5.tweak("Animation/Duration", min: 0, max: 5)
    let delay = 0.1.tweak("Animation/Delay", min: 0, max: 1)
    let damping = CGFloat(0.6.tweak("Animation/Damping", min: 0, max: 1))
    let springVelocity = CGFloat(0.0.tweak("Animation/Spring Velocity", min: 0, max: 10))
    UIView.animate(withDuration: duration,
                   delay: 0.0,
                   usingSpringWithDamping: damping,
                   initialSpringVelocity: springVelocity,
                   options: [],
                   animations: {
                    
                    self.view.layoutIfNeeded()
    }, completion:nil)
    labelUsernameConstraint.constant = 8
    UIView.animate(withDuration: duration,
                   delay: delay,
                   usingSpringWithDamping: damping,
                   initialSpringVelocity: springVelocity,
                   options: [],
                   animations: {
                    
                    self.view.layoutIfNeeded()
    }, completion: nil);
    usernamePasswordConstraint.constant = 8
    UIView.animate(withDuration: duration,
                   delay: delay*2,
                   usingSpringWithDamping: damping,
                   initialSpringVelocity: springVelocity,
                   options: [],
                   animations: {
                    
                    self.view.layoutIfNeeded()
    }, completion: nil);
    passwordButtonConstraint.constant = 8
    UIView.animate(withDuration: duration,
                   delay: delay*3,
                   usingSpringWithDamping: damping,
                   initialSpringVelocity: springVelocity,
                   options: [],
                   animations: {
                    
                    self.view.layoutIfNeeded()
    }, completion: nil);
  }
}

// MARK: Private methods
extension LoginViewController {
  fileprivate func setup() {
    labelTopConstraint.constant = -40
    labelUsernameConstraint.constant = -40
    usernamePasswordConstraint.constant = -40
    passwordButtonConstraint.constant = -40
  }
}
