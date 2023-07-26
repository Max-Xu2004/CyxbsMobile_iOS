//
//  TestCardTableViewCell.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class TestCardTableViewCell: UITableViewCell {
    var weekTimeLabel: UILabel?
    var leftDayLabel: UILabel?
    var bottomView: UIView?
    var subjectLabel: UILabel?
    var clockImage: UIImageView?
    var locationImage: UIImageView?
    var testNatureLabel: UILabel?
    var dayLabel: UILabel?
    var timeLabel: UILabel?
    var classLabel: UILabel?
    var seatNumLabel: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        if #available(iOS 11.0, *) {
            backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#F8F9FC")!, darkColor: UIColor(hexString: "#000101")!, alpha: 1)
        }
        else {
            backgroundColor = UIColor(hexString: "#F8F9FC")
        }
        
        addWeekTimeLabel()
        addLeftDayLabel()
        addBottomView()
        addSubjectLabel()
        addClockImage()
        addLocationImage()
        addTestNatureLabel()
        addDayLabel()
        addTimeLabel()
        addClassLabel()
        addSeatNumLabel()
    }
    
    private func addWeekTimeLabel() {
        let label = UILabel()
        label.text = "十一周周一"
        label.font = UIFont(name: "PingFangSC-Bold", size: 15)
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#F0F0F2")!, alpha: 1)
        } else {
            label.textColor = UIColor(red: 21/255.0, green: 49/255.0, blue: 91/255.0, alpha: 1)
        }
        weekTimeLabel = label
        contentView.addSubview(label)
    }
    
    private func addLeftDayLabel() {
        let label = UILabel()
        label.text = "还剩5天考试"
        label.font = UIFont(name: "PingFangSC-Regular", size: 13)
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#3A39D3")!, darkColor: UIColor(hexString: "#0BCCF0")!, alpha: 1)
        }
        else {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#3A39D3")!, darkColor: UIColor(hexString: "#0BCCF0")!, alpha: 1)
        }
        leftDayLabel = label
        contentView.addSubview(label)
    }
    
    private func addBottomView() {
        let backgroundView = UIView()
        bottomView = backgroundView
        
        if #available(iOS 11.0, *) {
            backgroundView.backgroundColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#E8F1FC")!, darkColor: UIColor(hexString: "#3A3A3A")!, alpha: 1)
        }
        else {
            backgroundView.backgroundColor = UIColor(red: 232/255.0, green: 241/255.0, blue: 252/255.0, alpha: 0.7)
        }
        backgroundView.layer.cornerRadius = 16
        backgroundView.clipsToBounds = true
        contentView.addSubview(backgroundView)
    }
    
    private func addSubjectLabel() {
        let label = UILabel()
        label.text = "大学物理"
        label.font = UIFont(name: "PingFangSC-Semibold", size: 18)
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#F0F0F2")!, alpha: 1)
        }
        else {
            label.textColor = UIColor(red: 21/255.0, green: 49/255.0, blue: 91/255.0, alpha: 1)
        }
        subjectLabel = label
        contentView.addSubview(label)
    }
    
    private func addClockImage() {
        let clockImageView = UIImageView()
        clockImage = clockImageView
        clockImageView.image = UIImage(named: "nowClassTime") // 从课表那边拿过来用的图片
        contentView.addSubview(clockImageView)
    }
    
    private func addLocationImage() {
        let locationImageView = UIImageView()
        locationImage = locationImageView
        locationImageView.image = UIImage(named: "nowLocation") // 从课表那边拿过来用的图片
        contentView.addSubview(locationImageView)
    }
    
    private func addTestNatureLabel() {
        let label = UILabel()
        label.text = "半期"
        label.font = UIFont(name: "PingFangSCRegular", size: 13)
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#F0F0F2")!, alpha: 1)
        }
        else {
            label.textColor = UIColor(red: 21/255.0, green: 49/255.0, blue: 91/255.0, alpha: 1)
        }
        testNatureLabel = label
        contentView.addSubview(label)
    }
    
    private func addDayLabel() {
        let label = UILabel()
        label.text = "11月8号"
        label.font = UIFont(name: "PingFangSC-Regular", size: 13)

        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#EFEFF1")!, alpha: 1)
        }
        else {
            label.textColor = UIColor(red: 21/255.0, green: 49/255.0, blue: 91/255.0, alpha: 0.59)
        }
        dayLabel = label
        contentView.addSubview(label)
    }
    
    private func addTimeLabel() {
        let label = UILabel()
        label.text = "14:00 - 16:00"
        label.font = UIFont(name: "PingFangSC-Regular", size: 13)
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#EFEFF1")!, alpha: 1)
        }
        else {
            label.textColor = UIColor(red: 21/255.0, green: 49/255.0, blue: 91/255.0, alpha: 0.59)
        }
        timeLabel = label
        contentView.addSubview(label)
    }
    
    private func addClassLabel() {
        let label = UILabel()
        label.text = "3402"
        label.font = UIFont(name: "PingFangSC-Regular", size: 13)
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#EFEFF1")!, alpha: 1)
        } else {
            label.textColor = UIColor(red: 21/255.0, green: 49/255.0, blue: 91/255.0, alpha: 0.59)
        }
        classLabel = label
        contentView.addSubview(label)
    }
    
    private func addSeatNumLabel() {
        let label = UILabel()
        label.text = "58号"
        label.font = UIFont(name: "PingFangSC-Regular", size: 13)
        if #available(iOS 11.0, *) {
            label.textColor = UIColor.dm_color(withLightColor: UIColor(hexString: "#15315B")!, darkColor: UIColor(hexString: "#EFEFF1")!, alpha: 1)
        } else {
            label.textColor = UIColor(red: 21/255.0, green: 49/255.0, blue: 91/255.0, alpha: 0.59)
        }
        seatNumLabel = label
        contentView.addSubview(label)
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()

            if let weekTimeLabel = weekTimeLabel {
                weekTimeLabel.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(10)
                    make.top.equalToSuperview()
                }
            }

            if let leftDayLabel = leftDayLabel {
                leftDayLabel.snp.makeConstraints { make in
                    make.right.equalToSuperview().offset(-11)
                    make.centerY.equalTo(weekTimeLabel!)
                }
            }

            if let bottomView = bottomView {
                bottomView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.height.equalTo(113)
                    make.top.equalTo(weekTimeLabel!.snp.bottom).offset(7)
                }
            }

            if let subjectLabel = subjectLabel {
                subjectLabel.snp.makeConstraints { make in
                    make.left.equalTo(bottomView!).offset(23)
                    make.top.equalTo(bottomView!).offset(15)
                }
            }

            if let testNatureLabel = testNatureLabel {
                testNatureLabel.snp.makeConstraints { make in
                    make.centerY.equalTo(subjectLabel!)
                    make.right.equalTo(bottomView!).offset(-18)
                }
            }

            if let clockImage = clockImage {
                clockImage.snp.makeConstraints { make in
                    make.left.equalTo(subjectLabel!)
                    make.width.height.equalTo(11)
                    make.top.equalTo(subjectLabel!.snp.bottom).offset(10)
                }
            }

            if let locationImage = locationImage {
                locationImage.snp.makeConstraints { make in
                    make.left.width.height.equalTo(clockImage!)
                    make.top.equalTo(clockImage!.snp.bottom).offset(16)
                }
            }

            if let dayLabel = dayLabel {
                dayLabel.snp.makeConstraints { make in
                    make.left.equalTo(clockImage!.snp.right).offset(10)
                    make.centerY.equalTo(clockImage!)
                }
            }

            if let timeLabel = timeLabel {
                timeLabel.snp.makeConstraints { make in
                    make.left.equalTo(dayLabel!.snp.right).offset(18)
                    make.centerY.equalTo(dayLabel!)
                }
            }

            if let classLabel = classLabel {
                classLabel.snp.makeConstraints { make in
                    make.left.equalTo(dayLabel!)
                    make.centerY.equalTo(locationImage!)
                }
            }

            if let seatNumLabel = seatNumLabel {
                seatNumLabel.snp.makeConstraints { make in
                    make.left.equalTo(classLabel!.snp.right).offset(18)
                    make.centerY.equalTo(classLabel!)
                }
            }
        }
}

