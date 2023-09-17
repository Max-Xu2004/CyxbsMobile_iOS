//
//  QASegmentView.m
//  QASegmentView
//
//  Created by 施昱丞 on 2018/8/28.
//  Copyright © 2018年 Shi Yucheng. All rights reserved.
//

#import "QAListSegmentView.h"

@interface QAListSegmentView ()<UIScrollViewDelegate>

//内容视图
@property (nonatomic, copy) NSArray <UIViewController *> *controllers;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, assign) NSInteger currentIndex;

//滑动标签栏
@property (nonatomic, strong) NSMutableArray <UIButton *> *titleBtnArray;
@property (nonatomic, strong) UIScrollView *titleView;

@property (nonatomic, strong) UIView *sliderLinePart1;  //标题下小滑块第一部分
//@property (nonatomic, strong) UIView *sliderLinePart2;  //标题下小滑块第二部分
@property (nonatomic) CGFloat currentX;


@end


@implementation QAListSegmentView

//默认初始化方法

- (instancetype)initWithFrame:(CGRect)frame controllers:(NSArray<UIViewController *> *)controllers{
    self = [super initWithFrame:frame];
    if (self) {
        _controllers = controllers;
        
        _titleBtnWidth = controllers.count > 4 ? self.frame.size.width / 5 : self.frame.size.width / controllers.count;
        

        //默认属性
        _titleBtnArray = [NSMutableArray array];
        _currentIndex = 0;
        _titleHeight = SCREEN_HEIGHT * 0.06;
        if (@available(iOS 11.0, *)) {
            _titleColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#EFEFF1" alpha:1]];
            _selectedTitleColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#EFEFF1" alpha:1]];
        } else {
            _titleColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
            _selectedTitleColor = [UIColor dm_colorWithLightColor:[UIColor colorWithHexString:@"#15315B" alpha:1] darkColor:[UIColor colorWithHexString:@"#FFFFFF" alpha:1]];
        }
        
        _titleFont = [UIFont fontWithName:@"PingFangSC" size:16];
        _selectedTitleFont = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        _titleView.backgroundColor = [UIColor clearColor];
        _currentX = 0;

        _titleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.titleHeight)];
        _titleView.contentSize = CGSizeMake(self.titleBtnWidth * self.controllers.count, self.titleHeight);
        _titleView.bounces = NO;
        _titleView.showsVerticalScrollIndicator = NO;
        _titleView.showsHorizontalScrollIndicator = NO;
    }

    [self setUpView];
    return self;
}


- (void)setUpView{
    //加载滑动标签栏
    
    for (int i = 0; i < self.controllers.count; ++i) {
        //创建按钮
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * _titleBtnWidth, 0, _titleBtnWidth, _titleHeight)];
        titleBtn.tag = i;
        titleBtn.titleLabel.font = _titleFont;
        [titleBtn setTitle:_controllers[i].title forState:UIControlStateNormal];
        [titleBtn setTitleColor:_titleColor forState:UIControlStateNormal];
        [titleBtn setTitleColor:_selectedTitleColor forState:UIControlStateSelected];
        [_titleBtnArray addObject:titleBtn];
        [_titleView addSubview:titleBtn];
        [titleBtn addTarget:self action:@selector(clickTitleBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            //创建滑块
            _sliderWidth = [titleBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: self.selectedTitleFont}].width;
            _sliderHeight = _titleHeight * 0.08;
            _sliderLinePart1 = [[UIView alloc] initWithFrame:CGRectMake((_titleBtnWidth - _sliderWidth) / 2.0 , _titleHeight - _sliderHeight, _sliderWidth, _sliderHeight)];
            _sliderLinePart1.layer.cornerRadius = 2.0;
            UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"分页滑条"]];
            [imgView setFrame:CGRectMake(0, 0, _sliderWidth, _sliderHeight)];
            [_sliderLinePart1 addSubview:imgView];
            [_titleView addSubview:_sliderLinePart1];
            
        }
    }
    
    
    
    [_titleBtnArray firstObject].selected = YES;
    [_titleBtnArray firstObject].titleLabel.font = _selectedTitleFont;
    _titleView.backgroundColor = _titleBackgroundColor;
    [self addSubview:_titleView];
    
    //加载主视图
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.titleHeight, self.frame.size.width, self.frame.size.height - self.titleHeight)];
    _mainScrollView.contentSize = CGSizeMake(self.frame.size.width * self.controllers.count, 0);
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.delegate = self;
    for (int i = 0; i < _controllers.count; i++) {
        UIView *view = _controllers[i].view;
        view.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height - _titleHeight);
        [_mainScrollView addSubview:view];
    }
    [self addSubview:_mainScrollView];
}


