//: Playground - noun: a place where people can play

import M13Checkbox
import PlaygroundSupport

let checkbox = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 250.0, height: 250.0))
checkbox.backgroundColor = .white
checkbox.tintColor = .yellow
checkbox.secondaryTintColor = .green
checkbox.secondaryCheckmarkTintColor = .red
checkbox.checkmarkLineWidth = 2.0
checkbox.stateChangeAnimation = .bounce(.fill)

PlaygroundPage.current.liveView = checkbox