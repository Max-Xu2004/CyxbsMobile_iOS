//
//  UIColor+DM.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import UIKit
//浅（深）色模式颜色适配
extension UIColor {
    static func dm_color(withLightColor lightColor: UIColor, darkColor: UIColor, alpha: CGFloat) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traitCollection) -> UIColor in
                return traitCollection.userInterfaceStyle == .dark ? darkColor.withAlphaComponent(alpha) : lightColor.withAlphaComponent(alpha)
            }
        } else {
            return lightColor.withAlphaComponent(alpha)
        }
    }
}
