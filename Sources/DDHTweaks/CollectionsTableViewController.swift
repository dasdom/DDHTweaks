//  Created by dasdom on 09.02.20.
//  
//

import UIKit

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
    
    tableView.register(StepperTableViewCell.self, forCellReuseIdentifier: "StepperCell")
    tableView.register(SwitchTableViewCell.self, forCellReuseIdentifier: "SwitchCell")
    tableView.register(ColorTableViewCell.self, forCellReuseIdentifier: "ColorCell")
    tableView.register(StringTableViewCell.self, forCellReuseIdentifier: "StringCell")
    tableView.rowHeight = 44
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(dismiss(_:)))
  }
  
  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return collections.count
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return collections[section].allTweaks().count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell: UITableViewCell?
    
    let tweak: AnyObject = collections[indexPath.section].allTweaks()[indexPath.row]
    print("tweak: \(tweak)")
    if let tweak = tweak as? Tweak<Int> {
        print("Tweak<Int>: currentValue \(String(describing: tweak.currentValue))")
      let stepperCell = tableView.dequeueReusableCell(withIdentifier: "StepperCell", for: indexPath) as! StepperTableViewCell
      configStepperCell(stepperCell, tweak: tweak)
      stepperCell.stepper.value = Double(tweak.currentValue!)
      stepperCell.stepper.stepValue = 1
      cell = stepperCell
    } else if let tweak = tweak as? Tweak<Float> {
        print("Tweak<Float>: currentValue \(String(describing: tweak.currentValue))")
      let stepperCell = tableView.dequeueReusableCell(withIdentifier: "StepperCell", for: indexPath) as! StepperTableViewCell
      configStepperCell(stepperCell, tweak: tweak)
      stepperCell.stepper.value = Double(tweak.currentValue!)
      stepperCell.stepper.stepValue = 0.01
      cell = stepperCell
      //        } else if let tweak = tweak as? Tweak<CGFloat> {
      //            println("tweak is CGFloat: \(tweak.currentValue)")
      //            configStepperCell(cell, tweak: tweak)
      //            cell.stepper.value = Double(tweak.currentValue!)
      //            cell.stepper.stepValue = 0.01
    } else if let tweak = tweak as? Tweak<Double> {
        print("Tweak<Double>: currentValue \(String(describing: tweak.currentValue))")
      let stepperCell = tableView.dequeueReusableCell(withIdentifier: "StepperCell", for: indexPath) as! StepperTableViewCell
      configStepperCell(stepperCell, tweak: tweak)
      stepperCell.stepper.value = tweak.currentValue!
      stepperCell.stepper.stepValue = 0.01
      cell = stepperCell
    } else if let tweak = tweak as? Tweak<Bool> {
        print("Tweak<Bool>: currentValue \(String(describing: tweak.currentValue))")
      let switchCell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchTableViewCell
      switchCell.nameLabel.text = tweak.name
      switchCell.valueSwitch.isOn = tweak.currentValue!
      switchCell.valueSwitch.addTarget(self, action: #selector(changeBoolValue(_:)), for: .valueChanged)
      cell = switchCell
    } else if let tweak = tweak as? Tweak<UIColor> {
        print("Tweak<UIColor>: currentValue \(String(describing: tweak.currentValue))")
      let colorCell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as! ColorTableViewCell
      colorCell.nameLabel.text = tweak.name
      if let hexString = tweak.currentValue?.hexString() {
        colorCell.textField.text = hexString
        colorCell.colorView.backgroundColor = tweak.currentValue
      }
      colorCell.textField.tag = 100
      colorCell.textField.delegate = self
      cell = colorCell
    } else if let tweak = tweak as? Tweak<String> {
        print("Tweak<String>: currentValue \(String(describing: tweak.currentValue))")
      let stringCell = tableView.dequeueReusableCell(withIdentifier: "StringCell", for: indexPath) as! StringTableViewCell
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
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return collections[section].name
  }
  
  func configStepperCell<T>(_ cell: StepperTableViewCell, tweak: Tweak<T>) {
    cell.nameLabel.text = tweak.name
    if let value = tweak.currentValue as? Float {
      cell.valueLabel.text = String(format: "%.2f", value)
    } else if let value = tweak.currentValue as? CGFloat {
      cell.valueLabel.text = String(format: "%.2f", value)
    } else if let value = tweak.currentValue as? Double {
      cell.valueLabel.text = String(format: "%.2lf", value)
    } else if let value = tweak.currentValue as? Int {
      cell.valueLabel.text = String(format: "%d", value)
    }
    cell.stepper.addTarget(self, action: #selector(changeCurrentValue(_:)), for: .valueChanged)
  }
  
  @objc func changeCurrentValue(_ sender: UIStepper) {
    if let indexPath = indexPathForCellSubView(sender) {
      let tweak: AnyObject = collections[indexPath.section].allTweaks()[indexPath.row]
      if let tweak = tweak as? Tweak<Int> {
        tweak.currentValue = Int(sender.value)
      } else if let tweak = tweak as? Tweak<Float> {
        tweak.currentValue = Float(sender.value)
        //            } else if let tweak = tweak as? Tweak<CGFloat> {
        //                tweak.currentValue = CGFloat(sender.value)
      } else if let tweak = tweak as? Tweak<Double> {
        tweak.currentValue = sender.value
      }
      tableView.reloadRows(at: [indexPath], with: .none)
    }
  }
  
  @objc func changeBoolValue(_ sender: UISwitch) {
    if let indexPath = indexPathForCellSubView(sender) {
      let tweak: AnyObject = collections[indexPath.section].allTweaks()[indexPath.row]
      if let tweak = tweak as? Tweak<Bool> {
        tweak.currentValue = sender.isOn
      }
      //            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
  }
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    switch textField.tag {
    case 100:
      if let range = textField.text?.range(from: range),
            let hexString = textField.text?.replacingCharacters(in: range, with: string), hexString.count == 6 {
                
        let scanner = Scanner(string: hexString)
        
        var value = UInt32()
        if scanner.scanHexInt32(&value) {
          if let indexPath = indexPathForCellSubView(textField) {
            let tweak: AnyObject = collections[indexPath.section].allTweaks()[indexPath.row]
            if let tweak = tweak as? Tweak<UIColor> {
              tweak.currentValue = UIColor.colorFromHex(hexString as String)
            }
            tableView.reloadRows(at: [indexPath], with: .none)
          }
          //                textField.textColor = UIColor.greenColor()
        } else {
          //                textField.textColor = UIColor.redColor()
        }
      }

    case 101:
      if let range = textField.text?.range(from: range),
        let theString = textField.text?.replacingCharacters(in: range, with: string),
        let indexPath = indexPathForCellSubView(textField) {
        let tweak: AnyObject = collections[indexPath.section].allTweaks()[indexPath.row]
        if let tweak = tweak as? Tweak<String> {
          tweak.currentValue = theString as String
        }
      }
    default:
      break
    }
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    return false
  }
  
  func indexPathForCellSubView(_ view: UIView) -> IndexPath? {
    let convertedPoint = view.superview!.convert(view.center, to: tableView)
    let indexPath = tableView.indexPathForRow(at: convertedPoint)
    print("indexPath \(String(describing: indexPath))")
    return indexPath
  }
  
  @objc func dismiss(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
  
}
