//
//  UFieldActivityAddScrollView.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/27.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import SnapKit

class UFieldActivityAddScrollView: UIScrollView {
    // MARK: - 懒加载
    lazy var coverImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "addCover")
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.082, green: 0.192, blue: 0.357, alpha: 1)
        label.font = UIFont(name: PingFangSCMedium, size: 16)
        label.attributedText = NSMutableAttributedString(string: "活动名称", attributes: [NSAttributedString.Key.kern: 0.48])
        return label
    }()
    
    lazy var titleTextfield: UITextField = {
        let textField = UITextField()
        textField.textColor = UIColor(red: 0.082, green: 0.192, blue: 0.357, alpha: 1)
        textField.backgroundColor = UIColor(red: 0.946, green: 0.954, blue: 0.962, alpha: 1)
        textField.font = UIFont(name: PingFangSCMedium, size: 14)
        textField.layer.cornerRadius = 4
        textField.clipsToBounds = true
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 18, height: 1))
        textField.leftViewMode = .always
        textField.placeholder = "不超过12个字"
        return textField
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.082, green: 0.192, blue: 0.357, alpha: 1)
        label.font = UIFont(name: PingFangSCMedium, size: 16)
        label.attributedText = NSMutableAttributedString(string: "活动类型", attributes: [NSAttributedString.Key.kern: 0.48])
        return label
    }()
    
    lazy var typeButton: UIButton = {
        let button = UIButton()
        button.setTitle("请选择 >", for: .normal)
        button.titleLabel?.font = UIFont(name: PingFangSCMedium, size: 14)
        button.setTitleColor(UIColor(hexString: "#2921D1", alpha: 0.6), for: .normal)
        return button
    }()
    
    // MARK: - 设置子控件位置
    func setupUI() {
        
        self.coverImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview()
            make.width.equalTo(106)
            make.height.equalTo(106)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(138)
            make.top.equalToSuperview()
            make.width.equalTo(66)
            make.height.equalTo(22)
        }
        
        self.titleTextfield.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(28)
            make.left.equalTo(coverImgView.snp.right).offset(16)
            make.height.equalTo(35)
            make.width.equalTo(UIScreen.main.bounds.width - 154)
        }
        
        self.typeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(138)
            make.top.equalToSuperview().offset(77)
            make.width.equalTo(66)
            make.height.equalTo(22)
        }
        
        self.typeButton.snp.makeConstraints { make in
            make.left.equalTo(self.typeLabel.snp.right).offset(8)
            make.top.equalToSuperview().offset(78)
            make.width.equalTo(58)
            make.height.equalTo(20)
        }
        
        // 设置 UIScrollView 只能纵向滚动
        contentSize = CGSize(width: frame.width, height: frame.height + 20)
        isDirectionalLockEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(coverImgView)
        addSubview(titleLabel)
        addSubview(titleTextfield)
        addSubview(typeLabel)
        addSubview(typeButton)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
