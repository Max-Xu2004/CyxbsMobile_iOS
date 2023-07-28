//
//  TopView.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/24.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit


class TopView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 11.0, *) {
            self.backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#F8F9FC")!, darkColor: UIColor(hexString: "#000101")!, alpha: 1)
        }
        else {
            self.backgroundColor = UIColor(hexString: "#F8F9FC")
        }
        addSubview(self.titleLab)
        addSubview(self.backButton)
        setPosition()
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
    
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.text = "我的考试"
//        label.font = UIFont(name: "PingFangSCBold", size: 21)
        label.font = UIFont(name: "PingFangSC-Semibold", size: 21)
        label.textColor = .black
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#F0F0F2")!, alpha: 1)
        }
        else {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#FFFFFF")!, alpha: 1)
        }
        
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "LQQBackButton"), for: .normal)
        button.setImage(UIImage(named: "EmptyClassBackButton"), for: .highlighted)
        return button
    }()
    
    func setPosition(){
        //返回按钮
        self.backButton.translatesAutoresizingMaskIntoConstraints = false
        self.backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 17).isActive = true
        self.backButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 43).isActive = true
        self.backButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            
        self.backButton.imageView?.translatesAutoresizingMaskIntoConstraints = false
        self.backButton.imageView?.widthAnchor.constraint(equalToConstant: 7).isActive = true
        self.backButton.imageView?.heightAnchor.constraint(equalToConstant: 14).isActive = true
        //标题栏
        self.titleLab.translatesAutoresizingMaskIntoConstraints = false
        self.titleLab.leadingAnchor.constraint(equalTo: self.backButton.trailingAnchor, constant: 20).isActive = true
        self.titleLab.centerYAnchor.constraint(equalTo: self.backButton.centerYAnchor).isActive = true
    }
    
}
