//
//  UFieldActivityDetailView.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/24.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class UFieldActivityDetailView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.layer.cornerRadius = 16
        self.backgroundColor = .white
        addSubview(organizerView)
        addSubview(creatorView)
        addSubview(registrationView)
        addSubview(placeView)
        addSubview(informationView)
        addSubview(detailView)
    }
    
    lazy var organizerView: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 16, y: 24, width: 48, height: 22)
        label.textColor = UIColor(red: 0.082, green: 0.192, blue: 0.357, alpha: 0.6)
        label.font = UIFont(name: PingFangSCMedium, size: 16)
        label.text = "主办方"
        return label
    }()
    
    lazy var creatorView: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 16, y: 65, width: 48, height: 22)
        label.textColor = UIColor(red: 0.082, green: 0.192, blue: 0.357, alpha: 0.6)
        label.font = UIFont(name: PingFangSCMedium, size: 16)
        label.text = "创建者"
        return label
    }()
    
    lazy var registrationView:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 16, y: 106, width: 64, height: 22)
        label.textColor = UIColor(red: 0.082, green: 0.192, blue: 0.357, alpha: 0.6)
        label.font = UIFont(name: PingFangSCMedium, size: 16)
        label.text = "报名方式"
        return label
    }()
    
    lazy var placeView: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 16, y: 147, width: 64, height: 22)
        label.textColor = UIColor(red: 0.082, green: 0.192, blue: 0.357, alpha: 0.6)
        label.font = UIFont(name: PingFangSCMedium, size: 16)
        label.text = "活动地点"
        return label
    }()
    
    lazy var informationView :UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 16, y: 199, width: 64, height: 22)
        label.textColor = UIColor(red: 0.067, green: 0.173, blue: 0.329, alpha: 1)
        label.font = UIFont(name: PingFangSCMedium, size: 16)
        label.text = "活动信息"
        return label
    }()
    
    lazy var detailView: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 16, y: 305, width: 64, height: 22)
        label.textColor = UIColor(red: 0.067, green: 0.173, blue: 0.329, alpha: 1)
        label.font = UIFont(name: PingFangSCMedium, size: 16)
        label.text = "活动介绍"
        return label
    }()
}

