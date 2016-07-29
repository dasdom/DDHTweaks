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
    DDHTweak.value(category: "Main View", collection: "Text", name: "Size", defaultValue: 20, min: 10, max: 40) { tweak in
      self.label.font = UIFont.systemFontOfSize(CGFloat(tweak.currentValue!))
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    let textColor = UIColor.blackColor().tweak("Main View", collection: "Text", name: "Color")
    label.textColor = textColor
    
    let backgroundColor = UIColor.whiteColor().tweak("Main View", collection: "Background", name: "Color")
    view.backgroundColor = backgroundColor
    
    let text = "Hello".tweak("Main View", collection: "Text", name: "Text")
    label.text = text
    
    let showButton = false.tweak("Main View", collection: "Button", name: "Show")
    button.hidden = !showButton
  }
}