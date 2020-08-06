//
//  WYCClassBookViewController.h
//  MoblieCQUPT_iOS
//
//  Created by 王一成 on 2018/9/21.
//  Copyright © 2018年 Orange-W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLReminderViewController.h"
#import "WYCClassAndRemindDataModel.h"

#import "DateModle.h"
#import "WYCClassBookView.h"
#import "WYCClassDetailView.h"
#import "WYCShowDetailView.h"
#import "WMTWeekChooseBar.h"
#import "LoginViewController.h"


#import "AddRemindViewController.h"
#import "UIFont+AdaptiveFont.h"
#import "RemindNotification.h"


#define DateStart @"2020-02-17"

NS_ASSUME_NONNULL_BEGIN
//目标：输入[responseObject objectForKey:@"data"]，输出：显示整学期课表
//现状：输入WYCClassAndRemindDataModel，输出：显示整学期课表
@interface WYCClassBookViewController : UIViewController

//如果是用代码加载，必须调用这个方法，详细说明看底下注释

@property (nonatomic, strong) WYCClassAndRemindDataModel *model;
@end

NS_ASSUME_NONNULL_END
//用代码加载WYCClassBookViewController的使用说明：

//1.创建所需模型，在对模型完成一些初始化操作
//WYCClassAndRemindDataModel *model = [[WYCClassAndRemindDataModel alloc] init];
//model.weekArray = [@[array]mutableCopy];
//[model parsingClassBookData:array];
//[model setValue:@"YES" forKey:@"remindDataLoadFinish"];
//[model setValue:@"YES" forKey:@"classDataLoadFinish"];

//2.从控制器加载WYCClassBookViewController
//WYCClassBookViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"WYCClassBookViewController"];

//
//[vc initStuNum:@"x" andIdNum:@"x"];

//4.用模型对vc在初始化一下
//[vc initWYCClassAndRemindDataModel:model];

//5.presentViewController，或pushVC


