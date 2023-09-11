//
//  UFieldActivitySearchVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/9/9.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import JKSwiftExtension

class ActivitySearchVC: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(hexString: "#F2F5FA")
        view.addSubview(backButton)
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        setPosition()
    }
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "activityBack"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 1, bottom: 8, right: 22)
        button.addTarget(self, action: #selector(popController), for: .touchUpInside)
        return button
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 38))
        textField.leftViewMode = .always
        textField.placeholder = "查看更多活动..."
        let imageView = UIImageView(image: UIImage(named: "放大镜"))
        imageView.frame = CGRect(x: 14, y: 10, width: 18, height: 17)
        textField.leftView?.addSubview(imageView)
        textField.font = UIFont(name: PingFangSCMedium, size: 16)
        textField.textColor = UIColor(red: 0.082, green: 0.192, blue: 0.357, alpha: 0.4)
        textField.layer.cornerRadius = 19
        textField.clipsToBounds = true
        textField.delegate = self
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
//        button.setTitle("搜索", for: .normal)
        button.setAttributedTitle(NSMutableAttributedString(string: "搜索", attributes: [NSAttributedString.Key.kern: 0.7]), for: .normal)
        button.titleLabel?.font = UIFont(name: PingFangSCMedium, size: 14)
        button.titleLabel?.textColor = UIColor(red: 0.29, green: 0.267, blue: 0.894, alpha: 1)
        return button
    }()
    
//    lazy var searchButton: UIButton = {
//        let button = UIButton()
//        button.backgroundColor = UIColor(hexString: "#15315B", alpha: 0.05)
//        button.layer.cornerRadius = 19
//        button.setTitle("查看更多活动...", for: .normal)
//        button.titleLabel?.font = UIFont(name: PingFangSCMedium, size: 16)
//        button.setTitleColor(UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B", alpha: 0.2), darkColor: UIColor(hexString: "#15315B", alpha: 0.2)), for: .normal)
//        button.setImage(UIImage(named: "放大镜"), for: .normal)
//        button.titleEdgeInsets = UIEdgeInsets(top: 7, left: 15, bottom: 7, right: 146)
//        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 11, bottom: 11, right: 273)
//        return button
//    }()
    
    func setPosition() {
        self.backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+9)
            make.width.equalTo(30)
            make.height.equalTo(31)
        }
        
        self.searchTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(35)
            make.trailing.equalToSuperview().offset(-52)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+6)
            make.height.equalTo(38)
        }
        
        self.searchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+18)
            make.width.equalTo(36)
            make.height.equalTo(14)
        }
    }
    //返回上一级界面
    @objc func popController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return textField.jk.inputRestrictions(shouldChangeTextIn: range, replacementText: string, maxCharacters: 10, regex: nil, lenghType: .count)
    }
}
