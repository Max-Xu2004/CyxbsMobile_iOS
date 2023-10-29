//
//  JXtest.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/10/29.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit
import JXSegmentedView

open class JXSegmentedActivityCustomDataSource: JXSegmentedTitleDataSource {
    
    open var backGroundSelectedColor: UIColor = .clear
    open var backGroundNormalColor: UIColor = .clear
    open var cornerRadius: CGFloat = 0.0
    
    open override func preferredItemModelInstance() -> JXSegmentedBaseItemModel {
        return JXSegmentedActivityCustomItemModel()
    }
    
    open override func preferredRefreshItemModel( _ itemModel: JXSegmentedBaseItemModel, at index: Int, selectedIndex: Int) {
        super.preferredRefreshItemModel(itemModel, at: index, selectedIndex: selectedIndex)

        guard let myItemModel = itemModel as? JXSegmentedActivityCustomItemModel else {
            return
        }

        myItemModel.title = titles[index]
        myItemModel.textWidth = widthForTitle(myItemModel.title ?? "")
        myItemModel.titleNumberOfLines = titleNumberOfLines
        myItemModel.isSelectedAnimable = isSelectedAnimable
        myItemModel.titleNormalColor = titleNormalColor
        myItemModel.titleSelectedColor = titleSelectedColor
        myItemModel.titleNormalFont = titleNormalFont
        myItemModel.titleSelectedFont = titleSelectedFont != nil ? titleSelectedFont! : titleNormalFont
        myItemModel.isTitleZoomEnabled = isTitleZoomEnabled
        myItemModel.isTitleStrokeWidthEnabled = isTitleStrokeWidthEnabled
        myItemModel.isTitleMaskEnabled = isTitleMaskEnabled
        myItemModel.titleNormalZoomScale = 1
        myItemModel.titleSelectedZoomScale = titleSelectedZoomScale
        myItemModel.titleSelectedStrokeWidth = titleSelectedStrokeWidth
        myItemModel.titleNormalStrokeWidth = 0
        myItemModel.backGroundNormalColor = backGroundNormalColor
        myItemModel.backGroundSelectedColor = backGroundSelectedColor
        myItemModel.cornerRadius = cornerRadius
        if index == selectedIndex {
            myItemModel.titleCurrentColor = titleSelectedColor
            myItemModel.backGroundCurrentColor = backGroundSelectedColor
            myItemModel.titleCurrentZoomScale = titleSelectedZoomScale
            myItemModel.titleCurrentStrokeWidth = titleSelectedStrokeWidth
        }else {
            myItemModel.titleCurrentColor = titleNormalColor
            myItemModel.backGroundCurrentColor = backGroundNormalColor
            myItemModel.titleCurrentZoomScale = 1
            myItemModel.titleCurrentStrokeWidth = 0
        }
    }
    
    //MARK: - JXSegmentedViewDataSource
    open override func registerCellClass(in segmentedView: JXSegmentedView) {
        segmentedView.collectionView.register(JXSegmentedActivityCustomCell.self, forCellWithReuseIdentifier: "cell")
    }

    open override func segmentedView(_ segmentedView: JXSegmentedView, cellForItemAt index: Int) -> JXSegmentedBaseCell {
        let cell = segmentedView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        return cell
    }
}

class JXSegmentedActivityCustomItemModel: JXSegmentedTitleItemModel {
    open var backGroundNormalColor: UIColor = .clear
    open var backGroundSelectedColor: UIColor = .clear
    open var backGroundCurrentColor: UIColor = .clear
    open var cornerRadius: CGFloat = 0.0
}

