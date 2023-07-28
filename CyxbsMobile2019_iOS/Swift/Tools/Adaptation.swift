//
//  Adaptation.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/27.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

// 获取状态栏高度
let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
// 获取屏幕宽度和高度
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
//获取触控条高度
let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom

func isIPhoneX() -> Bool {
    if UIDevice.current.userInterfaceIdiom == .phone {
        if UIScreen.main.bounds.size.height == 812 || UIScreen.main.bounds.size.height == 896 {
            return true
        }
    }
    return false
}

