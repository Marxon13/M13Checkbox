//
//  ColorCollectionViewCell.swift
//  M13Checkbox
//
//  Created by McQuilkin, Brandon on 3/9/16.
//  Copyright © 2016 Brandon McQuilkin. All rights reserved.
//

import UIKit

class ColorCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var tintColorButton: UIButton?
    @IBOutlet weak var secondaryTintColorButton: UIButton?
    @IBOutlet weak var secondaryCheckTintColorButton: UIButton?
    @IBOutlet weak var backgroundColorButton: UIButton?
    
    
    override func prepareForReuse() {
        tintColorButton?.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        secondaryTintColorButton?.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        secondaryCheckTintColorButton?.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        backgroundColorButton?.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
    }
    
}

class ColorButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedSetup()
    }
    
    private func sharedSetup() {
        layer.borderColor = UIColor.whiteColor().CGColor
        layer.borderWidth = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.size.width, bounds.size.height) / 2.0
    }
    
}