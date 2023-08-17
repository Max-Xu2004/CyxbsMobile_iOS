//
//  UFieldActivitySelectBar.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/14.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class UFieldActivitySelectBar: UIView {
    var buttons: [RadioButton] = []
    var selectedCategory: String = "all" {
        didSet {
            print("Selected Category: \(selectedCategory)")
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setupButtons()
        setupRadioGroup()
        selectedCategory = "all" // 默认设置为 "all"
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
        setupButtons()
        setupRadioGroup()
        selectedCategory = "all" // 默认设置为 "all"
    }

    private func setupButtons() {
        let titles = ["全部", "文娱活动", "体育活动", "教育活动"]

        for (index, title) in titles.enumerated() {
            let button = RadioButton()
            button.setTitle(title, for: .normal)
            button.tag = index // Set tag to identify the button
            addSubview(button)
            buttons.append(button)
            if index == 0 {
                button.isSelected = true // 默认选中 "全部" 按钮
            }
        }
    }

    private func setupRadioGroup() {
        for button in buttons {
            button.addTarget(self, action: #selector(handleRadioButtonTap(_:)), for: .touchUpInside)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let buttonWidth: CGFloat = 75
        let buttonHeight: CGFloat = 40
        let spacing: CGFloat = (bounds.width - 4 * buttonWidth) / 5  // Total spacing divided by 5 to get equal spacing between buttons

        var xOffset: CGFloat = spacing

        for button in buttons {
            button.frame = CGRect(x: xOffset, y: (bounds.height - buttonHeight) / 2, width: buttonWidth, height: buttonHeight)
            xOffset += buttonWidth + spacing
        }
    }

    @objc private func handleRadioButtonTap(_ sender: RadioButton) {
        for button in buttons {
            button.isSelected = (button == sender)
        }

        switch sender.tag {
        case 0:
            selectedCategory = "all"
        case 1:
            selectedCategory = "culture"
        case 2:
            selectedCategory = "sports"
        case 3:
            selectedCategory = "education"
        default:
            break
        }
    }
}

class RadioButton: UIButton {
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .blue : .white
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        setTitleColor(.black, for: .normal)
        setTitleColor(.white, for: .selected)
        titleLabel?.font = UIFont(name: PingFangSCMedium, size: 15)
        // 设置圆角和描边
        layer.cornerRadius = 10 // 调整圆角的大小
        layer.borderWidth = 0.5   // 描边的宽度
        layer.borderColor = UIColor.gray.cgColor // 描边的颜色
        backgroundColor = .white
    }
}

