//
//  UFieldActivityHitTableViewCell.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/9/6.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class ActivityHitTableViewCell: UITableViewCell {
    lazy var coverImgView: UIImageView = {
        let imageView = UIImageView(frame: CGRectMake(59, 17, 42, 42))
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRectMake(106, 25, 146, 25))
        label.textColor = UIColor(red: 0.067, green: 0.173, blue: 0.329, alpha: 1)
        label.font = UIFont(name: PingFangSCMedium, size: 18)
        return label
    }()
    
    lazy var wantToWatchNum: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.29, green: 0.267, blue: 0.894, alpha: 1)
        label.font = UIFont(name: PingFangSCMedium, size: 18)
        label.textAlignment = .right
        return label
    }()
    
    lazy var rankingLabel: UILabel = {
        let label = UILabel(frame: CGRectMake(16, 25, 24, 28))
        label.font = UIFont(name: PingFangSCBold, size: 20)
        label.textColor = UIColor(red: 0.29, green: 0.267, blue: 0.894, alpha: 0.6)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(coverImgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(wantToWatchNum)
        contentView.addSubview(rankingLabel)
        self.wantToWatchNum.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(25)
            make.height.equalTo(25)
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
