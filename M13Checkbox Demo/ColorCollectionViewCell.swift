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
        tintColorButton?.removeTarget(nil, action: nil, for: .allEvents)
        secondaryTintColorButton?.removeTarget(nil, action: nil, for: .allEvents)
        secondaryCheckTintColorButton?.removeTarget(nil, action: nil, for: .allEvents)
        backgroundColorButton?.removeTarget(nil, action: nil, for: .allEvents)
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
    
    fileprivate func sharedSetup() {
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = min(bounds.size.width, bounds.size.height) / 2.0
    }
    
}
