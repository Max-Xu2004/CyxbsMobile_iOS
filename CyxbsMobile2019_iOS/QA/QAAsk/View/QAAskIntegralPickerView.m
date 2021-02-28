//
//  QAAskIntegralPickerView.m
//  CyxbsMobile2019_iOS
//
//  Created by 王一成 on 2020/2/1.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "QAAskIntegralPickerView.h"

@implementation QAAskIntegralPickerView
-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        NSString *name = NSStringFromClass(self.class);
        [[NSBundle mainBundle] loadNibNamed:name owner:self options:nil];
        self.contentView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.contentView];
        self.integralPickViewContent = [NSMutableArray array];
        NSArray *num = @[@1,@2,@3,@5,@10,@15];
        for (int i = 0; i < 6; i++) {
            NSString *numString = [NSString stringWithFormat:@"%@",num[i]];
            [self.integralPickViewContent addObject:numString];
        }
        [self setupView];
    }
    
    return self;
}

- (void)setupView{
    self.integralPickView.transform = CGAffineTransformMakeRotation(M_PI*3/2);
    [self.integralPickView setFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
    self.integralPickView.showsSelectionIndicator = NO;
    //设置默认选中积分
    [self.integralPickView selectRow:0 inComponent:0 animated:YES];
    self.integralNum = @"1";
    if (@available(iOS 11.0, *)) {
        self.integralPickView.backgroundColor = [UIColor colorNamed:@"QABackgroundColor"];
    } else {
        self.integralPickView.backgroundColor = [UIColor whiteColor];
    }
}


#pragma mark - UIPickerViewDelegate
#pragma mark 列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

#pragma mark 每列多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.integralPickViewContent.count;
}
//- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated{
//
//}

#pragma mark pickerView内容
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] init];
    label.transform = CGAffineTransformMakeRotation(M_PI_2);
    label.text = self.integralPickViewContent[row];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont fontWithName:@"Impact" size:64]];
    label.textColor = [UIColor colorWithHexString:@"#2A4E84"];
    ((UILabel *)[pickerView.subviews objectAtIndex:1]).hidden = YES;    //隐藏分隔线
//    ((UILabel *)[pickerView.subviews objectAtIndex:2]).hidden = YES;    //隐藏分隔线
    if (@available(iOS 11.0, *)) {
        label.textColor = [UIColor colorNamed:@"QANavigationTitleColor"];
    } else {
        label.textColor = [UIColor colorWithRed:21/255.0 green:49/255.0 blue:91/255.0 alpha:1];
    }
    
    return label;
}

#pragma mark pickerView每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 80;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 100;
}

#pragma mark pickerView滚动方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.integralNum = self.integralPickViewContent[row];
//    NSLog(@"%@",self.integralNum);
}

@end
