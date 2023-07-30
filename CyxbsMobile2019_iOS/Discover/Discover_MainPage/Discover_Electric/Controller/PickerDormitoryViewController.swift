//
//  PickerDormitoryViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/30.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import SnapKit

class PickerDormitoryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    typealias ReloadDataBlock = () -> Void

    var block: ReloadDataBlock?

    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        return pickerView
    }()

    lazy var bindingView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor.dm_color(withLightColor: UIColor(red: 1, green: 1, blue: 1, alpha: 1), darkColor: UIColor(red: 0, green: 0, blue: 0, alpha: 1))
        return view
    }()

    lazy var roomTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .numberPad
        textField.returnKeyType = .done
        textField.placeholder = "例如\"403\""
        if let room = UserItemTool.defaultItem().room {
            textField.text = room
        }
        textField.inputAccessoryView = addToolbar()
        textField.font = UIFont(name: PingFangSCBold, size: 24)
        textField.textColor = UIColor.dm_color(withLightColor: UIColor(red: 0.08, green: 0.2, blue: 0.36, alpha: 1), darkColor: UIColor(red: 0.37, green: 0.37, blue: 0.39, alpha: 1))
        return textField
    }()

    lazy var buildingNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "01栋"
        label.textColor = UIColor.dm_color(withLightColor: UIColor(red: 0.08, green: 0.2, blue: 0.36, alpha: 0.59), darkColor: UIColor(red: 0.94, green: 0.94, blue: 0.95, alpha: 0.59))
        label.font = UIFont(name: PingFangSCRegular, size: 15)
        return label
    }()

    lazy var checkBtn: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.28, green: 0.25, blue: 0.89, alpha: 1)
        button.setTitle("确定", for: .normal)
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(bindingDormitory), for: .touchUpInside)
        return button
    }()

    lazy var pickerDormitoryModel: PickerDormitoryModel = {
        return PickerDormitoryModel()
    }()

    var selectedArrays: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dm_color(withLightColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0), darkColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.5))
        bindingBuildingAndRoom()
    }

    // MARK: - Method
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }

    // 绑定宿舍房间号
    func bindingBuildingAndRoom() {
        // 添加灰色背景板
        let contentView = UIButton(frame: view.frame)
        view.addSubview(contentView)
        contentView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        contentView.alpha = 0
        contentView.addTarget(self, action: #selector(cancel), for: .touchUpInside)

        UIView.animate(withDuration: 0.3) {
            contentView.alpha = 1
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
        }

        contentView.addSubview(bindingView)
        bindingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(339)
        }

        bindingView.addSubview(pickerView)
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(bindingView).offset(97)
            make.left.right.equalTo(bindingView)
            make.height.equalTo(152)
        }

        let roomNumberLabel = UILabel()
        roomNumberLabel.font = UIFont(name: PingFangSCBold, size: 24)
        roomNumberLabel.text = "宿舍号："
        roomNumberLabel.textColor = UIColor.dm_color(withLightColor: UIColor(red: 0.08, green: 0.2, blue: 0.36, alpha: 1), darkColor: UIColor(red: 0.37, green: 0.37, blue: 0.39, alpha: 1))
        bindingView.addSubview(roomNumberLabel)
        roomNumberLabel.snp.makeConstraints { make in
            make.left.equalTo(bindingView).offset(14)
            make.top.equalTo(bindingView).offset(23)
        }

        bindingView.addSubview(roomTextField)
        roomTextField.snp.makeConstraints { make in
            make.left.equalTo(roomNumberLabel).offset(85)
            make.centerY.equalTo(roomNumberLabel)
            make.width.equalTo(170)
        }

        bindingView.addSubview(buildingNumberLabel)
        buildingNumberLabel.snp.makeConstraints { make in
            make.left.equalTo(roomNumberLabel)
            make.top.equalTo(roomNumberLabel.snp.bottom).offset(3)
        }

        bindingView.addSubview(checkBtn)
        checkBtn.snp.makeConstraints { make in
            make.centerX.equalTo(bindingView)
            make.bottom.equalTo(bindingView).offset(-29)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }

    @objc func textFieldDone() {
        view.endEditing(true)
    }

    @objc func bindingDormitory() {
        if let buildingText = buildingNumberLabel.text {
            let building = buildingText.replacingOccurrences(of: "栋", with: "")
            UserItemTool.defaultItem().building = building
        }

        if let roomText = roomTextField.text, !roomText.isEmpty {
            UserItemTool.defaultItem().room = roomText
        } else {
            let hud = MBProgressHUD.showAdded(to: bindingView, animated: true)
            hud?.mode = .text
            hud?.labelText = "请输入宿舍号～"
            hud?.hide(true, afterDelay: 1)
            return
        }

        reloadElectricViewIfNeeded()
        cancel()
    }

    func reloadElectricViewIfNeeded() {
        block?()
    }

    func addToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 35))
        toolbar.tintColor = .blue
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(textFieldDone))
        toolbar.items = [space, doneButton]
        return toolbar
    }

    // MARK: - UIPickerViewDelegate & UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // 返回2表明该控件只包含2列
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return pickerDormitoryModel.allArray.count
        } else {
            return pickerDormitoryModel.allArray[selectedArrays].count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return pickerDormitoryModel.placeArray[row]
        } else {
            let selectedRow = pickerView.selectedRow(inComponent: 0)
            let arr = pickerDormitoryModel.allArray[selectedRow]
            return arr[row < arr.count ? row : 0]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            // 如果滑动的是第 0 列, 刷新第 1 列
            // 在执行完这句代码之后, 会重新计算第 1 列的行数, 重新加载第 1 列的标题内容
            pickerView.reloadComponent(1)
            selectedArrays = row
            pickerView.selectRow(0, inComponent: 1, animated: true)
            // 重新加载数据
            pickerView.reloadAllComponents()
        }

        let row0 = pickerView.selectedRow(inComponent: 0)
        let row1 = pickerView.selectedRow(inComponent: 1)
        buildingNumberLabel.text = pickerDormitoryModel.getNumberOfDormitory(with: pickerDormitoryModel.placeArray[row0], and: pickerDormitoryModel.allArray[row0][row1])
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 100
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
}

