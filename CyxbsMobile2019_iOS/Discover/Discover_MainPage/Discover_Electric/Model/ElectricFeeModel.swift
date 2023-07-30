//
//  ElectricFeeModel.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/29.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

class ElectricFeeModel {
    var status: Int = 0
    var electricFeeItem: ElectricFeeItem?

    /// 网络请求
    func request(success: (() -> Void)?, failure: ((Error) -> Void)?) {
        // 缓存中有寝室号和寝室楼号就直接查询，否则传空试图从后端获取
        let parameters: [String: Any] = (UserItemTool.defaultItem().building != nil && UserItemTool.defaultItem().room != nil) ?
        ["building": UserItemTool.defaultItem().building ?? "", "room": UserItemTool.defaultItem().room ?? ""] :
            ["building": "", "room": ""]
//        HttpTool.share().request(
//            Discover_POST_electricFee_API,
//            type: .post,
//            serializer: .HTTP,
//            bodyParameters: parameters,
//            progress: nil,
//            success: { [weak self] (task, object) in
//                print(object ?? "")
//                self?.status = (object?["status"] as? Int) ?? 0
//                if self?.status == 200 {
//                    self?.electricFeeItem = ElectricFeeItem(dict: object)
//                } else {
//                    print("🔴\((self?.classForCoder)!):\n\(object?["info"] as? String ?? "")")
//                }
//                success?()
//            },
//            failure: { (task, error) in
//                print("🔴\((self.classForCoder)):\n\(error)")
//                failure?(error)
//            }
//        )
        HttpTool.share().request(
            Discover_POST_electricFee_API,
            type: .post,
            serializer: .HTTP,
            bodyParameters: parameters,
            progress: nil,
            success: { [weak self] (task, object) in
                if let responseDict = object as? [String: Any] {
                    print(responseDict)
                    self?.status = responseDict["status"] as? Int ?? 0
                    if self?.status == 200 {
                        self?.electricFeeItem = ElectricFeeItem(dict: responseDict)
                    } else {
                        print("🔴\(type(of: self)):\n\(responseDict["info"] as? String ?? "")")
                    }
                    success?()
                } else {
                    print("🔴 Response is not a valid JSON dictionary.")
                    failure?(NSError(domain: "com.yourapp.networking", code: -1, userInfo: nil))
                }
            },
            failure: { (task, error) in
                print("🔴\(type(of: self)):\n\(error)")
                failure?(error)
            }
        )

    }
}

