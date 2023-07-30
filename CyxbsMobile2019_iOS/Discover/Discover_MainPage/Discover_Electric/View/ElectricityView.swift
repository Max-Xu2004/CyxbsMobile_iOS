//
//  ElectricityView.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/29.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import SnapKit

class ElectricityView: UIView {
    // MARK: - 电费查询部分
    let electricFeeTitle = UILabel()
    let electricFeeTime = UILabel()
    let electricFeeMoney = UILabel()
    let electricConsumption = UILabel()
    let electricFeeYuan = UILabel()
    let electricFeeDu = UILabel()
    let electricFeeHintLeft = UILabel()
    let electricFeeHintRight = UILabel()
    let hintLabel = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUIDefaults()
        addHintLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Method
    private func setUIDefaults() {
        backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#F8F9FC", alpha: 1), darkColor: UIColor(hexString: "#1D1D1D", alpha: 1))
        layer.shadowOpacity = 0.16
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        clipsToBounds = true
    }

    func refreshViewIfNeeded() {
        removeAllSubviews()
        if UserItemTool.defaultItem().building != nil && UserItemTool.defaultItem().room != nil {
            addBindingView()
        } else {
            addNoBindingView()
        }
    }

    // MARK: - 绑定部分
    private func addBindingView() {
        addTitle()
        addSeperateLine()
        addElectricFeeTime()
        addElectricFeeMoney()
        addElectricConsumption()
        addElectricFeeYuan()
        addElectricFeeDu()
        addElectricFeeHintLeft()
        addElectricFeeHintRight()
        configBindingUI()
    }

    private func addElectricFeeTime() {
        // 右上角抄表时间
        if let timeStr = UserDefaults.standard.string(forKey: "ElectricFee_time") {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M.dd"
            if let date = dateFormatter.date(from: timeStr) {
                dateFormatter.dateFormat = "M月dd日抄表"
                let elecTime = dateFormatter.string(from: date)
                electricFeeTime.text = elecTime
                electricFeeTime.text = elecTime
                }
        }
        
        addSubview(electricFeeTime)
    }

    private func addElectricFeeMoney() {
        if let money = UserDefaults.standard.object(forKey: "ElectricFee_money") as? String {
            electricFeeMoney.text = money
        } else {
            electricFeeMoney.text = "0"
        }
        addSubview(electricFeeMoney)
    }

    private func addElectricConsumption() {
        if let degree = UserDefaults.standard.object(forKey: "ElectricFee_degree") {
            electricConsumption.text = "\(degree)"
        } else {
            electricConsumption.text = "0"
        }
        addSubview(electricConsumption)
    }

    private func addElectricFeeYuan() {
        // 汉字“元”
        electricFeeYuan.text = "元"
        addSubview(electricFeeYuan)
    }

    private func addElectricFeeDu() {
        // 汉字“度”
        electricFeeDu.text = "度"
        addSubview(electricFeeDu)
    }

    private func addElectricFeeHintLeft() {
        // 汉字“费用、本月”
        electricFeeHintLeft.text = "费用/本月"
        addSubview(electricFeeHintLeft)
    }

    private func addElectricFeeHintRight() {
        // 汉字“使用度数，本月”
        electricFeeHintRight.text = "使用度数/本月"
        addSubview(electricFeeHintRight)
    }

    private func configBindingUI() {
        electricFeeTime.snp.makeConstraints { make in
            make.centerY.equalTo(electricFeeTitle)
            make.right.equalToSuperview().offset(-15)
        }

        electricFeeMoney.snp.makeConstraints { make in
            make.top.equalTo(electricFeeTitle.snp.bottom).offset(17)
            make.centerX.equalToSuperview().offset(-frame.width / 4.0)
            make.height.equalTo(44)
        }

        electricConsumption.snp.makeConstraints { make in
            make.top.equalTo(electricFeeMoney)
            make.centerX.equalToSuperview().offset(frame.width / 4.0)
            make.height.equalTo(44)
        }

        electricFeeYuan.snp.makeConstraints { make in
            make.left.equalTo(electricFeeMoney.snp.right).offset(9)
            make.bottom.equalTo(electricFeeMoney).offset(-6)
        }

        electricFeeDu.snp.makeConstraints { make in
            make.left.equalTo(electricConsumption.snp.right).offset(9)
            make.bottom.equalTo(electricConsumption).offset(-6)
        }

        electricFeeHintLeft.snp.makeConstraints { make in
            make.top.equalTo(electricFeeMoney.snp.bottom)
            make.centerX.equalTo(electricFeeMoney)
        }

        electricFeeHintRight.snp.makeConstraints { make in
            make.top.equalTo(electricConsumption.snp.bottom)
            make.centerX.equalTo(electricConsumption)
        }
    }

    // MARK: - 未绑定部分
    private func addNoBindingView() {
        addTitle()
        addSeperateLine()
        addHintLabel()
    }

    private func addHintLabel() {
        addSubview(hintLabel)
        hintLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(20)
        }
    }

    private func addTitle() {
        // 左上角标题
        addSubview(electricFeeTitle)
        electricFeeTitle.text = "电费查询"
        electricFeeTitle.font = UIFont(name: PingFangSCBold, size: 18)
        electricFeeTitle.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B", alpha: 1), darkColor: UIColor(hexString: "#F0F0F2", alpha: 1))
        electricFeeTitle.frame = CGRect(x: 14, y: 23, width: 80, height: 20)
    }

    private func addSeperateLine() {
        let line = UIView()
        line.backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#2A4E84", alpha: 0.1), darkColor: UIColor(hexString: "#2D2D2D", alpha: 0.5))
        addSubview(line)
        line.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

// 在这里实现需要的扩展和方法


