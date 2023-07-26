//
//  BottomView.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/24.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class BottomView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.dm_color(withLightColor: .white, darkColor: .gray, alpha: 1)
        addSubview(self.avatarButton)
        addSubview(self.userNameLabel)
        addSubview(self.idLabel)
        addSubview(self.majorLabel)
        setPosition()
    }
    
    required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
    }
    
    
    
    lazy var avatarButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 16, y: 30, width: 40, height: 40))
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
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#F0F0F2")!, alpha: 1)
        }
        else {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#FFFFFF")!, alpha: 1)
        }
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
