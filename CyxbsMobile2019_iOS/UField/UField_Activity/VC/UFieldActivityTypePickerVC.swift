//
//  UFieldActivityTypePickerVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/27.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

protocol UFieldActivityTypePickerDelegate: AnyObject {
    func didSelectActivityType(_ type: String)
}

class UFieldActivityTypePickerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    weak var delegate: UFieldActivityTypePickerDelegate?
    
    let activityTypes = ["文娱活动", "体育活动", "教育活动"]
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        let contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 285, width: UIScreen.main.bounds.width, height: 285)
        contentView.layer.cornerRadius = 20
        view.addSubview(contentView)
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 285))
        backgroundView.backgroundColor = .clear
        view.addSubview(backgroundView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelButtonTapped))
        backgroundView.addGestureRecognizer(tapGesture)
        // Add pickerView to the view
        contentView.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.height.equalTo(185)
            make.bottom.equalToSuperview().offset(-100)
            make.leading.trailing.equalToSuperview()
        }
        
        let confirmButton = UIButton()
        confirmButton.layer.cornerRadius = 20
        confirmButton.backgroundColor = .blue
        contentView.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-42)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
        
//        // Add buttons
//        let cancelButton = UIButton(type: .system)
//        cancelButton.setTitle("取消", for: .normal)
//        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
//
//        let confirmButton = UIButton(type: .system)
//        confirmButton.setTitle("确认", for: .normal)
//        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
//
//        let buttonsStackView = UIStackView(arrangedSubviews: [cancelButton, confirmButton])
//        buttonsStackView.axis = .horizontal
//        buttonsStackView.spacing = 20
//        buttonsStackView.alignment = .center
//        buttonsStackView.distribution = .fillEqually
//
//        view.addSubview(buttonsStackView)
//        buttonsStackView.snp.makeConstraints { make in
//            make.top.equalTo(pickerView.snp.bottom)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmButtonTapped() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedType = activityTypes[selectedRow]
        delegate?.didSelectActivityType(selectedType)
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activityTypes.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activityTypes[row]
    }
}

