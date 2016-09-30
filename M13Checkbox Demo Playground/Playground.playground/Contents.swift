//: Playground - noun: a place where people can play

import M13Checkbox
import PlaygroundSupport

//: Creating A Checkbox
//: -------------------

let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 250.0, height: 250.0))

//: Managing States
//: ---------------

// Update the state of the checkbox programatically, with or without animation.
checkbox.setCheckState(.checked, animated: false)
checkbox.setCheckState(.unchecked, animated: false)

// Or toggle the state
checkbox.toggleCheckState(false)

// Set values to the checkbox to return depending on its state.
checkbox.checkedValue = 1.0
checkbox.uncheckedValue = 0.0
checkbox.mixedValue = 0.5

print("Checkbox Value: \(checkbox.value)")

//: Animations
//: ----------

// Update the animation duration
checkbox.animationDuration = 1.0

// Change the animation used when switching between states.
checkbox.stateChangeAnimation = .bounce(.fill)

//: Appearance
//: ----------

// The background color of the veiw.
checkbox.backgroundColor = .white
// The tint color when in the selected state.
checkbox.tintColor = .yellow
// The tint color when in the unselected state.
checkbox.secondaryTintColor = .green
// The color of the checkmark when the animation is a "fill" style animation.
checkbox.secondaryCheckmarkTintColor = .red

// Whether or not to display a checkmark, or radio mark.
checkbox.markType = .checkmark
// The line width of the checkmark.
checkbox.checkmarkLineWidth = 2.0

// The line width of the box.
checkbox.boxLineWidth = 2.0
// The corner radius of the box if it is a square.
checkbox.cornerRadius = 4.0
// Whether the box is a square, or circle.
checkbox.boxType = .circle
// Whether or not to hide the box.
checkbox.hideBox = false

PlaygroundPage.current.liveView = checkbox
