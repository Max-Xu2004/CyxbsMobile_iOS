//
//  ActivityCenterTableViewVC.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/9/16.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class ActivityCenterTableViewVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var activities: [Activity] = []
    var titleParagraphStyle = NSMutableParagraphStyle()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleParagraphStyle.lineHeightMultiple = 0.85
        view.addSubview(tableView)
        self.tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if activities.count == 0 {
            ActivityHUD.shared.addProgressHUDView(width: 138,
                                                        height: 36,
                                                        text: "暂无更多内容",
                                                        font: UIFont(name: PingFangSCMedium, size: 13)!,
                                                        textColor: .white,
                                                        delay: 2,
                                                        view: self.view,
                                                        backGroundColor: UIColor(hexString: "#2a4e84"),
                                                        cornerRadius: 18,
                                                  yOffset: Float(-UIScreen.main.bounds.width + UIApplication.shared.statusBarFrame.height) + 78)
        }
    }
    
    //活动展示tableView
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ActivityMineTableViewCell.self, forCellReuseIdentifier: "mineCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    // UITableViewDataSource方法
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mineCell", for: indexPath) as! ActivityMineTableViewCell
        cell.coverImgView.sd_setImage(with: URL(string: activities[indexPath.item].activityCoverURL))
//        cell.titleLabel.text = activities[indexPath.item].activityTitle
        cell.titleLabel.attributedText = NSMutableAttributedString(string: activities[indexPath.item].activityTitle, attributes: [NSAttributedString.Key.paragraphStyle: titleParagraphStyle])
        cell.detailLabel.text = activities[indexPath.item].activityDetail
        cell.startTimeLabel.text = DateConvert.dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(activities[indexPath.item].activityStartAt)))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    // UITableViewDelegate方法
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了cell")
        let detailVC = ActivityDetailVC()
        detailVC.activity = activities[indexPath.row]
        detailVC.numOfIndexPath = indexPath.row
        detailVC.delegate = self
        self.navigationController?.pushViewController(detailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    struct DateConvert {
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "zh_CN")
            formatter.dateFormat = "yyyy年M月d日"
            return formatter
        }()
    }
}

//为了减少请求次数，减轻服务器压力，详情页的数据由model传过去，使用代理来实现点击想看后修改model的值
extension ActivityCenterTableViewVC: ActivityDetailVCDelegate {
    func updateModel(indexPathNum: Int, wantToWatch: Bool) {
        self.activities[indexPathNum].wantToWatch = wantToWatch
    }
}
