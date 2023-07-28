//
//  PointAndDottedLineView.swift
//  CyxbsMobile2019_iOS
//
//  Created by 许晋嘉 on 2023/7/23.
//  Copyright © 2023 Redrock. All rights reserved.
//

import UIKit

class PointAndDottedLineView: UIView {
    private var pointCount: Int = 0
    private var spacing: CGFloat = 0.0
    private var smallCircleRadius: CGFloat = 2.5
    private var bigCircleArray: [UIView] = []
    private var smallCircleArray: [UIView] = []
    
    var isNoExam: Bool = false
    
    // 添加bigCircle属性以存储大圆的引用
    public var bigCircle: UIView?
    
    init(pointCount: Int, spacing: CGFloat) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.pointCount = pointCount
        self.spacing = spacing
        self.addCircle()
        if bigCircleArray.isEmpty {
            self.isNoExam = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addCircle() {
        for i in 0..<pointCount {
            let bigCircle = UIView(frame: CGRect(x: 0, y: 0, width: 11, height: 11))
            bigCircle.backgroundColor = UIColor(red: 41/255.0, green: 33/255.0, blue: 209/255.0, alpha: 1)
            bigCircle.layer.cornerRadius = bigCircle.frame.width / 2.0
            addSubview(bigCircle)
            bigCircleArray.append(bigCircle)
            
            if i != 0 {
                bigCircle.snp.makeConstraints { make in
                    make.width.height.centerX.equalTo(bigCircleArray[0])
                    make.top.equalTo(bigCircleArray[i-1].snp.bottom).offset(spacing - bigCircle.frame.width)
                }
            }
        }
        
        for i in 0..<pointCount {
            let smallCircle = UIView()
            smallCircle.backgroundColor = UIColor(red: 242/255.0, green: 243/255.0, blue: 248/255.0, alpha: 1)
            smallCircle.layer.cornerRadius = smallCircleRadius
            addSubview(smallCircle)
            smallCircleArray.append(smallCircle)
            
            smallCircle.snp.makeConstraints { make in
                make.center.equalTo(bigCircleArray[i])
                make.width.height.equalTo(smallCircleRadius * 2)
            }
        }
        
        // 设置大圆的引用为数组中的最后一个元素
        self.bigCircle = bigCircleArray.last
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setLineCap(.round)
        context.setLineWidth(1.0)
        context.setStrokeColor(UIColor(red: 41/255.0, green: 33/255.0, blue: 209/255.0, alpha: 0.7).cgColor)
        context.beginPath()
        
        if bigCircleArray.isEmpty {
            return
        }
        
        let startPoint = CGPoint(x: bigCircleArray[0].frame.origin.x + bigCircleArray[0].frame.width/2.0, y: bigCircleArray[0].frame.origin.y + bigCircleArray[0].frame.width)
        let endPoint = CGPoint(x: bigCircleArray.last!.frame.origin.x + bigCircleArray.last!.frame.width/2.0, y: bigCircleArray.last!.frame.origin.y)
        
        context.move(to: startPoint)
        let lengths: [CGFloat] = [5, 5]
        context.setLineDash(phase: 0, lengths: lengths)
        context.addLine(to: endPoint)
        context.strokePath()
        context.closePath()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // layoutSubviews方法在这个例子中不需要实现，因为它在此处并不相关。
    }
}
