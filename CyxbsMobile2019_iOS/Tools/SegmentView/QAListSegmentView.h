//
//  QASegmentView.h
//  MoblieCQUPT_iOS
//
//  Created by 施昱丞 on 2019/3/10.
//  Copyright © 2019年 Shi Yucheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QASegmentViewDelegate

@required
/**
 点击SegmentView触发的方法
 
 @param index 标示点击的第几个SegmentView
 */
- (void)scrollEventWithIndex:(NSInteger) index;

@end


@interface QAListSegmentView : UIView

@property (nonatomic, weak) id<QASegmentViewDelegate> eventDelegate;
@property (nonatomic) CGFloat titleBtnWidth;
@property (nonatomic) CGFloat titleHeight;  //标签栏高度
@property (nonatomic, strong) UIColor *selectedTitleColor;  //标签选中时的字体颜色
@property (nonatomic, strong) UIColor *titleColor;  //标签字体颜色
@property (nonatomic, strong) UIFont *titleFont;    //标签字体属性
@property (nonatomic, strong) UIFont *selectedTitleFont;    //标签字体属性
@property (nonatomic, strong) UIColor *titleBackgroundColor;    //标签背景颜色
@property (nonatomic) CGFloat sliderWidth;  //标题下小滑块宽
@property (nonatomic) CGFloat sliderHeight;  //标题下小滑块高

/**
 
 @param frame SegmentView的Frame大小
 @param controllers SegmentView容纳的视图控制器，以数组形式提供
 
 @return 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray<UIViewController *> *)controllers;
- (void)updateUI;

@end




