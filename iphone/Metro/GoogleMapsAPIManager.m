//
//  GoogleMapsAPIManager.m
//  Metro
//
//  Created by 川島 大地 on 2014/11/05.
//  Copyright (c) 2014年 川島 大地. All rights reserved.
//

#import "GoogleMapsAPIManager.h"

static GoogleMapsAPIManager *manager = nil;

@implementation GoogleMapsAPIManager

@synthesize delegate;

+ (GoogleMapsAPIManager *)sharedManager{
    if (manager == nil) {
        manager = [[GoogleMapsAPIManager alloc] init];
    }
    return manager;
}

- (void)getGeoByKeyword:(NSString *)keyword
{
    NSString *enckey= [keyword stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlstr = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false",enckey];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSLog(@"url : %@" ,url) ;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *resData, NSError *error) {
        if(error) {
            NSLog(@"error: %@", error);
            if (delegate) {
                [delegate onFailedGoogleRequest:error.description];
            }
        } else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingAllowFragments error:&error];
            //NSLog(@"google res : %@",dic[@"results"][0][@"address_components"][0][@"short_name"]);
            NSLog(@"google lat : %@",dic[@"results"][0][@"geometry"][@"location"][@"lat"]);
            NSLog(@"google lng : %@",dic[@"results"][0][@"geometry"][@"location"][@"lng"]);
            if (delegate) {
                [delegate onSuccessGetGoogleGeoByKeyword: dic[@"results"][0][@"address_components"][0][@"short_name"] andLat:[dic[@"results"][0][@"geometry"][@"location"][@"lat"] floatValue] andLon:[dic[@"results"][0][@"geometry"][@"location"][@"lng"] floatValue]];
            }
        }
    }];
}

@end
