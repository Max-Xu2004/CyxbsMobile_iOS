//
//  UFieldActivityProgressView.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import SnapKit

class UFieldActivityProgressView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hexString: "#2A4E84")
        addSubview(textLabel)
        setPosition()
        // 添加圆角
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(hexString: "#2A4E84")
        addSubview(textLabel)
        setPosition()
        // 添加圆角
        self.layer.cornerRadius = 20.5
        self.layer.masksToBounds = true
    }
    
    lazy var textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: PingFangSCMedium, size: 13)
        label.textAlignment = .center
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: .white, darkColor: .white)
        }
        else {
            label.textColor = UIColor.dm_color(withLightColor: .white, darkColor: .white)
        }
        
        return label
    }()
    
    func setPosition() {
        self.textLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
}
