//
//  ActivityCenterVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/9/16.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import JXPagingView

class ActivityCenterVC: UIViewController {
    
    var participatedActivities: [Activity] = []
    var publishedActivities: [Activity] = []
    var reviewingActivities: [Activity] = []
    var wantToWatchActivities: [Activity] = []
    var tableViewControllers: [ActivityCenterTableViewVC] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addVCs()
        let segmentView = QAListSegmentView(frame: CGRectMake(0, UIApplication.shared.statusBarFrame.height+45, self.view.width, view.height - 60), controllers: tableViewControllers)!
        segmentView.titleFont = UIFont(name: PingFangSCMedium, size: 18)
        segmentView.titleColor = UIColor(red: 0.078, green: 0.173, blue: 0.322, alpha: 0.4)
        segmentView.selectedTitleFont = UIFont(name: PingFangSCMedium, size: 18)
        segmentView.selectedTitleColor = UIColor(red: 0.067, green: 0.173, blue: 0.329, alpha: 1)
        segmentView.updateUI()
        addTopView()
        view.addSubview(segmentView)
        segmentView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+45)
            make.bottom.equalToSuperview()
        }
        requestActivity()
    }
    
    func requestActivity() {
        ActivityClient.shared.request(url:"magipoke-ufield/activity/list/me/",
                                      method: .get,
                                      headers: nil,
                                      parameters: nil) { responseData in
            if let dataDict = responseData as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: dataDict),
               let mineActivityResponseData = try? JSONDecoder().decode(MineActivityResponse.self, from: jsonData) {
                for activity in mineActivityResponseData.data.wantToWatch {
                    self.wantToWatchActivities.append(activity)
                }
                self.tableViewControllers[0].activities = self.wantToWatchActivities
                for activity in mineActivityResponseData.data.participated {
                    self.participatedActivities.append(activity)
                }
                self.tableViewControllers[1].activities = self.participatedActivities
                for activity in mineActivityResponseData.data.published {
                    self.publishedActivities.append(activity)
                }
                self.tableViewControllers[2].activities = self.publishedActivities
                for activity in mineActivityResponseData.data.reviewing {
                    self.reviewingActivities.append(activity)
                }
                self.tableViewControllers[3].activities = self.reviewingActivities
                //所有子vc的tableView重新载入数据
                for ActivityCenterTableViewVC in self.tableViewControllers {
                    print(ActivityCenterTableViewVC.activities.count)
                    ActivityCenterTableViewVC.tableView.reloadData()
                }
//                print(self.wantToWatchActivities.count)
            } else {
                print("Invalid response data")
                print(responseData)
            }
        } failure: { error in
            ActivityHUD.shared.addProgressHUDView(width: 179,
                                                        height: 36,
                                                        text: "服务君似乎打盹了呢",
                                                        font: UIFont(name: PingFangSCMedium, size: 13)!,
                                                        textColor: .white,
                                                        delay: 2,
                                                        view: self.view,
                                                        backGroundColor: UIColor(hexString: "#2a4e84"),
                                                        cornerRadius: 18,
                                                        yOffset: Float(-UIScreen.main.bounds.width + UIApplication.shared.statusBarFrame.height) + 78)
        }
    }
    
    // MARK: - 懒加载
    //顶部视图
    lazy var topView: ActivityCenterTopView = {
        let topView = ActivityCenterTopView(frame: CGRectMake(0, 0, view.bounds.width, 92+UIApplication.shared.statusBarFrame.height))
        topView.backButton.addTarget(self, action: #selector(popController), for: .touchUpInside)
        return topView
    }()
    
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
    
    func addVCs() {
        let wantToWatchVC = ActivityCenterTableViewVC()
        wantToWatchVC.title = "我想看"
        addChild(wantToWatchVC)
        tableViewControllers.append(wantToWatchVC)
        
        let participatedVC = ActivityCenterTableViewVC()
        participatedVC.title = "已参与"
        addChild(participatedVC)
        tableViewControllers.append(participatedVC)
        
        let publishedVC = ActivityCenterTableViewVC()
        publishedVC.title = "已发布"
        addChild(publishedVC)
        tableViewControllers.append(publishedVC)
        
        let reviewingVC = ActivityCenterTableViewVC()
        reviewingVC.title = "待审核"
        addChild(reviewingVC)
        tableViewControllers.append(reviewingVC)
    }
    
    @objc func popController() {
        self.navigationController?.popViewController(animated: true)
    }
}



