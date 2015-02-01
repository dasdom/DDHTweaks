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
    
    let textColor = DDHTweak.value(category: "Main View", collection: "Text", name: "Color", defaultValue: UIColor.blackColor())
    label.textColor = textColor
    
    let backgroundColor = DDHTweak.value(category: "Main View", collection: "Background", name: "Color", defaultValue: UIColor.whiteColor())
    view.backgroundColor = backgroundColor
    
    let text = DDHTweak.value(category: "Main View", collection: "Text", name: "Text", defaultValue: "Hello")
    label.text = text
    
    let showButton = DDHTweak.value(category: "Main View", collection: "Button", name: "Show", defaultValue: false)
    button.hidden = !showButton
  }
}

