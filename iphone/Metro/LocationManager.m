//
//
//
#import <Foundation/Foundation.h>
#import "LocationManager.h"

static LocationManager *manager = nil;

@interface LocationManager();

@end

@implementation LocationManager

#pragma mark - singleton

+ (LocationManager *)sharedManager{
    if (manager == nil) {
        manager = [[LocationManager alloc] init];
    }
    return manager;
}

- (void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    } else {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status != kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"did change authorization status");
        if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
            [self.locationManager requestAlwaysAuthorization];
        } else {
            [self.locationManager startUpdatingLocation];
        }
    }
}

@end