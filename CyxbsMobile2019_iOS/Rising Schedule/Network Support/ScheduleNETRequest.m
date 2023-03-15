//
//  ScheduleNETRequest.m
//  CyxbsMobile2019_iOS
//
//  Created by SSR on 2022/8/23.
//  Copyright © 2022 Redrock. All rights reserved.
//

#import "ScheduleNETRequest.h"

#import "ScheduleCourse.h"

#import "HttpTool.h"
#import "NetURL.h"
#import "ScheduleAPI.h"

static NSString *urlForRequest(ScheduleModelRequestType type) {
    if (type == ScheduleModelRequestStudent) {
        return @"https://be-prod.redrock.cqupt.edu.cn/magipoke-jwzx/kebiao";
    }
    if (type == ScheduleModelRequestCustom) {
        return STRS(NetURL.base.beprod, scheule.transaction.get);
    }
    if (type == ScheduleModelRequestTeacher) {
        return STRS(NetURL.base.beprod, scheule.tea);
    }
    return @"";
}

static NSString *keyForType(ScheduleModelRequestType type) {
    if (type == ScheduleModelRequestStudent ||
        type == ScheduleModelRequestCustom) {
        return @"stu_num";
    }
    if (type == ScheduleModelRequestTeacher) {
        return @"tea";
    }
    return @"";
}

@implementation ScheduleNETRequest

static ScheduleNETRequest *_current;
+ (ScheduleNETRequest *)current {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _current = [[ScheduleNETRequest alloc] init];
    });
    return _current;
}

#pragma mark - Method

+ (void)request:(ScheduleRequestDictionary *)requestDictionary
        success:(void (^)(ScheduleCombineItem *))success
        failure:(nonnull void (^)(NSError * _Nonnull, ScheduleIdentifier * _Nonnull))failure {
    
    for (ScheduleModelRequestType type in requestDictionary.allKeys) {
        for (NSString *sno in requestDictionary[type]) {
            [HttpTool.shareTool
             request:urlForRequest(type)
             type:HttpToolRequestTypePost
             serializer:HttpToolRequestSerializerHTTP
             bodyParameters:@{
                @"stu_num" : sno
            }
             progress:nil
             success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable object) {
                
                NSArray *lessonAry = [object objectForKey:@"data"];
                
                BOOL check = (!object || !lessonAry || lessonAry.count == 0);
                if (check) {
                    NSAssert(check, @"\n🔴%s data : %@", __func__, lessonAry);
                    return;
                }
                
                NSString *sno = object[@"stuNum"];
                NSInteger nowWeek = [object[@"nowWeek"] longValue];
                
                ScheduleIdentifier *identifier = [ScheduleIdentifier identifierWithSno:sno type:type];
                [identifier setExpWithNowWeek:nowWeek];
                
                NSMutableArray *ary = NSMutableArray.array;
                for (NSDictionary *courceDictionary in lessonAry) {
                    ScheduleCourse *course = [[ScheduleCourse alloc] initWithDictionary:courceDictionary];
                    [ary addObject:course];
                }
                
                ScheduleCombineItem *item = [ScheduleCombineItem combineItemWithIdentifier:identifier value:ary];
                
                if (item.identifier.type == ScheduleModelRequestCustom) {
                    ScheduleNETRequest.current.customItem = item;
                }
               
                if (success) {
                    success(item);
                }
            }
             failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                ScheduleIdentifier *identifier = [ScheduleIdentifier identifierWithSno:sno type:type];
                if (failure) {
                    failure(error, identifier);
                }
            }];
        }
    }
}

- (void)appendCustom:(ScheduleCourse *)course
             success:(void (^)(ScheduleCombineItem *))success
             failure:(void (^)(NSError *))failure {
    NSMutableArray *ary = [NSMutableArray arrayWithArray:ScheduleNETRequest.current.customItem.value];
    [ary addObject:course];
    if (success) {
        success([ScheduleCombineItem combineItemWithIdentifier:ScheduleNETRequest.current.customItem.identifier value:ary]);
    }
    
}

- (void)editCustom:(ScheduleCourse *)course
           success:(nonnull void (^)(ScheduleCombineItem *))success
           failure:(nonnull void (^)(NSError *))failure {
    
}

- (void)deleteCustom:(ScheduleCourse *)course
             success:(void (^)(ScheduleCombineItem *))success
             failure:(void (^)(NSError *))failure {
    
}

@end
