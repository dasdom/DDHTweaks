//  Created by dasdom on 09.02.20.
//  
//

import UIKit

class CategoriesTableViewController: UITableViewController {
  
  var categories = [TweakCategory]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let store = TweakStore.shared
    categories = store.allCategories()
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Category")
    
    self.title = "Tweaks"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(CategoriesTableViewController.done))
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.action, target: self, action: #selector(send))
    
  }
  
  // MARK: - Table view data source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
    
    let category = categories[indexPath.row]
    cell.textLabel?.text = category.name
    
    return cell
  }
  
  // MARK: - UITableViewDelegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let category = categories[indexPath.row]
    let colletionsTableViewController = CollectionsTableViewController(collections: category.allCollections())
    colletionsTableViewController.title = category.name
    navigationController?.pushViewController(colletionsTableViewController, animated: true)
  }
  
  @objc func done() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc func send() {
    
    var messageBody = "Tweak values:\n"
    for category in categories {
      for collection in category.allCollections() {
        for tweak in collection.allTweaks() {
          switch tweak {
          case let tweak as Tweak<Bool>:
            messageBody += "\(tweak.tweakIdentifier): \(tweak.currentValue!)\n"
          case let tweak as Tweak<Int>:
            messageBody += "\(tweak.tweakIdentifier): \(tweak.currentValue!)\n"
          case let tweak as Tweak<Float>:
            messageBody += "\(tweak.tweakIdentifier): \(tweak.currentValue!)\n"
          case let tweak as Tweak<CGFloat>:
            messageBody += "\(tweak.tweakIdentifier): \(tweak.currentValue!)\n"
          case let tweak as Tweak<Double>:
            messageBody += "\(tweak.tweakIdentifier): \(tweak.currentValue!)\n"
          case let tweak as Tweak<String>:
            messageBody += "\(tweak.tweakIdentifier): \(tweak.currentValue!)\n"
          case let tweak as Tweak<UIColor>:
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
    
//    let mailController = MFMailComposeViewController()
//    mailController.setSubject("Tweaks")
//    mailController.setMessageBody(messageBody, isHTML: false)
//
//    present(mailController, animated: true, completion: nil)
    
    let activity = UIActivityViewController(activityItems: [messageBody], applicationActivities: nil)
    present(activity, animated: true, completion: nil)
  }
}
