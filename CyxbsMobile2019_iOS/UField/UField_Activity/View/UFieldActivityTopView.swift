//
//  UFieldActivityTopView.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/24.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import SnapKit


class UFieldActivityTopView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 11.0, *) {
            self.backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#FFFFFF")!, darkColor: UIColor(hexString: "#000101")!, alpha: 1)
        }
        else {
            self.backgroundColor = UIColor(hexString: "#FFFFFF")
        }
        addSubview(titleLab)
        addSubview(backButton)
        addSubview(searchButton)
        addSubview(addActivityButton)
        setPosition()
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
    
    //标题
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.text = "活动布告栏"
        label.font = UIFont(name: PingFangSCMedium, size: 22)
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#15315B")!, alpha: 1)
        }
        else {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#15315B")!, alpha: 1)
        }
        
        return label
    }()
    // 返回按钮
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "EmptyClassBackButton"), for: .normal)
        button.setImage(UIImage(named: "EmptyClassBackButton"), for: .highlighted)
        return button
    }()
    //搜索按钮
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hexString: "#15315B", alpha: 0.05)
        button.layer.cornerRadius = 19
        button.setTitle("查看更多活动...", for: .normal)
        button.titleLabel?.font = UIFont(name: PingFangSCMedium, size: 16)
        button.setTitleColor(UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B", alpha: 0.2), darkColor: UIColor(hexString: "#15315B", alpha: 0.2)), for: .normal)
        button.setImage(UIImage(named: "放大镜"), for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 146)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 11, bottom: 11, right: 273)
        return button
    }()
    //添加活动按钮
    lazy var addActivityButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "add"), for: .normal)
        return button
    }()
    
    func setPosition() {
        // 返回按钮
        self.backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(17)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+13)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        //返回按钮图片
        self.backButton.imageView?.snp.makeConstraints { make in
            make.width.equalTo(7)
            make.height.equalTo(16)
            make.centerY.equalTo(self.backButton)
        }
        // 标题栏
        self.titleLab.snp.makeConstraints { make in
            make.left.equalTo(self.backButton.snp.right).offset(1)
            make.centerY.equalTo(self.backButton)
            make.width.equalTo(110)
            make.height.equalTo(31)
        }
        //搜索栏按钮
        self.searchButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(self.titleLab.snp.bottom).offset(14)
            make.height.equalTo(38)
            make.width.equalTo(302)
        }
        //添加活动按钮
        self.addActivityButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(self.searchButton)
            make.width.equalTo(28)
            make.height.equalTo(28)
        }
    }
    
}
