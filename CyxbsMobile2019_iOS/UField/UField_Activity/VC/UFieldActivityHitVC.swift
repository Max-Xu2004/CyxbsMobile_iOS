//
//  UFieldActivityHitVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/9/3.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class UFieldActivityHitVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var hitActivities: [Activity] = []
    var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(backButton)
        view.addSubview(topImgView)
        setContentView()
        contentView.addSubview(tableView)
        setPosition()
        tableView.dataSource = self
        tableView.delegate = self
        requestHitActivity()
    }
    
    // 返回按钮
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "whiteBack"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(popController), for: .touchUpInside)
        return button
    }()
    
    //顶部“排行榜”字样图片
    lazy var topImgView: UIImageView = {
        let imageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.main.bounds.width, 198))
        imageView.image = UIImage(named: "排行榜")
        return imageView
    }()
    
    //排行榜tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 26, UIScreen.main.bounds.width, UIScreen.main.bounds.height-210))
        tableView.register(UFieldActivityHitTableViewCell.self, forCellReuseIdentifier: "hitCell")
        tableView.separatorStyle = .none
        return tableView
    }()
    //返回上一个vc
    @objc func popController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setContentView() {
        contentView = UIView()
        contentView.frame = CGRectMake(0, 184, UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 18
        view.addSubview(contentView)
        let shadowPath0 = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 18)
        let layer0 = CALayer()
        layer0.shadowPath = shadowPath0.cgPath
        layer0.shadowColor = UIColor(red: 0.176, green: 0.325, blue: 0.553, alpha: 0.03).cgColor
        layer0.shadowOpacity = 1
        layer0.shadowRadius = 101
        layer0.shadowOffset = CGSize(width: 0, height: 13)
        layer0.bounds = contentView.bounds
        layer0.position = contentView.center
        contentView.layer.addSublayer(layer0)
    }
    
    // MARK: - 设置子视图位置
    func setPosition() {
        // 返回按钮
        self.backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(17)
            make.top.equalToSuperview().offset(UIApplication.shared.statusBarFrame.height+13)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        //返回按钮图片
        self.backButton.imageView?.snp.makeConstraints { make in
            make.leading.equalTo(self.backButton)
            make.width.equalTo(7)
            make.height.equalTo(16)
            make.centerY.equalTo(self.backButton)
        }
    }
    
    func requestHitActivity() {
        let parameters: Parameters = [
            "activity_type": "all",
            "order_by": "watch",
            "activity_num": "50"
        ]
        ActivityClient.shared.request(url: "magipoke-ufield/activity/search/",
                                      method: .get,
                                      headers: nil,
                                      parameters: parameters) { responseData in
            print(responseData as Any)
            if let dataDict = responseData as? [String: Any],
            let jsonData = try? JSONSerialization.data(withJSONObject: dataDict),
            let hitActivityResponseData = try? JSONDecoder().decode(SearchActivityResponse.self, from: jsonData) {
                for activity in hitActivityResponseData.data {
                    self.hitActivities.append(activity)
                }
                print(self.hitActivities)
                print(self.hitActivities.count)
                self.tableView.reloadData()
            } else {
                print("Invalid response data")
            }
        }
    }
    // UITableViewDataSource方法
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hitCell", for: indexPath) as! UFieldActivityHitTableViewCell
        cell.coverImgView.sd_setImage(with: URL(string: hitActivities[indexPath.item].activityCoverURL))
        cell.titleLabel.text = hitActivities[indexPath.item].activityTitle
        cell.rankingLabel.text = "\(indexPath.item + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hitActivities.count
    }
}