- (void)clickTitleBtn:(UIButton *)sender {
    [self.mainScrollView setContentOffset:CGPointMake(sender.tag * self.frame.size.width, 0) animated:YES];
    for (int i=0;i<_titleBtnArray.count;i++) {
        UIButton *btn = _titleBtnArray[i];
        if (i==sender.tag) {
            btn.titleLabel.font = _selectedTitleFont;
        }else{
            btn.titleLabel.font = _titleFont;
        }
    }
    NSLog(@"%lD",(long)sender.tag);
//
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger currentIndex = floor(_mainScrollView.contentOffset.x / self.frame.size.width);
    CGFloat offSetX = scrollView.contentOffset.x; //主页面相对起始位置的位移
    
    //滑块第一部分的位移变化
    _sliderLinePart1.frame = CGRectMake(offSetX / self.frame.size.width * _titleBtnWidth + (_titleBtnWidth - _sliderWidth) / 2.0, _titleHeight - _sliderHeight, _sliderWidth, _sliderHeight);
    
    
    if (currentIndex != _currentIndex) {
        _titleBtnArray[_currentIndex].selected = NO;
        _titleBtnArray[_currentIndex].titleLabel.font = _titleFont;
        _currentIndex = currentIndex;
        _titleBtnArray[_currentIndex].selected = YES;
        _titleBtnArray[_currentIndex].titleLabel.font = _selectedTitleFont;
//
//        CAKeyframeAnimation *scale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//        NSArray *shapes = @[@1.1, @1.2, @1.2, @1.2, @1.1, @1];
//        [scale setDuration:0.5];
//        [scale setValues:shapes];
//        [scale setRemovedOnCompletion:NO];
//        [scale setFillMode:kCAFillModeBoth];
//        [_titleBtnArray[currentIndex].layer addAnimation:scale forKey:@"transform.scale"];
//
//        [UIView animateWithDuration:0.7f animations:^{
//            self.titleBtnArray[currentIndex].alpha = 0.4;
//            self.titleBtnArray[currentIndex].alpha = 1.0;
//        }];
        
        [UIView animateWithDuration:0.4f delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            //当标题栏超出屏幕时移动标题栏
            if (self.titleBtnArray[currentIndex].frame.origin.x < self.frame.size.width / 2) {
                [self.titleView setContentOffset:CGPointMake(0, 0)];
            } else if (self.titleView.contentSize.width - self.titleBtnArray[currentIndex].frame.origin.x <= self.frame.size.width / 2) {
                [self.titleView setContentOffset:CGPointMake(self.controllers.count * self.titleBtnWidth - self.frame.size.width, 0)];
            } else {
                [self.titleView setContentOffset:CGPointMake(self.titleBtnArray[currentIndex].frame.origin.x - self.frame.size.width / 2.0 + self.titleBtnWidth / 2.0, 0)];
            }
        } completion:nil];
        [self.eventDelegate scrollEventWithIndex:currentIndex];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _currentX = _mainScrollView.contentOffset.x;
    _sliderLinePart1.frame = CGRectMake(_currentIndex * _titleBtnWidth + (_titleBtnWidth - _sliderWidth) / 2.0, _titleHeight - _sliderHeight, _sliderWidth, _sliderHeight);
//    _sliderLinePart2.frame = CGRectMake(_currentIndex * _titleBtnWidth + (_titleBtnWidth - _sliderWidth) / 2.0, _titleHeight - _sliderHeight, _sliderWidth, _sliderHeight);
}

//如果需要使用自定义的颜色和字体，在设置完成后，需要调用该方法更新控件的相关属性
- (void)updateUI {
    // 更新UI的逻辑，例如设置标题颜色、字体等
    for (UIButton *button in self.titleBtnArray) {
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectedTitleColor forState:UIControlStateSelected];
        button.titleLabel.font = self.titleFont;
    }
    self.titleView.backgroundColor = self.titleBackgroundColor;
}


@end
