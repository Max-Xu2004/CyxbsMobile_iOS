//
//  SearchPersonTableViewCell.h
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/11/16.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 复用标志
UIKIT_EXTERN NSString *SearchPersonTableViewCellReuseIdentifier;

@interface SearchPersonTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *inClass;

@property (nonatomic, copy) NSString *sno;

@property (nonatomic) BOOL adding;

@end

NS_ASSUME_NONNULL_END
