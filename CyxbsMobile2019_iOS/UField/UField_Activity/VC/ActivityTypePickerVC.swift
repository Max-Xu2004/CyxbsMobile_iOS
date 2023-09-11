//
//  UFieldActivityTypePickerVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/27.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

protocol ActivityTypePickerDelegate: AnyObject {
    func didSelectActivityType(_ type: String)
}

class ActivityTypePickerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    weak var delegate: ActivityTypePickerDelegate?
    
    let activityTypes = ["文娱活动", "体育活动", "教育活动"]
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView(frame: CGRectMake(0, 0, UIScreen.main.bounds.width, 200))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = false
        return pickerView
    }()
    
    var contentView: UIView!
    var backgroundView: UIView!
    var confirmButton: UIButton!
    var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        setView()
        // Add pickerView to the view
        contentView.addSubview(pickerView)
        confirmButton = GradientButton(frame: CGRectMake((UIScreen.main.bounds.width - 120)/2, 203, 120, 40))
        confirmButton.setTitle("确定", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: PingFangSCBold, size: 18)
        confirmButton.titleLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        confirmButton.layer.cornerRadius = 20
        contentView.addSubview(confirmButton)
        confirmButton.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        cancelButton = UIButton(frame: CGRectMake(UIScreen.main.bounds.width - 42, 15, 28, 20))
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: PingFangSCMedium, size: 12)
        cancelButton.setTitleColor(UIColor(red: 0.671, green: 0.71, blue: 0.769, alpha: 1), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        contentView.addSubview(cancelButton)
        let indicatorImgView = UIImageView(frame: CGRectMake(52, 96, 6, 8))
        indicatorImgView.image = UIImage(named: "指示标")
        contentView.addSubview(indicatorImgView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentView.transform = CGAffineTransform(translationX: 0, y: 285)
        contentView.transform = CGAffineTransform(translationX: 0, y: 285)
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = .identity
        }
    }
    
    func setView() {
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.47)
        contentView = UIView()
        contentView.backgroundColor = .white
        contentView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 285, width: UIScreen.main.bounds.width, height: 285)
        contentView.layer.cornerRadius = 20
        view.addSubview(contentView)
        backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 285))
        backgroundView.backgroundColor = .clear
        view.addSubview(backgroundView)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelButtonTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc func cancelButtonTapped() {
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = .identity
            self.contentView.frame.origin.y = self.view.frame.height
        } completion: { _ in
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @objc func confirmButtonTapped() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let selectedType = activityTypes[selectedRow]
        delegate?.didSelectActivityType(selectedType)
        UIView.animate(withDuration: 0.3) {
            self.contentView.transform = .identity
            self.contentView.frame.origin.y = self.view.frame.height
        } completion: { _ in
            // After the animation completes, remove contentView from the view hierarchy
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    

    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activityTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        self.pickerView.subviews[1].backgroundColor = .clear //去除选中行默认的灰色背景
        let label = UILabel()
        label.text = activityTypes[row]
        label.textColor = UIColor(red: 0.082, green: 0.192, blue: 0.357, alpha: 1)
        label.textAlignment = .center
        label.font = UIFont(name: PingFangSCBold, size: 20)
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 50 // Adjust the row height as needed
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activityTypes[row]
    }
    
}




