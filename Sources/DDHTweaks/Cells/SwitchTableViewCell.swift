//  Created by dasdom on 09.02.20.
//  
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
  
  let nameLabel: UILabel
  let valueSwitch: UISwitch
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
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
    
    selectionStyle = .none

    contentView.addSubview(nameLabel)
    contentView.addSubview(valueSwitch)
    
    let views = ["nameLabel" : nameLabel, "valueSwitch" : valueSwitch] as [String : Any]
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-10-[nameLabel]-5-[valueSwitch]-10-|", options: .alignAllCenterY, metrics: nil, views: views))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel]|", options: [], metrics: nil, views: views))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
