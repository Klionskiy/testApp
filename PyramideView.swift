//
//  PyramideView.swift
//  TestApp
//
//  Created by Gosha K on 09.05.17.
//  Copyright © 2017 Gosha K. All rights reserved.
//

import UIKit

class PyramideView: UIView {
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
