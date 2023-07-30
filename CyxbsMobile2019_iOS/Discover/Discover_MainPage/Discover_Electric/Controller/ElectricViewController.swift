//
//  ElectricViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/29.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class ElectricViewController: UIViewController {
    // MARK: - 属性
    private var eleView: ElectricityView!
    private var elecModel: ElectricFeeModel!

    // MARK: - 生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserItemTool.defaultItem().room == nil && UserItemTool.defaultItem().building == nil {
            eleView.refreshViewIfNeeded()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#F8F9FC", alpha: 1), darkColor: UIColor(hexString: "#1D1D1D", alpha: 1))
        // 设置上方的圆角
        let maskPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1000), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 16, height: 16))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
        // 设置阴影
        view.layer.shadowOpacity = 0.33
        view.layer.shadowColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#AEB6D3", alpha: 0.16), darkColor: UIColor(hexString: "#AEB6D3", alpha: 0.16)).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -5)

        addEleView()
        requestData()
    }

    // MARK: - 方法
    private func addEleView() {
        eleView = ElectricityView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 152))
        view.addSubview(eleView)
    }

    private func requestData() {
        elecModel = ElectricFeeModel()
        elecModel.request(success: {
            if let buildAndRoom = self.elecModel.electricFeeItem?.buildAndRoom {
                UserItemTool.defaultItem().building = String(buildAndRoom.prefix(2))
                UserItemTool.defaultItem().room = String(buildAndRoom.suffix(from: buildAndRoom.index(buildAndRoom.startIndex, offsetBy: 3)))
                print("\(UserItemTool.defaultItem().building), \(UserItemTool.defaultItem().room)")
                self.updateElectricFeeUI()
            } else {
                print("可能是房间号输入错误")
                // 提醒用户重新绑定
                self.bindingRoomFailed()
            }
        }, failure: { error in
            self.requestElectricFeeFailed()
        })
    }

    private func bindingRoomFailed() {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = .text
        hud?.labelText = "绑定的宿舍号可能有问题哦，请重新绑定"
        UserItemTool.defaultItem().building = nil
        UserItemTool.defaultItem().room = nil
        hud?.hide(true, afterDelay: 1.2)
    }

    private func requestElectricFeeFailed() {
        // MBProgressHUD 版本被注释掉，因为在 Swift 代码中未提供，您可以根据需要实现显示错误消息的其他方法
    }

    private func updateElectricFeeUI() {
        // 根据模型中的数据更新视图
        // 注意：确保实现了 refreshViewIfNeeded 方法，并根据情况设置 electricFeeMoney 和 electricConsumption 文本
        if let money = elecModel.electricFeeItem?.money {
            UserDefaults.standard.set(money, forKey: "ElectricFee_money")
            // 如果需要，这里可以设置其他 UserDefaults

            // 在更新数据后刷新视图
            eleView.refreshViewIfNeeded()
            eleView.electricFeeMoney.text = money
            // 如果 electricFeeMoney 是 UIButton，并且您希望设置其标题，则取消下面一行的注释
            // eleView.electricFeeMoney.setTitle(money, for: .normal)
        }
    }
}

// 在这里实现 ElectricFeeModel 类

// 在这里实现 ElectricityView 类


