//
//  MyTableViewCellWithProgress.m
//  Demo5
//
//  Created by 钟文韬 on 2021/8/9.
//

#import "MyTableViewCellWithProgress.h"

#import "PrefixHeader.pch"
@implementation MyTableViewCellWithProgress

- (instancetype)init{
    if (self = [super init]) {
        self.contentView.backgroundColor = [UIColor colorNamed:@"table"];
        [self.contentView addSubview:self.mainLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.gotoButton];
        [self.contentView addSubview:self.progressBar];
        [self.contentView addSubview:self.progressBarHaveDone];
        [self.contentView addSubview:self.progressNumberLabel];
    }
    return self;
}




- (UILabel *)mainLabel{
    if (!_mainLabel) {
        UILabel *mainLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH, 8, 200, 22)];
        mainLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        mainLabel.textColor = [UIColor colorNamed:@"#15315B"];
        mainLabel.text = @"逛逛邮问";
        _mainLabel = mainLabel;
    }
    return _mainLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel) {
        UILabel *detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH, 30,200, 20)];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        detailLabel.textColor = [UIColor colorNamed:@"#15315B66"];
        detailLabel.text = @"浏览5条动态 +15";
        _detailLabel = detailLabel;
    }
    return _detailLabel;
}

- (GotoButton *)gotoButton{
    if (!_gotoButton) {
        GotoButton *gotobutton = [[GotoButton alloc]initWithFrame:CGRectMake(0.781*SCREEN_WIDTH, 30, 66, 28) AndTitle:@"去完成"];
        _gotoButton = gotobutton;
    }
    return _gotoButton;
}

- (UIView *)progressBar{
    if (!_progressBar) {
        UIView *progressBar = [[UIView alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH, 59, 150, 8)];
        progressBar.backgroundColor = [UIColor colorNamed:@"#E5E5E5"];
        progressBar.layer.cornerRadius = 4;
        _progressBar = progressBar;
    }
    return _progressBar;
}

- (UIView *)progressBarHaveDone{
    if (!_progressBarHaveDone) {
        UIView *progressBarHaveDone = [[UIView alloc]initWithFrame:CGRectMake(0.06*SCREEN_WIDTH, 59, 0, 8)];
        progressBarHaveDone.backgroundColor = [UIColor colorNamed:@"#7D8AFF"];
        progressBarHaveDone.layer.cornerRadius = 4;
        _progressBarHaveDone = progressBarHaveDone;
    }
    return _progressBarHaveDone;
}

- (UILabel *)progressNumberLabel{
    if (!_progressNumberLabel) {
        UILabel *progressNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0.5*SCREEN_WIDTH, 55.5, 21, 17)];
        progressNumberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        progressNumberLabel.textColor = [UIColor colorNamed:@"#7D8AFF"];
        progressNumberLabel.text = @"1/5";
        _progressNumberLabel = progressNumberLabel;
    }
    return _progressNumberLabel;
}

- (void)setData:(TaskData *)data{
    self.mainLabel.text = data.title;
    self.detailLabel.text = data.Description;
    [UIView animateWithDuration:0.5 animations:^{
            self.progressBarHaveDone.size = CGSizeMake(data.current_progress/data.max_progress, 8);
    }];
    self.progressNumberLabel.text = [NSString stringWithFormat:@"%d/%d",data.current_progress,data.max_progress];
}

@end
