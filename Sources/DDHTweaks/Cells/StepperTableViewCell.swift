//  Created by dasdom on 09.02.20.
//  
//

import UIKit

class StepperTableViewCell: UITableViewCell {
  
  let nameLabel: UILabel
  let valueLabel: UILabel
  let stepper: UIStepper
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
    
    selectionStyle = .none
    
    contentView.addSubview(nameLabel)
    contentView.addSubview(valueLabel)
    contentView.addSubview(stepper)
    
    let views = ["nameLabel" : nameLabel, "valueLabel" : valueLabel, "stepper" : stepper] as [String : Any]
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-10-[nameLabel]-5-[valueLabel]-5-[stepper]-10-|", options:  NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: views))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel(valueLabel)]|", options: [], metrics: nil, views: views))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
