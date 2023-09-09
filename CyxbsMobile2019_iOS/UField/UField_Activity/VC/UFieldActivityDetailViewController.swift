//
//  UFieldActivityDetailViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/22.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire

protocol UFieldActivityDetailViewControllerDelegate: AnyObject {
    func updateModel(indexPathNum: Int, wantToWatch: Bool)
}

class UFieldActivityDetailViewController: UIViewController {
    
    var activity: Activity!
    var numOfIndexPath: Int!
    weak var delegate: UFieldActivityDetailViewControllerDelegate?
    var countdownTimer: Timer?
    var detailView: UFieldActivityDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#F8F9FC")!, darkColor: UIColor(hexString: "#F8F9FC")!, alpha: 1)
        }
        else {
            view.backgroundColor = UIColor(hexString: "##F8F9FC")
        }
        view.addSubview(backButton)
        view.addSubview(coverImgView)
        view.addSubview(statusImgView)
        view.addSubview(titleLabel)
        view.addSubview(typeImgView)
        view.addSubview(typeLabel)
        view.addSubview(activityWatchNumLabel)
        view.addSubview(wantToWatchButton)
        view.addSubview(distanceStartTimeLabel)
        view.addSubview(dayLabel)
        view.addSubview(hourLabel)
        view.addSubview(minuteLabel)
        view.addSubview(secondLabel)
        setBackGroundView()
        backGroundView1.addSubview(dayNumLabel)
        backGroundView2.addSubview(hourNumLabel)
        backGroundView3.addSubview(minuteNumLabel)
        backGroundView4.addSubview(secondNumLabel)
        setPosition()
        startCountdownTimer()
        self.wantToWatchButton.isEnabled = !(self.activity.wantToWatch ?? true)
        addDetailView()
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
    
    lazy var coverImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 8
        imgView.layer.masksToBounds = true
        imgView.sd_setImage(with: URL(string: activity.activityCoverURL))
        return imgView
    }()
    
    lazy var statusImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        if (activity.ended ?? true){
            imgView.image = UIImage(named: "activityEnded")
        } else{
            imgView.image = UIImage(named: "activityOngoing")
        }
        return imgView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#112C54")
        label.font = UIFont(name: PingFangSCBold, size: 18)
        label.text = activity.activityTitle
        return label
    }()
    
    lazy var typeImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "typeImage")
        return imgView
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#112C54", alpha: 0.4)
        label.font = UIFont(name: PingFangSCMedium, size: 14)
        switch activity.activityType {
        case "culture": label.text = "文娱活动"
        case "sports": label.text = "体育活动"
        case "education": label.text = "教育活动"
        default: break
        }
        return label
    }()
    
    lazy var activityWatchNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#2A4E84", alpha: 0.6)
        label.font = UIFont(name: PingFangSCRegular, size: 12)
        label.text = "\(activity.activityWatchNumber)人想看"
        return label
    }()
    
    lazy var wantToWatchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "wantToWatch"), for: .normal)
        button.setImage(UIImage(named: "alreadyWantToWatch"), for: .disabled)
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(wantToWatchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var distanceStartTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#15315B", alpha: 0.6)
        label.font = UIFont(name: PingFangSCMedium, size: 14)
        label.text = "距离开始还有"
        return label
    }()
    
    lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#15315B", alpha: 0.6)
        label.font = UIFont(name: PingFangSCMedium, size: 12)
        label.text = "天"
        return label
    }()
    
    lazy var hourLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#15315B", alpha: 0.6)
        label.font = UIFont(name: PingFangSCMedium, size: 12)
        label.text = "小时"
        return label
    }()
    
    lazy var minuteLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#15315B", alpha: 0.6)
        label.font = UIFont(name: PingFangSCMedium, size: 12)
        label.text = "分"
        return label
    }()
    
    lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#15315B", alpha: 0.6)
        label.font = UIFont(name: PingFangSCMedium, size: 12)
        label.text = "秒"
        return label
    }()
    
    lazy var dayNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#112C54")
        label.textAlignment = .center
        label.font = UIFont(name: PingFangSCMedium, size: 16)
        return label
    }()
    
    lazy var hourNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#112C54")
        label.textAlignment = .center
        label.font = UIFont(name: PingFangSCMedium, size: 16)
        return label
    }()
    
    lazy var minuteNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#112C54")
        label.textAlignment = .center
        label.font = UIFont(name: PingFangSCMedium, size: 16)
        return label
    }()
    
    lazy var secondNumLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hexString: "#112C54")
        label.textAlignment = .center
        label.font = UIFont(name: PingFangSCMedium, size: 16)
        return label
    }()
    
    // MARK: - 子视图布局
    func setPosition() {
        self.backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+6)
            make.width.equalTo(30)
            make.height.equalTo(31)
        }
        
        self.coverImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+52)
            make.width.equalTo(106)
            make.height.equalTo(106)
        }
        
        self.statusImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(138)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+59)
            make.width.equalTo(42)
            make.height.equalTo(18)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(138)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+78)
            make.height.equalTo(25)
        }
        
        self.typeImgView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(138)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+106)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
        
        self.typeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(163)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+106)
            make.height.equalTo(20)
        }
        
        self.activityWatchNumLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(138)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+136)
            make.height.equalTo(17)
        }
        
        self.wantToWatchButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+132)
            make.width.equalTo(70)
            make.height.equalTo(26)
        }
        
        self.distanceStartTimeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(29)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+181)
            make.height.equalTo(20)
        }
        
        self.dayLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(156)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+183)
            make.width.equalTo(12)
            make.height.equalTo(17)
        }
        
        self.hourLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(211)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+183)
            make.width.equalTo(24)
            make.height.equalTo(17)
        }
        
        self.minuteLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(278)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+183)
            make.width.equalTo(12)
            make.height.equalTo(17)
        }
        
        self.secondLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(333)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+183)
            make.width.equalTo(12)
            make.height.equalTo(17)
        }
        
        self.dayNumLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(4)
            make.width.equalTo(20)
            make.height.equalTo(22)
        }

        self.hourNumLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(4)
            make.width.equalTo(20)
            make.height.equalTo(22)
        }

        self.minuteNumLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(4)
            make.width.equalTo(20)
            make.height.equalTo(22)
        }

        self.secondNumLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(5)
            make.top.equalToSuperview().offset(4)
            make.width.equalTo(20)
            make.height.equalTo(22)
        }
    }
    
    //返回上一级界面
    @objc func popController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //想看按钮被点击
    @objc func wantToWatchButtonTapped() {
        self.wantToWatchButton.isEnabled = false
        ActivityClient.shared.request(url:"magipoke-ufield/activity/action/watch/?activity_id=\(activity.activityId)",
                                      method: .put,
                                      headers: nil,
                                      parameters: nil) { responseData in
            if let dataDict = responseData as? [String: Any],
               let jsonData = try? JSONSerialization.data(withJSONObject: dataDict),
               let wantToWatchResponseData = try? JSONDecoder().decode(wantToWatchResponse.self, from: jsonData) {
                print(wantToWatchResponseData)
                if (wantToWatchResponseData.status == 10000) {
                    UFieldActivityHUD.shared.addProgressHUDView(width: 138,
                                                                height: 36,
                                                                text: "添加成功",
                                                                font: UIFont(name: PingFangSCMedium, size: 13)!,
                                                                textColor: .white,
                                                                delay: 2,
                                                                view: self.view,
                                                                backGroundColor: UIColor(hexString: "#2a4e84"),
                                                                cornerRadius: 20.5,
                                                                yOffset: -100)
                    self.delegate?.updateModel(indexPathNum: self.numOfIndexPath, wantToWatch: true)
                } else {
                    UFieldActivityHUD.shared.addProgressHUDView(width: 138,
                                                                height: 36,
                                                                text: wantToWatchResponseData.info,
                                                                font: UIFont(name: PingFangSCMedium, size: 13)!,
                                                                textColor: .white,
                                                                delay: 2,
                                                                view: self.view,
                                                                backGroundColor: UIColor(hexString: "#2a4e84"),
                                                                cornerRadius: 20.5,
                                                                yOffset: -100)
                }
            }
        } failure: { responseData in
            print(responseData)
        }
    }
    
    // MARK: - 开始计时器以及倒计时更新
    func startCountdownTimer() {
        // 首次立即更新倒计时显示
        updateCountdownLabel()
        // 创建定时器，每秒更新一次倒计时显示
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountdownLabel), userInfo: nil, repeats: true)
    }
    
    @objc func updateCountdownLabel() {
        let currentTimeStamp = Date().timeIntervalSince1970
        var timeRemaining: Double
        if (TimeInterval(activity.activityStartAt) - currentTimeStamp >= 0) {
            timeRemaining = max(0, TimeInterval(activity.activityStartAt) - currentTimeStamp)
        } else {
            timeRemaining = max(0, TimeInterval(activity.activityEndAt) - currentTimeStamp)
            distanceStartTimeLabel.text = "距离结束还有"
        }
        let days = Int(timeRemaining) / 86400
        let hours = (Int(timeRemaining) % 86400) / 3600
        let minutes = (Int(timeRemaining) % 3600) / 60
        let seconds = Int(timeRemaining) % 60
        
        dayNumLabel.text = String(format: "%d", days)
        hourNumLabel.text = String(format: "%d", hours)
        minuteNumLabel.text = String(format: "%d", minutes)
        secondNumLabel.text = String(format: "%d", seconds)
        if timeRemaining <= 0 {
            // 倒计时结束，停止定时器
            countdownTimer?.invalidate()
            countdownTimer = nil
            setEndedView()
        }
    }
    
    // MARK: - 设置倒计时后面的灰色背景
    var backGroundView1: UIView!
    var backGroundView2: UIView!
    var backGroundView3: UIView!
    var backGroundView4: UIView!
    
    func setBackGroundView() {
        backGroundView1 = createTimeLabelBackGroundView()
        backGroundView2 = createTimeLabelBackGroundView()
        backGroundView3 = createTimeLabelBackGroundView()
        backGroundView4 = createTimeLabelBackGroundView()
        view.addSubview(backGroundView1)
        view.addSubview(backGroundView2)
        view.addSubview(backGroundView3)
        view.addSubview(backGroundView4)
        
        backGroundView1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(123)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+176)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        backGroundView2.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(178)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+176)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        backGroundView3.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(245)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+176)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        backGroundView4.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(300)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+176)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
    }
    
    func createTimeLabelBackGroundView() -> UIView {
        let customView = UIView()
        customView.backgroundColor = UIColor(hexString: "#ECEEF2")
        customView.layer.cornerRadius = 4
        return customView
    }
    
    // MARK: - 详情页的初始化和重载
    func addDetailView() {
        detailView = UFieldActivityDetailView()
        view.addSubview(detailView)
        detailView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().offset(271)
            make.bottom.equalToSuperview()
        }
        detailView.commonInit()
        detailView.organizerLabel.text = activity.activityOrganizer
        detailView.creatorLabel.text = activity.activityCreator
        detailView.registrationLabel.text = activity.activityRegistrationType
        detailView.placeLabel.text = activity.activityPlace
        detailView.startTimeLabel.text = formatTimestamp(timestamp: activity.activityStartAt)
        detailView.endTimeLabel.text = formatTimestamp(timestamp: activity.activityEndAt)
        detailView.detailLabel.text = activity.activityDetail
    }
    
    func reinitializeDetailView() {
        detailView.removeFromSuperview()
        detailView = nil
        addDetailView()
    }
    
    // MARK: - 倒计时结束修改子视图样式
    func setEndedView() {
        backGroundView1.removeFromSuperview()
        backGroundView2.removeFromSuperview()
        backGroundView3.removeFromSuperview()
        backGroundView4.removeFromSuperview()
        distanceStartTimeLabel.removeFromSuperview()
        dayLabel.removeFromSuperview()
        hourLabel.removeFromSuperview()
        minuteLabel.removeFromSuperview()
        secondLabel.removeFromSuperview()
        dayNumLabel.removeFromSuperview()
        hourNumLabel.removeFromSuperview()
        minuteNumLabel.removeFromSuperview()
        secondNumLabel.removeFromSuperview()
        let endLabel = UILabel()
        endLabel.textColor = UIColor(red: 0.082, green: 0.192, blue: 0.357, alpha: 0.8)
        endLabel.font = UIFont(name: PingFangSCMedium, size: 16)
        endLabel.text = "活动已结束"
        endLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+179)
            make.width.equalTo(80)
            make.height.equalTo(22)
        }
        view.addSubview(endLabel)
    }
    
    // MARK: - 时间戳转换为显示的字符串
    func formatTimestamp(timestamp: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年M月d日HH点mm分"
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}



