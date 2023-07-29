//
//  PickerDormitoryModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/29.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

class PickerDormitoryModel {
    var placeArray: [String] = []
    var siHaiPlace: [String] = []
    var ningJingPlace: [String] = []
    var mingLiPlace: [String] = []
    var xingYePlace: [String] = []
    var zhiXingPlace: [String] = []
    var allArray: [[String]] = []

    init() {
        self.placeArray = ["宁静苑", "明理苑", "知行苑", "兴业苑", "四海苑"]
        self.siHaiPlace = ["1舍", "2舍"]
        self.ningJingPlace = ["1舍", "2舍", "3舍", "4舍", "5舍", "6舍", "7舍", "8舍", "9舍", "10舍"]
        self.mingLiPlace = ["1舍", "2舍", "3舍", "4舍", "5舍", "6舍", "7舍", "8舍", "9舍"]
        self.zhiXingPlace = ["1舍", "2舍", "3舍", "4舍", "5舍", "6舍", "7舍", "8舍", "9舍"]
        self.xingYePlace = ["1舍", "2舍", "3舍", "4舍", "5舍", "6舍", "7舍", "8舍"]
        self.allArray = [self.ningJingPlace, self.mingLiPlace, self.zhiXingPlace, self.xingYePlace, self.siHaiPlace]
    }

    // 根据苑名字和几舍获取栋数字：例如参数1：知行苑，参数2：8舍，返回：16栋
    func getNumberOfDormitory(with building: String, and place: String) -> String {
        var num = Int(place.prefix(2)) ?? 0

        if num != 10 {
            num = Int(place.prefix(1)) ?? 0
        }

        if building == "宁静苑" {
            if num >= 1 && num <= 5 {
                num += 7
            } else if num == 10 {
                num = 40
            } else if num >= 6 {
                num += 26
            }
        } else if building == "明理苑" {
            if num >= 1 && num <= 8 {
                num += 23
            } else {
                num += 30
            }
        } else if building == "知行苑" {
            if num >= 1 && num <= 6 {
            } else {
                num += 8
            }
        } else if building == "兴业苑" {
            if num >= 1 && num <= 6 {
                num += 16
            } else if num == 7 {
                return "23A栋"
            } else if num == 8 {
                return "23B栋"
            }
        } else {
            num += 35
        }

        return String(format: "%2d栋", num)
    }

    // 根据几栋获得是什么宿舍，几舍。例如参数：24栋，返回：[1, 0] // 1是明理苑的索引，0是1舍的索引
    func getBuildingNameIndexAndBuildingNumberIndex(by dormitoryNumber: String) -> [Int] {
        if dormitoryNumber == "23A" {
            return [3, 6]
        } else if dormitoryNumber == "23B" {
            return [3, 7]
        }

        var num = Int(dormitoryNumber) ?? 0

        if num == 40 { // 宁静苑10舍
            return [0, 10]
        } else if num >= 1 && num <= 6 { // 知行苑1-6舍
            return [2, num - 1]
        } else if num >= 8 && num <= 12 { // 宁静苑1-5舍
            return [0, num - 8]
        } else if num >= 15 && num <= 16 { // 知行苑7，8舍
            return [2, num - 9]
        } else if num >= 17 && num <= 22 { // 兴业苑1-6舍
            return [3, num - 17]
        } else if num >= 24 && num <= 31 { // 明理苑1-8舍
            return [1, num - 24]
        } else if num >= 32 && num <= 35 { // 宁静苑6-9舍
            return [0, num - 27]
        } else if num >= 36 && num <= 37 { // 四海1-2舍
            return [4, num - 36]
        } else if num == 39 { // 明理苑9舍
            return [1, 8]
        }

        return [0, 0]
    }
}

