//
//  UserInfoModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/28.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation
import SwiftSoup

struct UserInfoModel {
    let studentNumber: String // 学号
    let name: String // 名字
    let classNum: String // 班级
    let major: String // 专业
    let college: String // 学院
    let secondMajorClass: String // 二专业班
    let authCode: String // 统一认证码
    let email: String // 电子邮件
    let phoneNumber: String // 电话号码

    static func parseUserInfo(from htmlString: String) -> UserInfoModel? {
        guard let doc = try? SwiftSoup.parse(htmlString) else {
            return nil
        }

        func extractValue(for field: String) -> String? {
            return try? doc.select("tr:contains(\(field)) td:eq(1)").first()?.text()
        }

        return UserInfoModel(
            studentNumber: extractValue(for: "学号") ?? "",
            name: extractValue(for: "姓名") ?? "",
            classNum: extractValue(for: "班级") ?? "",
            major: extractValue(for: "专业") ?? "",
            college: extractValue(for: "学院") ?? "",
            secondMajorClass: extractValue(for: "二专业班") ?? "",
            authCode: extractValue(for: "统一认证码") ?? "",
            email: extractValue(for: "电子邮箱") ?? "",
            phoneNumber: extractValue(for: "联系电话") ?? ""
        )
    }
}

//// 使用示例：
//let htmlString = "..." // 包含HTML内容的字符串
//if let userInfo = UserInfoModel.parseUserInfo(from: htmlString) {
//    print("学号：\(userInfo.studentNumber)")
//    print("姓名：\(userInfo.name)")
//    print("班级：\(userInfo.classNum)")
//    // ...
//}
