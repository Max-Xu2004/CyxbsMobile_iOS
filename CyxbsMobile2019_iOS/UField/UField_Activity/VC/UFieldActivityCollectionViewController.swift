//
//  UFieldActivityCollectionViewController.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/8/16.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class UFieldActivityCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var collectionView: UICollectionView!
    let activities = [
        ("image1", "活动1", "文娱活动", "08:00 AM"),
        ("image2", "活动2", "体育活动", "10:00 AM"),
        ("image3", "活动3", "教育活动", "02:00 PM"),
        ("image4", "活动4", "文娱活动", "05:00 PM"),
        ("image4", "活动4", "文娱活动", "05:00 PM"),
        ("image4", "活动4", "文娱活动", "05:00 PM"),
        ("image4", "活动4", "文娱活动", "05:00 PM"),
        ("image4", "活动4", "文娱活动", "05:00 PM"),
        ("image4", "活动4", "文娱活动", "05:00 PM"),
        ("image4", "活动4", "文娱活动", "05:00 PM"),
        ("image4", "活动4", "文娱活动", "05:00 PM"),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(UFieldActivityCollectionViewCell.self, forCellWithReuseIdentifier: UFieldActivityCollectionViewCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return activities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UFieldActivityCollectionViewCell.reuseIdentifier, for: indexPath) as! UFieldActivityCollectionViewCell
        let (imageName, title, activityType, startTime) = activities[indexPath.item]
        cell.coverImgView.image = UIImage(named: imageName)
        cell.titleLabel.text = title
        cell.activityTypeLabel.text = activityType
        cell.startTimeLabel.text = startTime
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 30) / 2
        return CGSize(width: cellWidth, height: 200)
    }
}

