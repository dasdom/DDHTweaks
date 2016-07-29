# DDHTweaks
Tweak UI elements at runtime to find the perfect values

![](https://raw.githubusercontent.com/dasdom/DDHTweaks/master/DDHTweaksDemo/what.gif)

What is it?
-----------

Tweaks lets you make changes to your iOS app while it is running. This is especially useful if you are not sure about the right font size, colors or if you want to hide certain functionallities from some of your testers.

Installation
------------

Add **DDHTweaks.swift** and **DDHTweakUserInterface.swift** to your project.

Usage
-----

Tweak the font size of a label

```swift
DDHTweak.value(category: "Main View", collection: "Text", name: "Size", defaultValue: 20, min: 10, max: 40) { tweak in
  self.label.font = UIFont.systemFontOfSize(CGFloat(tweak.currentValue!))
}
```

Build and run the App. In the Simulator go to **Hardware/Shake Gesture**. Navigate to **Main View** and change the font size. Touch **Done**.

If you add an action to a tweak this is run when ever the value is changed.

Supported types for tweaks
--------------------------

1. Float
2. Double
3. Bool
4. String
5. UIColor

Other examples
--------------

Tweaks without an action have to be run to update the value. This means these tweaks have to be defined in `viewWillAppear()` or `viewDidAppear()`.

```swift
let textColor = Tweak.valueForCategory("Main View", collectionName: "Text", name: "Color", defaultValue: UIColor.blackColor())
label.textColor = textColor
        
let backgroundColor = Tweak.valueForCategory("Main View", collectionName: "Background", name: "Color", defaultValue: UIColor.whiteColor())
view.backgroundColor = backgroundColor
        
let text = Tweak.valueForCategory("Main View", collectionName: "Text", name: "Text", defaultValue: "Hello")
label.text = text

```
## Author

Dominik Hauser

[App.net: @dasdom](https://alpha.app.net/dasdom)

[Twitter: @dasdom](https://twitter.com/dasdom)

[swiftandpainless.com](http://swiftandpainless.com)

## Thanks

Thanks to facebook for the Objective-C version of Tweaks that I used as inspiration.

Licence
-------

MIT Licence. See the LICENCE file for details.
