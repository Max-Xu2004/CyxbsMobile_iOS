//
//  UFieldActivityHUD.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/24.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import Alamofire

class UFieldActivityHUD: NSObject {
    static let shared = UFieldActivityHUD()
    
    func addProgressHUDView(width: CGFloat, height: CGFloat, text: String, font: UIFont, textColor: UIColor, delay: CGFloat?, view: UIView, backGroundColor: UIColor, cornerRadius: CGFloat, yOffset: Float) {
        let customView = UIView(frame: CGRectMake(0, 0, width, height))
        customView.backgroundColor = backGroundColor
        customView.layer.cornerRadius = cornerRadius
        let label = UILabel()
        label.textAlignment = .center
        label.font = font
        label.text = text
        label.textColor = textColor
        customView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.color = .clear
        hud?.mode = .customView
        hud?.customView = customView
        hud?.yOffset = yOffset
        hud?.hide(true, afterDelay: delay ?? 2)
    }
}
