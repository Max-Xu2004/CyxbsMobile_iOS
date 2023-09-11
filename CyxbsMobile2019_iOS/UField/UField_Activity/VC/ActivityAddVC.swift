//
//  UFieldActivityAddViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/21.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import TOCropViewController

class ActivityAddVC: UIViewController,
                                        UIImagePickerControllerDelegate,
                                        UINavigationControllerDelegate,
                                       TOCropViewControllerDelegate,
                                        ActivityTypePickerDelegate,
                                       ActivityDatePickerDelegate {
    
    
    var activity_type: String?
    var startTime: Date?
    var endTime: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#F8F9FC"), darkColor: UIColor(hexString: "#F8F9FC"))
        view.addSubview(backButton)
        view.addSubview(scrollView)
        view.addSubview(confirmButton)
        setPosition()
    }
    
    // MARK: - 懒加载
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "activityBack"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 1, bottom: 8, right: 22)
        button.addTarget(self, action: #selector(popController), for: .touchUpInside)
        return button
    }()
    
    lazy var scrollView: ActivityAddScrollView = {
        let scrollView = ActivityAddScrollView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImagePickerAlert))
        scrollView.coverImgView.addGestureRecognizer(tapGesture)
        scrollView.typeButton.addTarget(self, action: #selector(showTypePicker), for: .touchUpInside)
        let startTimeLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(setStartTime))
        scrollView.startTimeLabel.addGestureRecognizer(startTimeLabelTapGesture)
        scrollView.startTimeLabel.isUserInteractionEnabled = true
        let endTimeLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(setEndTime))
        scrollView.endTimeLabel.addGestureRecognizer(endTimeLabelTapGesture)
        scrollView.endTimeLabel.isUserInteractionEnabled = true
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: 650)
        return scrollView
    }()
    
    lazy var confirmButton: UIButton = {
        let button = GradientButton()
        button.frame = CGRectMake((UIScreen.main.bounds.width - 315)/2, UIScreen.main.bounds.height - 86, 315, 51)
        button.setTitle("创建活动", for: .normal)
        button.titleLabel?.textColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        button.layer.cornerRadius = 25.5
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - 设置子控件位置
    func setPosition() {
        self.backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+6)
            make.width.equalTo(30)
            make.height.equalTo(31)
        }
        
        self.scrollView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(12)
            make.bottom.equalToSuperview().offset(-96)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
    }
    
    // MARK: - 返回上一页
    @objc func popController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //
    @objc func showImagePickerAlert(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false // 禁用系统自带编辑功能
        imagePicker.modalPresentationStyle = .fullScreen
        
        let alert = UIAlertController(title: "请选择照片来源", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "相机", style: .default) { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                imagePicker.cameraDevice = .rear
                imagePicker.showsCameraControls = true
                self.present(imagePicker, animated: true, completion: nil)
            } else {
                print("相机不可用")
            }
        }
        
        let photoLibraryAction = UIAlertAction(title: "相册", style: .default) { action in
            imagePicker.sourceType = .photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(photoLibraryAction)
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            showCropViewController(image: pickedImage) // 直接调用 showCropViewController 方法
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - TOCropViewControllerDelegate
    
    func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
        cropViewController.dismiss(animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropViewController.dismiss(animated: true, completion: nil)
        scrollView.coverImgView.image = image
    }
    
    // MARK: - 展示TOCropViewController裁剪图片
    @objc func showCropViewController(image: UIImage) {
        let cropViewController = TOCropViewController(image: image)
        cropViewController.delegate = self
        cropViewController.aspectRatioLockEnabled = true
        cropViewController.aspectRatioPreset = .presetSquare // 设置裁剪比例为1:1
        cropViewController.resetAspectRatioEnabled = false // 禁用切换比例功能
        cropViewController.aspectRatioPickerButtonHidden = true // 隐藏比例选择按钮
        present(cropViewController, animated: true)
    }
    
    @objc func showTypePicker() {
        let pickerVC = ActivityTypePickerVC()
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .overCurrentContext
        present(pickerVC, animated: false)
    }
    
    // MARK: - ActivityTypePickerDelegate
    func didSelectActivityType(_ type: String) {
        print("Selected activity type: \(type)")
        // Assign the selected activity type to the variable
        activity_type = mapToActivityType(type)
        scrollView.typeButton.setTitle(type, for: .normal)
    }
    
    func mapToActivityType(_ type: String) -> String {
        switch type {
        case "文娱活动":
            return "culture"
        case "体育活动":
            return "sports"
        case "教育活动":
            return "education"
        default:
            return ""
        }
    }
    
    @objc func setStartTime() {
        let dateVC = ActivityDatePickerVC()
        if let minDate = self.startTime {
            dateVC.minDate = minDate
        }
        dateVC.modalPresentationStyle = .overCurrentContext
        dateVC.timeSelection = .startTime
        dateVC.delegate = self
        present(dateVC, animated: false)
    }
    
    @objc func setEndTime() {
        let dateVC = ActivityDatePickerVC()
        if let minDate = self.startTime {
            dateVC.minDate = minDate
        }
        if let minDate = self.endTime {
            dateVC.minDate = minDate
        }
        dateVC.modalPresentationStyle = .overCurrentContext
        dateVC.timeSelection = .endTime
        dateVC.delegate = self
        present(dateVC, animated: false)
    }
    
    func didSelectStartTime(date: Date) {
        startTime = date
        scrollView.startTimeLabel.text = formatDateToCustomString(date: date)
    }
    
    func didSelectEndTime(date: Date) {
        endTime = date
        scrollView.endTimeLabel.text = formatDateToCustomString(date: date)
    }
    
    func formatDateToCustomString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh_CN") // 使用中文环境
        dateFormatter.dateFormat = "yyyy年M月d日H点m分"
        return dateFormatter.string(from: date)
    }
}


