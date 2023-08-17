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
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let activityTypeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let startTimeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(coverImgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(activityTypeLabel)
        contentView.addSubview(startTimeLabel)
        
        NSLayoutConstraint.activate([
            coverImgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            coverImgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            coverImgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            coverImgView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.topAnchor.constraint(equalTo: coverImgView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            activityTypeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            activityTypeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            activityTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            startTimeLabel.topAnchor.constraint(equalTo: activityTypeLabel.bottomAnchor, constant: 4),
            startTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            startTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            startTimeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

