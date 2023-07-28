//
//  ArabicToChineseNumber.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

func arabicToChineseNumber(_ number: Int) -> String {
    let chineseNumbers = ["零", "一", "二", "三", "四", "五", "六", "七", "八", "九"]
    let chineseUnits = ["", "十", "百", "千", "万", "十", "百", "千", "亿", "十", "百", "千", "万", "十", "百", "千", "亿", "十", "百", "千"]
    
    var result = ""
    var n = number
    var position = 0
    
    while n > 0 {
        let digit = n % 10
        if digit != 0 || result.isEmpty || result.first != "零" {
            let digitChinese = chineseNumbers[digit]
            let unitChinese = chineseUnits[position]
            result = digitChinese + unitChinese + result
        }
        n /= 10
        position += 1
    }
    
    return result
}


