//
//  ViewController.swift
//  DDHTweaksDemo
//
//  Created by dasdom on 24.01.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var button: UIButton!
  
  override func viewDidLoad() {
    20.tweak("Main View", collection: "Text", name: "Size", min: 10, max: 40) { tweak in
      self.label.font = UIFont.systemFont(ofSize: CGFloat(tweak.currentValue!))
    }
//    DDHTweak.value(category: "Main View", collection: "Text", name: "Size", defaultValue: 20, min: 10, max: 40) { tweak in
//      self.label.font = UIFont.systemFontOfSize(CGFloat(tweak.currentValue!))
//    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let textColor = UIColor.black.tweak("Main View", collection: "Text", name: "Color")
    label.textColor = textColor
    
    let backgroundColor = UIColor.white.tweak("Main View", collection: "Background", name: "Color")
    view.backgroundColor = backgroundColor
    
    let text = "Hello".tweak("Main View", collection: "Text", name: "Text")
    label.text = text
    
    let showButton = false.tweak("Main View", collection: "Button", name: "Show")
    button.isHidden = !showButton
  }
}
