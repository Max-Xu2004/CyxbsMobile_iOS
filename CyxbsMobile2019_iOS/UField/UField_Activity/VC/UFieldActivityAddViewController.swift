//
//  UFieldActivityAddViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/21.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import TOCropViewController

class UFieldActivityAddViewController: UIViewController,
                                        UIImagePickerControllerDelegate,
                                        UINavigationControllerDelegate,
                                       TOCropViewControllerDelegate,
                                        UFieldActivityTypePickerDelegate {
    
    var activity_type: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#F8F9FC"), darkColor: UIColor(hexString: "#F8F9FC"))
        view.addSubview(backButton)
        view.addSubview(scrollView)
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
    
    lazy var scrollView: UFieldActivityAddScrollView = {
        let scrollView = UFieldActivityAddScrollView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showImagePickerAlert))
        scrollView.coverImgView.addGestureRecognizer(tapGesture)
        scrollView.typeButton.addTarget(self, action: #selector(showTypePicker), for: .touchUpInside)
        return scrollView
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
            make.bottom.equalToSuperview()
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
        let pickerVC = UFieldActivityTypePickerVC()
        pickerVC.delegate = self
        pickerVC.modalPresentationStyle = .overCurrentContext
        pickerVC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 285)
        present(pickerVC, animated: true)
    }
    
    // MARK: - UFieldActivityTypePickerDelegate
    func didSelectActivityType(_ type: String) {
        print("Selected activity type: \(type)")
        // Assign the selected activity type to the variable
        activity_type = mapToActivityType(type)
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
}


