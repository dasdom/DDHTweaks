//  Created by dasdom on 09.02.20.
//  
//

import UIKit

class ColorTableViewCell: UITableViewCell {
  
  let nameLabel: UILabel
  let textField: UITextField
  let colorView: UIView
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    nameLabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
    }()
    
    textField = {
      let textField = UITextField()
      textField.translatesAutoresizingMaskIntoConstraints = false
      textField.textAlignment = .right
      return textField
    }()
    
    colorView = {
      let colorView = UIView()
      colorView.translatesAutoresizingMaskIntoConstraints = false
      return colorView
    }()
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none

    contentView.addSubview(nameLabel)
    contentView.addSubview(textField)
    contentView.addSubview(colorView)
    
    let views = ["nameLabel" : nameLabel, "textField" : textField, "colorView" : colorView]
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-10-[nameLabel]-(>=5)-[colorView(30)]-5-[textField(70)]-10-|", options: .alignAllCenterY, metrics: nil, views: views))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel]|", options: .alignAllCenterY, metrics: nil, views: views))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[colorView(30)]", options: .alignAllCenterY, metrics: nil, views: views))
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
