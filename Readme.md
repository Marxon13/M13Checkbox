<br>
![Banner](Resources/Banner.png)
<br>
Create beautiful, customizable, extendable, animated checkboxes on iOS. Completely configurable through interface builder. See the demo app to play with all the features.

Table of Contents
-----------------


<br>

Documentation
-------------

Check out the demo app to change the properties of the checkbox and see the changes in real time.

### Animations

- **Animation `enum`:** The possible animations for switching to and from the unchecked state.
    - **Stroke:**
    - **Fill:**
    - **Bounce (Stroke):**
    - **Bounce (Fill):**
    - **Expand (Stroke):**
    - **Expand (Fill):**
    - **Flat (Stroke):**
    - **Flat (Fill):**
    - **Spiral:**
    - **Fade (Stroke):**
    - **Fade (Fill):**
    - **Dot (Stroke):**
    - **Dot (Fill):**
- **stateChangeAnimation `Animation`:** The type of animation to preform when changing from the unchecked state to any other state.
- **animationDuration `NSTimeInterval`:** The duration of the animation that occurs when the checkbox switches states. The default is 0.3 seconds.

### Values
    
- **value `(Any)`:** Returns either the `checkedValue`, `uncheckedValue`, or `mixedValue` depending on the checkbox's state.
- **checkedValue `Any`:** The object to return from `value` when the checkbox is checked.
- **uncheckedValue `Any`:** The object to return from `value` when the checkbox is unchecked.
- **mixedValue `Any`:** The object to return from `value` when the checkbox is mixed.

### State

- **CheckState `enum`:** The possible states the check can be in.
    - **Unchecked:** No check is shown.
    - **Checked:** A checkmark is shown.
    - **Mixed:** A dash is shown.
- **checkState `CheckState`:** The current state of the checkbox.
- **setCheckState(newState: `CheckState`, animated: `Bool`):** Change the check state with the option of animating the change.
- **toggleCheckState(animated: `Bool` = false):** Toggle the check state between `Unchecked` and `Checked` states.

### Appearance

- **MarkType:** The possible shapes of the mark.
    - **Checkmark:** The mark is a standard checkmark.
    - **Radio:** The mark is a radio style fill.
- **BoxType:** The possible shapes of the box.
    - **Circle:** The box is a circle.
    - **Square:** The box is square with optional rounded corners.
- **tintColor:** The main color of the `Selected` and `Mixed` states for certain animations. 
- **secondaryTintColor `UIColor`:** The color of the box in the unselected state.
- **secondaryCheckmarkTintColor `UIColor`:** The color of the checkmark or radio for certain animations. (Mostly animations with a fill style.)
- **checkmarkLineWidth `CGFloat`:** The line width of the checkmark.
- **markType `MarkType`:** The type of mark to display.
- **boxLineWidth `CGFloat`:** The line width of the box.
- **cornerRadius `CGFloat`:** The corner radius of the box if the box type is `Square`.
- **boxType `BoxType`:** The shape of the checkbox.
- **hideBox `Bool`:** Wether or not to hide the box.


<br>

Getting Started
---------------

### Installation

The easiest way to install M13Checkbox is through CocoaPods. Simplify add the following to your podfile.

```
pod 'M13Checkbox'
```

Another option is to copy the files in the "Sources" folder to your project.

### Use

#### Storyboard

Add a custom view to the storyboard and set its class to "M13Checkbox". Customize the available parameters in the attributes inspector as needed.

**Note:** A shim was added to add support for setting enum properties through interface builder. Just retrieve the integer value corresponding to the enum value needed, and enter that into the property in the attributes inspector.

#### Programmatically 

Just initialize the checkbox like one would initialize a UIView, and add it as a subview to your view hierarchy. 

```
let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
view.addSubview(checkbox)
```

<br>

Project Details
---------------

### Requirements

- Requires iOS 9 or later.
- Requires Swift 2.2

### Support

Open an issue or shoot me an email. Check out previous issues to see if your's has already been solved. (I would prefer an issue over an email. But will still happily respond to an email.)

### License

***Under the MIT License***

>Copyright (c) 2016 Brandon McQuilkin
>                    
>Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
                    
>The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
                    
>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.





