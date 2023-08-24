//
//  UFieldActivityViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/13.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class UFieldActivityViewController: UIViewController {
    
    var requestURL: String!
    var collectionViewVC: UFieldActivityCollectionViewController!
    
    override func viewDidLoad() {
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#FFFFFF")!, darkColor: UIColor(hexString: "#FFFFFF")!, alpha: 1)
        }
        else {
            view.backgroundColor = UIColor(hexString: "#FFFFFF"	)
        }
        addTopView()
        view.addSubview(selectBar)
        addcollectionViewVC()
        requestURL = "https://be-dev.redrock.cqupt.edu.cn/magipoke-ufield/activity/list/all/"
        requestActivity()
        isAdmin()
        
    }
    //顶部视图
    lazy var topView: UFieldActivityTopView = {
        let topView = UFieldActivityTopView(frame: CGRectMake(0, 0, view.bounds.width, 109+UIApplication.shared.statusBarFrame.height))
        topView.backButton.addTarget(self, action: #selector(popController), for: .touchUpInside)
        return topView
    }()
    //活动类型选择bar
    lazy var selectBar: UFieldActivitySelectBar = {
        let selectBar = UFieldActivitySelectBar(frame: CGRectMake(0, topView.bounds.height, view.bounds.width, 51))
        selectBar.buttons.forEach({ button in
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        })
        return selectBar
    }()
    
    
    
    @objc private func buttonTapped(_ sender: RadioButton) {
        // 根据需要在这里执行相应的操作，例如根据按钮的标签来处理不同的逻辑
        switch sender.tag {
        case 0:
            print("全部活动")
            // 处理 "全部" 按钮点击事件
            reinitializeCollectionViewVC()
            requestURL = "https://be-dev.redrock.cqupt.edu.cn/magipoke-ufield/activity/list/all/"
            requestActivity()
            break
        case 1:
            print("文娱活动")
            // 处理 "文娱活动" 按钮点击事件
            reinitializeCollectionViewVC()
            requestURL = "https://be-dev.redrock.cqupt.edu.cn/magipoke-ufield/activity/list/all/?activity_type=culture"
            requestActivity()
            break
        case 2:
            print("体育活动")
            // 处理 "体育活动" 按钮点击事件
            reinitializeCollectionViewVC()
            requestURL = "https://be-dev.redrock.cqupt.edu.cn/magipoke-ufield/activity/list/all/?activity_type=sports"
            requestActivity()
            break
        case 3:
            print("教育活动")
            // 处理 "教育活动" 按钮点击事件
            reinitializeCollectionViewVC()
            requestURL = "https://be-dev.redrock.cqupt.edu.cn/magipoke-ufield/activity/list/all/?activity_type=education"
            requestActivity()
            break
        default:
            break
        }
    }
    
    @objc func popController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func addTopView() {
        // 添加顶部视图
        view.addSubview(topView)
        
        // 创建圆角路径，将左下角和右下角设置为圆角
        let cornerRadius: CGFloat = 20
        let shadowPath = UIBezierPath(roundedRect: topView.bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        // 创建阴影图层
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = shadowPath.cgPath
        shadowLayer.fillColor = UIColor.white.cgColor

        // 设置阴影属性
        shadowLayer.shadowColor = UIColor.gray.cgColor
        shadowLayer.shadowOpacity = 0.1
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowLayer.shadowRadius = 4

        // 将阴影图层插入到顶部视图的图层中，使阴影位于底部
        topView.layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func addcollectionViewVC() {
        //collectionView活动显示，两列
        collectionViewVC = UFieldActivityCollectionViewController()
        collectionViewVC.view.frame = CGRectMake(0, topView.bounds.height + selectBar.height+8, view.bounds.width, view.bounds.height - topView.height - selectBar.height - 8)
        addChild(collectionViewVC)
        view.addSubview(collectionViewVC.view)
        collectionViewVC.didMove(toParent: self)
    }
    
    func reinitializeCollectionViewVC() {
        // 移除原有 collectionViewVC
        collectionViewVC?.view.removeFromSuperview()
        collectionViewVC?.removeFromParent()
        collectionViewVC = nil
        // 创建新的 collectionViewVC
        addcollectionViewVC()
    }
    
    func isAdmin() {
        ActivityClient.shared.request(URL(string: "https://be-dev.redrock.cqupt.edu.cn/magipoke-ufield//isadmin/")!,
                                      method: .get,
                                      headers: nil,
                                      parameters: nil) { responseData in
            if let dataDict = responseData as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: dataDict),
               let adminResponseData = try? JSONDecoder().decode(AdminResponseData.self, from: jsonData) {
                if (adminResponseData.data.admin) {
                    self.topView.adAdminButton()
                }
            } else {
                print("Invalid response data")
            }
        }
    }
    
    func requestActivity() {
        ActivityClient.shared.request(URL(string: requestURL)!,
                                      method: .get,
                                      headers: nil,
                                      parameters: nil) { responseData in
            print(responseData as Any)
            if let dataDict = responseData as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: dataDict),
               let allActivityResponseData = try? JSONDecoder().decode(AllActivityResponse.self, from: jsonData) {
                for activity in allActivityResponseData.data.ongoing {
                    self.collectionViewVC.activities.append(activity)
                }
                for activity in allActivityResponseData.data.ended {
                    self.collectionViewVC.activities.append(activity)
                }
                print("活动数量：\(self.collectionViewVC.activities.count)")
                if(self.collectionViewVC.activities.count < self.collectionViewVC.refreshNum) {
                    self.collectionViewVC.collectionViewCount = self.collectionViewVC.activities.count
                } else {
                    self.collectionViewVC.collectionViewCount = self.collectionViewVC.refreshNum
                }
                self.collectionViewVC.collectionView.reloadData()
                if (self.collectionViewVC.collectionViewCount != 0) {
                    self.collectionViewVC.addMJFooter()
                } else {
                    UFieldActivityHUD.shared.addProgressHUDView(width: 138,
                                                                height: 36,
                                                                text: "暂无更多内容",
                                                                font: UIFont(name: PingFangSCMedium, size: 13)!,
                                                                textColor: .white,
                                                                delay: 2,
                                                                view: self.view,
                                                                backGroundColor: UIColor(hexString: "#2a4e84"),
                                                                cornerRadius: 20.5,
                                                                yOffset: -200)
                }
            } else {
                print("Invalid response data")
            }
        }
    }
}










