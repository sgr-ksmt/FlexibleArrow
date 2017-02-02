//
//  FlexibleArrowAnimation.swift
//  FlexibleArrow
//
//  Created by Suguru Kishimoto on 2/2/17.
//  Copyright © 2017 Suguru Kishimoto. All rights reserved.
//

import Foundation

public class FlexibleArrowAnimation: NSObject {
    let duration: Double
    let timingFunction: CAMediaTimingFunction?
    
    init(duration: Double, timingFunction: CAMediaTimingFunction?) {
        self.duration = duration
        self.timingFunction = timingFunction
    }
    
    @objc(defaultAnimation)
    static var `default`: FlexibleArrowAnimation {
        return FlexibleArrowAnimation(duration: 0.35, timingFunction: nil)
    }
}
