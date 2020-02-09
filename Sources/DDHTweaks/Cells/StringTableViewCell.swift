//  Created by dasdom on 09.02.20.
//  
//

import UIKit

class StringTableViewCell: UITableViewCell {
  
  let nameLabel: UILabel
  let textField: UITextField
  
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
    
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    selectionStyle = .none

    contentView.addSubview(nameLabel)
    contentView.addSubview(textField)
    
    let views = ["nameLabel" : nameLabel, "textField" : textField] as [String : Any]
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-10-[nameLabel]-(>=5)-[textField(150)]-10-|", options: .alignAllCenterY, metrics: nil, views: views))
    contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[nameLabel]|", options: .alignAllCenterY, metrics: nil, views: views))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
