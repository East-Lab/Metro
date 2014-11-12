//
//  GoogleMapsAPIManager.h
//  Metro
//
//  Created by 川島 大地 on 2014/11/05.
//  Copyright (c) 2014年 川島 大地. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GoogleMapsAPIManagerDelegate <NSObject>
- (void)onFailedGoogleRequest:(NSString *)err;
- (void)onSuccessGetGoogleGeoByKeyword:(NSString *)name andLat:(float)lat andLon:(float)lon;

@end


@interface GoogleMapsAPIManager : NSObject{
}

@property (nonatomic, strong) id<GoogleMapsAPIManagerDelegate> delegate;

+ (GoogleMapsAPIManager *)sharedManager;
- (void)getGeoByKeyword:(NSString *)keyword;

@end