class JXSegmentedActivityCustomCell: JXSegmentedTitleCell {
    open override func reloadData(itemModel: JXSegmentedBaseItemModel, selectedType: JXSegmentedViewItemSelectedType) {
        super.reloadData(itemModel: itemModel, selectedType: selectedType )

        guard let myItemModel = itemModel as? JXSegmentedActivityCustomItemModel else {
            return
        }

        titleLabel.numberOfLines = myItemModel.titleNumberOfLines
        maskTitleLabel.numberOfLines = myItemModel.titleNumberOfLines
        contentView.backgroundColor = myItemModel.backGroundNormalColor
        contentView.layer.cornerRadius = myItemModel.cornerRadius

        if myItemModel.isTitleZoomEnabled {
            //先把font设置为缩放的最大值，再缩小到最小值，最后根据当前的titleCurrentZoomScale值，进行缩放更新。这样就能避免transform从小到大时字体模糊
            let maxScaleFont = UIFont(descriptor: myItemModel.titleNormalFont.fontDescriptor, size: myItemModel.titleNormalFont.pointSize*CGFloat(myItemModel.titleSelectedZoomScale))
            let baseScale = myItemModel.titleNormalFont.lineHeight/maxScaleFont.lineHeight

            if myItemModel.isSelectedAnimable && canStartSelectedAnimation(itemModel: itemModel, selectedType: selectedType) {
                //允许动画且当前是点击的
                let titleZoomClosure = preferredTitleZoomAnimateClosure(itemModel: myItemModel, baseScale: baseScale)
                appendSelectedAnimationClosure(closure: titleZoomClosure)
            }else {
                titleLabel.font = maxScaleFont
                maskTitleLabel.font = maxScaleFont
                let currentTransform = CGAffineTransform(scaleX: baseScale*CGFloat(myItemModel.titleCurrentZoomScale), y: baseScale*CGFloat(myItemModel.titleCurrentZoomScale))
                titleLabel.transform = currentTransform
                maskTitleLabel.transform = currentTransform
            }
        }else {
            if myItemModel.isSelected {
                titleLabel.font = myItemModel.titleSelectedFont
                maskTitleLabel.font = myItemModel.titleSelectedFont
            }else {
                titleLabel.font = myItemModel.titleNormalFont
                maskTitleLabel.font = myItemModel.titleNormalFont
            }
        }

        let title = myItemModel.title ?? ""
        let attriText = NSMutableAttributedString(string: title)
        if myItemModel.isTitleStrokeWidthEnabled {
            if myItemModel.isSelectedAnimable && canStartSelectedAnimation(itemModel: itemModel, selectedType: selectedType) {
                //允许动画且当前是点击的
                let titleStrokeWidthClosure = preferredTitleStrokeWidthAnimateClosure(itemModel: myItemModel, attriText: attriText)
                appendSelectedAnimationClosure(closure: titleStrokeWidthClosure)
            }else {
                attriText.addAttributes([NSAttributedString.Key.strokeWidth: myItemModel.titleCurrentStrokeWidth], range: NSRange(location: 0, length: title.count))
                titleLabel.attributedText = attriText
                maskTitleLabel.attributedText = attriText
            }
        }else {
            titleLabel.attributedText = attriText
            maskTitleLabel.attributedText = attriText
        }

        if myItemModel.isTitleMaskEnabled {
            //允许mask，maskTitleLabel在titleLabel上面，maskTitleLabel设置为titleSelectedColor。titleLabel设置为titleNormalColor
            //为了显示效果，使用了双遮罩。即titleMaskLayer遮罩titleLabel，maskTitleMaskLayer遮罩maskTitleLabel
            maskTitleLabel.isHidden = false
            titleLabel.textColor = myItemModel.titleNormalColor
            maskTitleLabel.textColor = myItemModel.titleSelectedColor
            let labelSize = maskTitleLabel.sizeThatFits(self.contentView.bounds.size)
            let labelBounds = CGRect(x: 0, y: 0, width: labelSize.width, height: labelSize.height)
            maskTitleLabel.bounds = labelBounds

            var topMaskFrame = myItemModel.indicatorConvertToItemFrame
            topMaskFrame.origin.y = 0
            var bottomMaskFrame = topMaskFrame
            var maskStartX: CGFloat = 0
            if maskTitleLabel.bounds.size.width >= bounds.size.width {
                topMaskFrame.origin.x -= (maskTitleLabel.bounds.size.width - bounds.size.width)/2
                bottomMaskFrame.size.width = maskTitleLabel.bounds.size.width
                maskStartX = -(maskTitleLabel.bounds.size.width - bounds.size.width)/2
            }else {
                topMaskFrame.origin.x -= (bounds.size.width - maskTitleLabel.bounds.size.width)/2
                bottomMaskFrame.size.width = bounds.size.width
                maskStartX = 0
            }
            bottomMaskFrame.origin.x = topMaskFrame.origin.x
            if topMaskFrame.origin.x > maskStartX {
                bottomMaskFrame.origin.x = topMaskFrame.origin.x - bottomMaskFrame.size.width
            }else {
                bottomMaskFrame.origin.x = topMaskFrame.maxX
            }

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            if topMaskFrame.size.width > 0 && topMaskFrame.intersects(maskTitleLabel.frame) {
                titleLabel.layer.mask = titleMaskLayer
                titleMaskLayer.frame = bottomMaskFrame
                maskTitleMaskLayer.frame = topMaskFrame
            }else {
                titleLabel.layer.mask = nil
                maskTitleMaskLayer.frame = topMaskFrame
            }
            CATransaction.commit()
        }else {
            maskTitleLabel.isHidden = true
            titleLabel.layer.mask = nil
            if myItemModel.isSelectedAnimable && canStartSelectedAnimation(itemModel: itemModel, selectedType: selectedType) {
                //允许动画且当前是点击的
                let titleColorClosure = preferredTitleColorAnimateClosure(itemModel: myItemModel)
                let backGroundColorClosure = preferredBackGroundColorAnimateClosure(itemModel: myItemModel)
                appendSelectedAnimationClosure(closure: titleColorClosure)
                appendSelectedAnimationClosure(closure: backGroundColorClosure)
            }else {
                titleLabel.textColor = myItemModel.titleCurrentColor
                contentView.backgroundColor = myItemModel.backGroundCurrentColor
            }
        }

        startSelectedAnimationIfNeeded(itemModel: itemModel, selectedType: selectedType)
        
        if myItemModel.isSelected {
            contentView.backgroundColor = myItemModel.backGroundSelectedColor
        } else {
            contentView.backgroundColor = myItemModel.backGroundNormalColor
        }
        setNeedsLayout()
    }
    
    open func preferredBackGroundColorAnimateClosure(itemModel: JXSegmentedActivityCustomItemModel) -> JXSegmentedCellSelectedAnimationClosure {
        return {[weak self] (percent) in
            if itemModel.isSelected {
                //将要选中，backGroundColor从backGroundNormalColor到backGroundSelectedColor插值渐变
                itemModel.backGroundCurrentColor = JXSegmentedViewTool.interpolateThemeColor(from: itemModel.backGroundNormalColor, to: itemModel.backGroundSelectedColor, percent: percent)
            }else {
                //将要取消选中，backGroundColor从backGroundSelectedColor到backGroundNormalColor插值渐变
                itemModel.backGroundCurrentColor = JXSegmentedViewTool.interpolateThemeColor(from: itemModel.backGroundSelectedColor, to: itemModel.backGroundNormalColor, percent: percent)
            }
            self?.contentView.backgroundColor = itemModel.backGroundCurrentColor
        }
    }
}


