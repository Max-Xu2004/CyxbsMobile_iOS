//
//  GradientButton.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/9/3.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class GradientButton: UIButton {
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupGradient()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    func setupGradient() {
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [
            UIColor(red: 0.282, green: 0.255, blue: 0.886, alpha: 1).cgColor,
            UIColor(red: 0.365, green: 0.365, blue: 0.969, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        // 圆角半径，根据需要自行调整
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}

