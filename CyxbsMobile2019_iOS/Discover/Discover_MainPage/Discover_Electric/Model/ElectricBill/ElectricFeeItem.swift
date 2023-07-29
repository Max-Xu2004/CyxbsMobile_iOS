//
//  ElectricFeeItem.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/29.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

class ElectricFeeItem {
    var money: String?
    var consume: String?
    var time: String?
    var buildAndRoom: String?

    init(dict: [String: Any]) {
        if let elecInf = dict["elec_inf"] as? [String: Any], let elecCostArray = elecInf["elec_cost"] as? [String], elecCostArray.count >= 2 {
            self.money = "\(elecCostArray[0]).\(elecCostArray[1])"
            self.buildAndRoom = elecInf["room"] as? String
            self.consume = elecInf["elec_spend"] as? String
            
            if let returnTime = elecInf["record_time"] as? String, !returnTime.isEmpty {
                let month = Int(returnTime.prefix(2)) ?? 0
                let day = Int(returnTime.suffix(2)) ?? 0
                self.time = "\(month).\(day)"
            }
        } else {
            self.money = "0"
            self.buildAndRoom = nil
            self.consume = nil
            self.time = nil
        }
    }
}

