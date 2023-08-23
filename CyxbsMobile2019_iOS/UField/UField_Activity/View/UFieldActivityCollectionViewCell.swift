//
//  UFieldActivityCollectionViewCell.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/16.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class UFieldActivityCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "ImageCell"
    
    let coverImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRectMake(0, 0, 167, 145)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRectMake(12, 158, 82, 22)
        label.textAlignment = .left
        label.font = UIFont(name: PingFangSCBold, size: 16)
        label.textColor = UIColor(hexString: "#15315B")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let activityTypeLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRectMake(12, 182, 48, 17)
        label.textAlignment = .left
        label.font = UIFont(name: PingFangSCMedium, size: 12)
        label.textColor = UIColor(hexString: "#15315B", alpha: 0.4)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startTimeLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRectMake(33, 207, 94, 17)
        label.textAlignment = .left
        label.font = UIFont(name: PingFangSCMedium, size: 12)
        label.textColor = UIColor(hexString: "#15315B", alpha: 0.6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let clockImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.frame = CGRectMake(12, 208, 16, 16)
        imgView.image = UIImage(named: "activityTime")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(coverImgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(activityTypeLabel)
        contentView.addSubview(startTimeLabel)
        contentView.addSubview(clockImgView)
        //设置阴影
        layer.shadowColor = UIColor(red: 0.568, green: 0.603, blue: 0.921, alpha: 0.1).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 10
        layer.shadowOpacity = 1
        layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.white.cgColor
        //设置圆角
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 8
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 在布局发生变化时更新阴影路径
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}

