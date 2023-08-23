//
//  UFieldActivityAddViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/21.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit



class UFieldActivityAddViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "activityBack"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
}
