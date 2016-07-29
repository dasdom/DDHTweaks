//
//  DDHTweakUserInterface.swift
//  DDHTweaksDemo
//
//  Created by dasdom on 24.01.15.
//  Copyright (c) 2015 Dominik Hauser. All rights reserved.
//

import UIKit
import MessageUI

/* http://stackoverflow.com/a/30404532 */
extension String {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
                return from ..< to
        }
        return nil
    }
}

class ShakeableWindow: UIWindow {
  
  var isShaking = false
  
  override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
    if motion == UIEventSubtype.MotionShake {
      isShaking = true
      let sec = 0.4 * Float(NSEC_PER_SEC)
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(sec)), dispatch_get_main_queue(), {
        if self.shouldPresentTweaksController() {
          self.presentTweaks()
        }
      })
    }
  }
  
  override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
    isShaking = false
  }
  
  func shouldPresentTweaksController() -> Bool {
    #if (arch(i386) || arch(x86_64)) && os(iOS)
      return true
    #else
      return self.isShaking && UIApplication.sharedApplication().applicationState == .Active
    #endif
  }
  
  func presentTweaks() {
    var visibleViewController = self.rootViewController
    while let presentingViewController = visibleViewController?.presentingViewController {
      visibleViewController = presentingViewController
    }
    
    if (visibleViewController is CategoriesTableViewController) == false {
      visibleViewController?.presentViewController(UINavigationController(rootViewController: CategoriesTableViewController()), animated: true, completion: nil)
    }
  }
}

class CategoriesTableViewController: UITableViewController {
  
  var categories = [TweakCategory]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let store = TweakStore.sharedTweakStore
    categories = store.allCategories()
    
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Category")
    
    self.title = "Tweaks"
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(dismiss))
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: #selector(send))
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("Category", forIndexPath: indexPath)
    
    let category = categories[indexPath.row]
    cell.textLabel?.text = category.name
    
    return cell
  }
  
  // MARK: - UITableViewDelegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let category = categories[indexPath.row]
    let colletionsTableViewController = CollectionsTableViewController(collections: category.allCollections())
    colletionsTableViewController.title = category.name
    navigationController?.pushViewController(colletionsTableViewController, animated: true)
  }
  
  func dismiss() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  func send() {
    
    var messageBody = "Tweak values:\n"
    for category in categories {
      for collection in category.allCollections() {
        for tweak in collection.allTweaks() {
          switch tweak {
          case let tweak as DDHTweak<Bool>:
            messageBody += "\(tweak.tweakIdentifier): \(tweak.currentValue!)\n"
          case let tweak as DDHTweak<Int>:
            messageBody += "\(tweak.tweakIdentifier): \(tweak.currentValue!)\n"
          case let tweak as DDHTweak<Float>:
            messageBody += "\(tweak.tweakIdentifier): \(tweak.currentValue!)\n"
          case let tweak as DDHTweak<CGFloat>:
            messageBody += "\(tweak.tweakIdentifier): \(tweak.currentValue!)\n"
          case let tweak as DDHTweak<Double>:
            messageBody += "\(tweak.tweakIdentifier): \(tweak.currentValue!)\n"
          case let tweak as DDHTweak<String>:
            messageBody += "\(tweak.tweakIdentifier): \(tweak.currentValue!)\n"
          case let tweak as DDHTweak<UIColor>:
            messageBody += "\(tweak.tweakIdentifier): \(tweak.currentValue!.hexString())\n"
          default:
            print("")
          }
        }
        messageBody += "\n"
      }
      messageBody += "\n"
    }
    
    print("\(messageBody)")
    
    let mailController = MFMailComposeViewController()
    mailController.setSubject("Tweaks")
    mailController.setMessageBody(messageBody, isHTML: false)
    
    presentViewController(mailController, animated: true, completion: nil)
    
  }
}

class CollectionsTableViewController: UITableViewController, UITextFieldDelegate {
  
  let collections: [TweakCollection]
  
  init(collections: [TweakCollection]) {
    self.collections = collections
    super.init(nibName: nil, bundle: nil)
  }
  
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.registerClass(StepperTableViewCell.self, forCellReuseIdentifier: "StepperCell")
    tableView.registerClass(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchCell")
    tableView.registerClass(ColorTableViewCell.self, forCellReuseIdentifier: "ColorCell")
    tableView.registerClass(StringTableViewCell.self, forCellReuseIdentifier: "StringCell")
    tableView.rowHeight = 44
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: #selector(dismiss(_:)))
  }
  
  // MARK: - Table view data source
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return collections.count
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return collections[section].allTweaks().count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell: UITableViewCell?
    
