//
//  CQUPTMapPresenter.m
//  CyxbsMobile2019_iOS
//
//  Created by 方昱恒 on 2020/8/11.
//  Copyright © 2020 Redrock. All rights reserved.
//

#import "CQUPTMapPresenter.h"
#import "CQUPTMapModel.h"
#import "CQUPTMapPlaceItem.h"
#import <SDImageCache.h>

@implementation CQUPTMapPresenter

- (void)attachView:(UIViewController<CQUPTMapViewProtocol> *)view {
    _view = view;
}

- (void)detachView {
    _view = nil;
}

- (void)requestMapData {
    [CQUPTMapModel requestMapDataSuccess:^(CQUPTMapDataItem * _Nonnull mapDataItem, NSArray<CQUPTMapHotPlaceItem *> * _Nonnull hotPlaceItemArray) {
        CQUPTMapDataItem *oldMap = [NSKeyedUnarchiver unarchiveObjectWithFile:[CQUPTMapDataItem archivePath]];
        if ([mapDataItem.mapVersion intValue] > [oldMap.mapVersion intValue]) {
            [[SDImageCache sharedImageCache] removeImageForKey:oldMap.mapURL withCompletion:nil];
        }
        [self.view mapDataRequestSuccessWithMapData:mapDataItem hotPlace:hotPlaceItemArray];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (void)requestStarData {
    [CQUPTMapModel requestStarListSuccess:^(CQUPTMapStarPlaceItem * _Nonnull starPlace) {
        [self.view starPlaceRequestSuccessWithStarPlace:starPlace];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

- (void)searchPlaceWithString:(NSString *)string {
    CQUPTMapDataItem *mapData = [NSKeyedUnarchiver unarchiveObjectWithFile:[CQUPTMapDataItem archivePath]];
    NSArray<CQUPTMapPlaceItem *> *placeArray = mapData.placeList;
    
    NSMutableArray *tmpArray = [@[] mutableCopy];
    for (CQUPTMapPlaceItem *place in placeArray) {
        if ([place.placeName containsString:string]) {
            [tmpArray addObject:place.placeId];
        }
    }
    
    [self.view searchPlaceSuccess:tmpArray];
}

- (void)requestPlaceDataWithPlaceID:(NSString *)placeID {
    [CQUPTMapModel requestPlaceDataWithPlaceID:placeID success:^(CQUPTMapPlaceDetailItem * _Nonnull placeDetailItem) {
        [self.view placeDetailDataRequestSuccess:placeDetailItem];
    } failed:^(NSError * _Nonnull error) {
        
    }];
}

@end
