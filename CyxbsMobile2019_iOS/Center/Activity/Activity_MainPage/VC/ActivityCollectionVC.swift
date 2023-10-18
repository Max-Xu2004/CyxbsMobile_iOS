//
//  UFieldActivityCollectionViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/16.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import MJRefresh

class ActivityCollectionVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView!
    var activities: [Activity] = []
    var collectionViewCount: Int = 0
    let refreshNum: Int = 10
    var cellWidth: CGFloat!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // 创建一个UICollectionViewFlowLayout实例作为集合视图的布局
        let layout = UICollectionViewFlowLayout()
        //计算cell的宽度
        cellWidth = (self.view.bounds.width - 41) / 2
        // 设置单元格之间的水平间距
        layout.minimumInteritemSpacing = 9
        // 设置单元格之间的垂直间距
        layout.minimumLineSpacing = layout.minimumInteritemSpacing
        // 计算每行的内边距，以保证单元格居中显示
//        let totalCellWidth = 167 * 2 + layout.minimumInteritemSpacing
//        let inset = (self.view.bounds.width - CGFloat(totalCellWidth)) / 2
        layout.sectionInset = UIEdgeInsets(top: 2, left: 16, bottom: 10, right: 16)
        // 使用上述布局创建一个UICollectionView实例，将其框架设置为与当前视图大小相同
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(ActivityCollectionViewCell.self, forCellWithReuseIdentifier: ActivityCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.frame = self.view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActivityCollectionViewCell.reuseIdentifier, for: indexPath) as! ActivityCollectionViewCell
        cell.titleLabel.text = activities[indexPath.item].activityTitle
        cell.coverImgView.sd_setImage(with: URL(string: activities[indexPath.item].activityCoverURL))
        cell.startTimeLabel.text = DateConvert.dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(activities[indexPath.item].activityStartAt)))
        switch activities[indexPath.item].activityType {
        case "culture": cell.activityTypeLabel.text = "文娱活动"
        case "sports": cell.activityTypeLabel.text = "体育活动"
        case "education": cell.activityTypeLabel.text = "教育活动"  
        default: break
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: 237)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = ActivityDetailVC()
        detailVC.activity = activities[indexPath.item]
        detailVC.numOfIndexPath = indexPath.item
        detailVC.delegate = self
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    struct DateConvert {
        static let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "zh_CN")
            formatter.dateFormat = "yyyy年M月d日"
            return formatter
        }()
    }
    
    func addMJFooter() {
        let footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(refreshCollectionView))
        footer.setTitle("", for: .idle)
        footer.setTitle("正在加载...", for: .refreshing)
        footer.setTitle("已经加载到最底部", for: .noMoreData)
        footer.stateLabel?.textColor = UIColor(red: 0.082, green: 0.192, blue: 0.357, alpha: 0.3)
        collectionView.mj_footer = footer
    }
    
    @objc func refreshCollectionView() {
        if self.collectionViewCount != self.activities.count {
            self.collectionViewCount = self.collectionViewCount + self.refreshNum
            if self.collectionViewCount > self.activities.count {
                self.collectionViewCount = self.activities.count
            }
            //延迟加载新的cell
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.collectionView.mj_footer?.endRefreshing()
                self.collectionView.reloadData()
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // 要延迟执行的代码
                if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
//                    self.collectionView.mj_footer?.isHidden = true
                    self.collectionView.mj_footer?.endRefreshingWithNoMoreData()
                    ActivityHUD.shared.addProgressHUDView(width: 138,
                                                                height: 36,
                                                                text: "暂无更多内容",
                                                                font: UIFont(name: PingFangSCMedium, size: 13)!,
                                                                textColor: .white,
                                                                delay: 2,
                                                                view: window,
                                                                backGroundColor: UIColor(hexString: "#2a4e84"),
                                                                cornerRadius: 18,
                                                                yOffset: Float(-UIScreen.main.bounds.height * 0.5 + UIApplication.shared.statusBarFrame.height) + 90)
                }
            }
        }
    }
}

//为了减少请求次数，减轻服务器压力，详情页的数据由model传过去，使用代理来实现点击想看后修改model的值
extension ActivityCollectionVC: ActivityDetailVCDelegate {
    func updateModel(indexPathNum: Int, wantToWatch: Bool) {
        self.activities[indexPathNum].wantToWatch = wantToWatch
    }
}



