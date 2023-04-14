//
//  ScheduleFetchData.swift
//  CyxbsWidgetExtension
//
//  Created by SSR on 2023/1/1.
//  Copyright © 2023 Redrock. All rights reserved.
//

import Foundation

class ScheduleFetchData: ScheduleMapModel {
    
    /* PartItem
     * 为了支持ForEach语法，以及MVVM架构
     * 提供 `点` 与 `模型` 共同在一起
     */
    struct PartItem: Identifiable {
        var indexPath: NSIndexPath
        var viewModel: ScheduleCollectionViewModel
        var id: IndexPath { indexPath as IndexPath }
    }
    
    /* data
     * ForEach该data，得到需要展示的所有模型
     */
    var data = [PartItem]()
    
    /* range
     * 得到需要展示的range范围，[1,12]之间
     */
    var range: Range<Int>
    
    /* section
     * 得到需要展示的周数，这里必须填写
     */
    var section: Int {
        if let section = trueSection {
            if section >= 23 || section < 0 {
                return 0
            } else {
                return section
            }
        } else {
            if let begin = exp {
                return Int(Date().timeIntervalSince(Date(timeIntervalSince1970: begin)) / (7.0 * 24 * 60 * 60) + 0.5) + 1
            } else {
                return 0
            }
        }
    }
    private var trueSection: Int?
    
    /* exp
     * 为了计算具体日期而使用，与start配对使用
     */
    private var exp: TimeInterval?
    
    /* start
     * 计算属性，根据beginTime而计算出真正的开始时间
     * nil则为不存在开始时间
     */
    var start: Date? {
        if let begin = exp {
            return Date(timeIntervalSince1970: begin)
        } else {
            return nil
        }
    }
    
    /* MARK: Init
     * 创建的时候，如果有section，则section为固定的值
     * 如果为nil，则跟随。会根据beginTime进行调整
     */
    init(range: Range<Int>, section: Int?) {
        self.range = range
        self.trueSection = section
    }
    
    // MARK: override
    
    override func combineItem(_ model: ScheduleCombineItem) {
        super.combineItem(model)
        if model.identifier.type != .custom {
            exp = model.identifier.exp
        }
        
        for key in mapTable.keyEnumerator().allObjects as! [NSIndexPath] {
            if (key.section == section) {
                if let viewModel = mapTable.object(forKey: key) {
                    let part = PartItem(indexPath: key, viewModel: viewModel)
                    data.append(part)
                }
            }
        }
    }
    
    override func clear() {
        super.clear()
        data = [PartItem]()
    }
}