//
//  UFieldActivityViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/13.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class UFieldActivityViewController: UIViewController {
    
    override func viewDidLoad() {
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#FFFFFF")!, darkColor: UIColor(hexString: "#FFFFFF")!, alpha: 1)
        }
        else {
            view.backgroundColor = UIColor(hexString: "#FFFFFF"	)
        }
        
        addTopView()
        
        view.addSubview(selectBar)
        addChild(collectionViewVC)
        view.addSubview(collectionViewVC.view)
        collectionViewVC.didMove(toParent: self)

        let jsonData = """
        {
            "status": 10000,
            "info": "success",
            "data": [
                {
                    "activity_title": "军事演习",
                    "activity_type": "education",
                    "activity_id": 19,
                    "activity_create_timestamp": 1691241359,
                    "activity_detail": "这是军事演习, 大家都来捧场哈",
                    "activity_start_at": 1691241359,
                    "activity_end_at": 1691241360,
                    "activity_watch_number": 3,
                    "activity_organizer": "软件工程学院",
                    "activity_creator": "郝尧",
                    "activity_place": "风雨操场",
                    "activity_registration_type": "free",
                    "activity_cover_url": "http://xxx.jpg"
                },
                {
                    "activity_title": "军事演习2",
                    "activity_type": "education",
                    "activity_id": 18,
                    "activity_create_timestamp": 1691241359,
                    "activity_detail": "这是军事演习, 大家都来捧场哈",
                    "activity_start_at": 1691241359,
                    "activity_end_at": 1691241360,
                    "activity_watch_number": 3,
                    "activity_organizer": "软件工程学院",
                    "activity_creator": "郝尧",
                    "activity_place": "风雨操场",
                    "activity_registration_type": "free",
                    "activity_cover_url": "http://xxx.jpg"
                },
                {
                    "activity_title": "军事演习3",
                    "activity_type": "education",
                    "activity_id": 17,
                    "activity_create_timestamp": 1691241359,
                    "activity_detail": "这是军事演习, 大家都来捧场哈",
                    "activity_start_at": 1691241359,
                    "activity_end_at": 1691241360,
                    "activity_watch_number": 3,
                    "activity_organizer": "软件工程学院",
                    "activity_creator": "郝尧",
                    "activity_place": "风雨操场",
                    "activity_registration_type": "free",
                    "activity_cover_url": "http://xxx.jpg"
                }
            ]
        }
        """.data(using: .utf8)!

        do {
            let decoder = JSONDecoder()
            let activityResponse = try decoder.decode(SearchActivityResponse.self, from: jsonData)
            
            // 现在你可以访问解析后的数据
            let activities = activityResponse.data
            
            for activity in activities {
                print("活动标题：\(activity.activityTitle)")
            }
        } catch {
            print("解析失败：\(error)")
        }

        
    }
    //顶部视图
    lazy var topView: UFieldActivityTopView = {
        let topView = UFieldActivityTopView(frame: CGRectMake(0, 0, view.bounds.width, 109+UIApplication.shared.statusBarFrame.height))
        topView.backButton.addTarget(self, action: #selector(popController), for: .touchUpInside)
        return topView
    }()
    //活动类型选择bar
    lazy var selectBar: UFieldActivitySelectBar = {
        let selectBar = UFieldActivitySelectBar(frame: CGRectMake(0, topView.bounds.height, view.bounds.width, 50))
        selectBar.buttons.forEach({ button in
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        })
        return selectBar
    }()
    //collectionView活动显示，两列
    lazy var collectionViewVC: UFieldActivityCollectionViewController = {
        let vc = UFieldActivityCollectionViewController()
        vc.view.frame = CGRectMake(0, topView.bounds.height + 50, view.bounds.width, view.bounds.height - topView.bounds.height - 50)
        return vc
    }()
    
    
    
    @objc private func buttonTapped(_ sender: RadioButton) {
        // 根据需要在这里执行相应的操作，例如根据按钮的标签来处理不同的逻辑
        switch sender.tag {
        case 0:
            print("全部")
            // 处理 "全部" 按钮点击事件
            break
        case 1:
            print("文娱活动")
            // 处理 "文娱活动" 按钮点击事件
            break
        case 2:
            print("体育活动")
            // 处理 "体育活动" 按钮点击事件
            break
        case 3:
            print("教育活动")
            // 处理 "教育活动" 按钮点击事件
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
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOpacity = 0.5
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowLayer.shadowRadius = 4
        
        // 将阴影图层插入到顶部视图的图层中，使阴影位于底部
        topView.layer.insertSublayer(shadowLayer, at: 0)
    }
}








