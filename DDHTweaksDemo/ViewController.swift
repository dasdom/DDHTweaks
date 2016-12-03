//
//  ViewController.swift
//  DDHTweaksDemo
//
//  Created by dasdom on 24.01.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import UIKit
import DDHTweaks

class ViewController: UIViewController {

  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var button: UIButton!
  
  override func viewDidLoad() {
    20.tweak("Text/Size", min: 10, max: 40) { tweak in
      print(tweak)
      self.label.font = UIFont.systemFont(ofSize: CGFloat(tweak.currentValue!))
    }
//    DDHTweak.value(category: "Main View", collection: "Text", name: "Size", defaultValue: 20, min: 10, max: 40) { tweak in
//      self.label.font = UIFont.systemFontOfSize(CGFloat(tweak.currentValue!))
//    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    label.textColor = UIColor.black.tweak("Text/Color")
    
    view.backgroundColor = UIColor.white.tweak("Background/Color")
    
    label.text = "Hello".tweak("Text/Text")
    
    button.isHidden = !false.tweak("Button/Show")
  }
}
