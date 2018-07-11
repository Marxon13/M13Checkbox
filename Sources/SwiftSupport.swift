//
//  Created by David Jennes on 7/10/18.
//  Copyright © 2018 M13Checkbox. All rights reserved.
//

import UIKit

/// Swift < 4.2 support
#if !(swift(>=4.2))
enum CAMediaTimingFillMode {
    static let backwards = kCAFillModeBackwards
    static let forwards = kCAFillModeForwards
}

enum CAMediaTimingFunctionName {
    static let linear = kCAMediaTimingFunctionLinear
    static let easeIn = kCAMediaTimingFunctionEaseIn
    static let easeOut = kCAMediaTimingFunctionEaseOut
    static let easeInEaseOut = kCAMediaTimingFunctionEaseInEaseOut
}

enum CAShapeLayerLineCap {
    static let round = kCALineCapRound
}

enum CAShapeLayerLineJoin {
    static let round = kCALineJoinRound
}
#endif
