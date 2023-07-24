//
//  TestArrangeView.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

// 获取状态栏高度
let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
// 获取屏幕宽度和高度
let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
//获取触控条高度
let bottomInset = UIApplication.shared.windows.first?.safeAreaInsets.bottom

class TestArrangeView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topBar)
        self.topBar.addSubview(self.titleLab)
        self.topBar.addSubview(self.backButton)
        addSubview(avatarButton)
        addSubview(userNameLabel)
        addSubview(idLabel)
        addSubview(majorLabel)
        setPosition()
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
    
    lazy var topBar:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: 80))
        view.backgroundColor = self.backgroundColor
        return view
    }()
    
    lazy var titleLab: UILabel = {
        let label = UILabel()
        label.text = "我的考试"
//        label.font = UIFont(name: "PingFangSCBold", size: 21)
        label.font = UIFont.boldSystemFont(ofSize: 21)
        label.textColor = .black
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#F0F0F2")!, alpha: 1)
        } else {
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
    
    lazy var avatarButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 20, y: screenHeight-60, width: 40, height: 40))
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.setImage(UIImage(named: "默认头像"), for: .normal)
        button.setImage(UIImage(named: "默认头像"), for: .highlighted)
        button.setImage(UIImage(named: "默认头像"), for: .selected)
        return button
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var idLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    lazy var majorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        return label
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
        //姓名
        userNameLabel.snp.makeConstraints { make in
                    make.left.equalTo(avatarButton.snp.right).offset(14)
                    make.top.equalTo(avatarButton)
                }
        idLabel.snp.makeConstraints { make in
                    make.centerY.equalTo(avatarButton)
                    make.right.equalTo(self).offset(-15)
                }
                majorLabel.snp.makeConstraints { make in
                    make.left.equalTo(userNameLabel)
                    make.top.equalTo(userNameLabel.snp.bottom).offset(4)
                }
    }
    
}
