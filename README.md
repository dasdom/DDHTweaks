![](https://img.shields.io/badge/licence-MIT-blue.svg)

# DDHTweaks

Tweak UI elements at runtime to find the perfect values.



## What is it?

Tweaks lets you make changes to your iOS app while it is running. This is especially useful if you are not sure about the right font size, colors or if you want to hide certain functionallities from some of your testers.

## Installation

### SPM

Add the `DDHTweaks` package.

## Usage

Set the window in AppDelegate:

```swift
var window: UIWindow? = ShakeableWindow(frame: UIScreen.main.bounds)
```

The tweaks from the gif above are created like this:

```swift
override func viewDidLoad() {
  20.tweak("Text/Size", min: 10, max: 40) { tweak in
    print(tweak)
    self.label.font = UIFont.systemFont(ofSize: CGFloat(tweak.currentValue!))
  }
}

override func viewWillAppear(_ animated: Bool) {
  super.viewWillAppear(animated)
  
  label.textColor = UIColor.black.tweak("Text/Color")
  
  view.backgroundColor = UIColor.white.tweak("Background/Color")
  
  label.text = "Hello".tweak("Text/Text")
  
  button.isHidden = !false.tweak("Button/Show")
}
```

Build and run the App. In the Simulator go to **Hardware/Shake Gesture**.

If you add an action to a tweak this is run when ever the value is changed.

## Supported types for tweaks

1. Float
2. Double
3. Bool
4. String
5. UIColor

## Author

Dominik Hauser

[Twitter: @dasdom](https://twitter.com/dasdom)

## Thanks

Thanks to facebook for the Objective-C version of Tweaks that I used as inspiration.

## Licence

MIT Licence. See the LICENCE file for details.