    let tweak: AnyObject = collections[indexPath.section].allTweaks()[indexPath.row]
    print("tweak: \(tweak)")
    if let tweak = tweak as? DDHTweak<Int> {
      print("Tweak<Int>: currentValue \(tweak.currentValue)")
      let stepperCell = tableView.dequeueReusableCellWithIdentifier("StepperCell", forIndexPath: indexPath) as! StepperTableViewCell
      configStepperCell(stepperCell, tweak: tweak)
      stepperCell.stepper.value = Double(tweak.currentValue!)
      stepperCell.stepper.stepValue = 1
      cell = stepperCell
    } else if let tweak = tweak as? DDHTweak<Float> {
      print("Tweak<Float>: currentValue \(tweak.currentValue)")
      let stepperCell = tableView.dequeueReusableCellWithIdentifier("StepperCell", forIndexPath: indexPath) as! StepperTableViewCell
      configStepperCell(stepperCell, tweak: tweak)
      stepperCell.stepper.value = Double(tweak.currentValue!)
      stepperCell.stepper.stepValue = 0.01
      cell = stepperCell
      //        } else if let tweak = tweak as? Tweak<CGFloat> {
      //            println("tweak is CGFloat: \(tweak.currentValue)")
      //            configStepperCell(cell, tweak: tweak)
      //            cell.stepper.value = Double(tweak.currentValue!)
      //            cell.stepper.stepValue = 0.01
    } else if let tweak = tweak as? DDHTweak<Double> {
      print("Tweak<Double>: currentValue \(tweak.currentValue)")
      let stepperCell = tableView.dequeueReusableCellWithIdentifier("StepperCell", forIndexPath: indexPath) as! StepperTableViewCell
      configStepperCell(stepperCell, tweak: tweak)
      stepperCell.stepper.value = tweak.currentValue!
      stepperCell.stepper.stepValue = 0.01
      cell = stepperCell
    } else if let tweak = tweak as? DDHTweak<Bool> {
      print("Tweak<Bool>: currentValue \(tweak.currentValue)")
      let switchCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchTableViewCell
      switchCell.nameLabel.text = tweak.name
      switchCell.valueSwitch.on = tweak.currentValue!
      switchCell.valueSwitch.addTarget(self, action: #selector(changeBoolValue(_:)), forControlEvents: .ValueChanged)
      cell = switchCell
    } else if let tweak = tweak as? DDHTweak<UIColor> {
      print("Tweak<UIColor>: currentValue \(tweak.currentValue)")
      let colorCell = tableView.dequeueReusableCellWithIdentifier("ColorCell", forIndexPath: indexPath) as! ColorTableViewCell
      colorCell.nameLabel.text = tweak.name
      if let hexString = tweak.currentValue?.hexString() {
        colorCell.textField.text = hexString
        colorCell.colorView.backgroundColor = tweak.currentValue
      }
      colorCell.textField.tag = 100
      colorCell.textField.delegate = self
      cell = colorCell
    } else if let tweak = tweak as? DDHTweak<String> {
      print("Tweak<String>: currentValue \(tweak.currentValue)")
      let stringCell = tableView.dequeueReusableCellWithIdentifier("StringCell", forIndexPath: indexPath) as! StringTableViewCell
      stringCell.nameLabel.text = tweak.name
      if let string = tweak.currentValue {
        stringCell.textField.text = string
      }
      stringCell.textField.tag = 101
      stringCell.textField.delegate = self
      cell = stringCell
    } else {
      print("tweak is something else")
    }
    
    return cell!
  }
  
  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return collections[section].name
  }
  
  func configStepperCell<T>(cell: StepperTableViewCell, tweak: DDHTweak<T>) {
    cell.nameLabel.text = tweak.name
    cell.valueLabel.text = "\(tweak.currentValue!)"
    cell.stepper.addTarget(self, action: #selector(changeCurrentValue(_:)), forControlEvents: .ValueChanged)
  }
  
  func changeCurrentValue(sender: UIStepper) {
    if let indexPath = indexPathForCellSubView(sender) {
      let tweak: AnyObject = collections[indexPath.section].allTweaks()[indexPath.row]
      if let tweak = tweak as? DDHTweak<Int> {
        tweak.currentValue = Int(sender.value)
      } else if let tweak = tweak as? DDHTweak<Float> {
        tweak.currentValue = Float(sender.value)
        //            } else if let tweak = tweak as? Tweak<CGFloat> {
        //                tweak.currentValue = CGFloat(sender.value)
      } else if let tweak = tweak as? DDHTweak<Double> {
        tweak.currentValue = sender.value
      }
      tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
  }
  
  func changeBoolValue(sender: UISwitch) {
    if let indexPath = indexPathForCellSubView(sender) {
      let tweak: AnyObject = collections[indexPath.section].allTweaks()[indexPath.row]
      if let tweak = tweak as? DDHTweak<Bool> {
        tweak.currentValue = sender.on
      }
      //            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    switch textField.tag {
    case 100:
            if let range = textField.text?.rangeFromNSRange(range),
            hexString = textField.text?.stringByReplacingCharactersInRange(range, withString: string)
            where hexString.characters.count == 6 {
                
        let scanner = NSScanner(string: hexString)
        
        var value = UInt32()
        if scanner.scanHexInt(&value) {
          if let indexPath = indexPathForCellSubView(textField) {
            let tweak: AnyObject = collections[indexPath.section].allTweaks()[indexPath.row]
            if let tweak = tweak as? DDHTweak<UIColor> {
              tweak.currentValue = UIColor.colorFromHex(hexString as String)
            }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
          }
          //                textField.textColor = UIColor.greenColor()
        } else {
          //                textField.textColor = UIColor.redColor()
        }
      }

    case 101:
        if let range = textField.text?.rangeFromNSRange(range),
        theString = textField.text?.stringByReplacingCharactersInRange(range, withString: string),
        indexPath = indexPathForCellSubView(textField) {
        let tweak: AnyObject = collections[indexPath.section].allTweaks()[indexPath.row]
        if let tweak = tweak as? DDHTweak<String> {
          tweak.currentValue = theString as String
        }
      }
    default:
      break
    }
    return true
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    return false
  }
  
  func indexPathForCellSubView(view: UIView) -> NSIndexPath? {
    let convertedPoint = view.superview!.convertPoint(view.center, toView: tableView)
    let indexPath = tableView.indexPathForRowAtPoint(convertedPoint)
    print("indexPath \(indexPath)")
    return indexPath
  }
  
  func dismiss(sender: UIBarButtonItem) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
}

//MARK: - Table view cells
class StepperTableViewCell: UITableViewCell {
  
  let nameLabel: UILabel
  let valueLabel: UILabel
  let stepper: UIStepper
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    nameLabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    valueLabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    stepper = {
      let stepper = UIStepper()
      stepper.translatesAutoresizingMaskIntoConstraints = false
      return stepper
    }()
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(nameLabel)
    contentView.addSubview(valueLabel)
    contentView.addSubview(stepper)
    
    let views = ["nameLabel" : nameLabel, "valueLabel" : valueLabel, "stepper" : stepper]
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-10-[nameLabel]-5-[valueLabel]-5-[stepper]-10-|", options:  NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views))
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[nameLabel(valueLabel)]|", options: [], metrics: nil, views: views))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

class SwitchTableViewCell: UITableViewCell {
  
  let nameLabel: UILabel
  let valueSwitch: UISwitch
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    nameLabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    valueSwitch = {
      let valueSwitch = UISwitch()
      valueSwitch.translatesAutoresizingMaskIntoConstraints = false
      return valueSwitch
    }()
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(nameLabel)
    contentView.addSubview(valueSwitch)
    
    let views = ["nameLabel" : nameLabel, "valueSwitch" : valueSwitch]
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-10-[nameLabel]-5-[valueSwitch]-10-|", options: .AlignAllCenterY, metrics: nil, views: views))
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[nameLabel]|", options: [], metrics: nil, views: views))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

class ColorTableViewCell: UITableViewCell {
  
  let nameLabel: UILabel
  let textField: UITextField
  let colorView: UIView
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    nameLabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    textField = {
      let textField = UITextField()
      textField.translatesAutoresizingMaskIntoConstraints = false
      textField.textAlignment = .Right
      return textField
    }()
    
    colorView = {
      let colorView = UIView()
      colorView.translatesAutoresizingMaskIntoConstraints = false
      return colorView
    }()
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(nameLabel)
    contentView.addSubview(textField)
    contentView.addSubview(colorView)
    
    let views = ["nameLabel" : nameLabel, "textField" : textField, "colorView" : colorView]
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-10-[nameLabel]-(>=5)-[colorView(30)]-5-[textField(70)]-10-|", options: .AlignAllCenterY, metrics: nil, views: views))
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[nameLabel]|", options: .AlignAllCenterY, metrics: nil, views: views))
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[colorView(30)]", options: .AlignAllCenterY, metrics: nil, views: views))
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}

class StringTableViewCell: UITableViewCell {
  
  let nameLabel: UILabel
  let textField: UITextField
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    nameLabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    textField = {
      let textField = UITextField()
      textField.translatesAutoresizingMaskIntoConstraints = false
      textField.textAlignment = .Right
      return textField
    }()
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    contentView.addSubview(nameLabel)
    contentView.addSubview(textField)
    
    let views = ["nameLabel" : nameLabel, "textField" : textField]
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-10-[nameLabel]-(>=5)-[textField(150)]-10-|", options: .AlignAllCenterY, metrics: nil, views: views))
    contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[nameLabel]|", options: .AlignAllCenterY, metrics: nil, views: views))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
