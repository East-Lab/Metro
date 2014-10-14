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

- (void)findLocation:(NSString *)location {
    if(self.geocoder == nil)
    {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    NSString *address = location;
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
    NSString *res;
        
        if(placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            if (self.delegate) {
                [self.delegate didCompleteGeocoder:placemark.location.coordinate];
            }
        } else if (error.domain == kCLErrorDomain) {
            switch (error.code) {
                case kCLErrorDenied:
                    res = @"Location Services Denied by User";
                    break;
                case kCLErrorNetwork:
                    res = @"No Network";
                    break;
                case kCLErrorGeocodeFoundNoResult:
                    res = @"No Result Found";
                    break;
                default:
                    res = error.localizedDescription;
                    break;
            }
            if (self.delegate) {
                [self.delegate didFailedGeocoder:res];
            }
        } else {
            res = error.localizedDescription;
            if (self.delegate) {
                [self.delegate didFailedGeocoder:res];
            }
        }
    }];
    
}

#pragma mark - 位置情報 LocationSearvice
/*
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    lon = coordinate.longitude;
    lat = coordinate.latitude;
    if (self.delegate) {
        [self.delegate updateLocationInfomation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Location manager Error: %@", error);
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    //NSLog(@"didUpdateHeading");
    headCoordinate = manager.location.coordinate;
    headDirection = newHeading.magneticHeading;
    lat = headCoordinate.latitude;
    lon = headCoordinate.longitude;
    if (self.delegate) {
        [self.delegate updateHeadingInformation];
    }
}
 */


#pragma mark - プライベートメソッド
/*
- (void)sendLocalNotificationForMessage:(NSString *)message
{
    NSLog(@"local notification");
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = message;
    localNotification.fireDate = [[NSDate date] dateByAddingTimeInterval:0];
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.alertAction = @"Open";
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"通知を受信しました。" forKey:@"EventKey"];
    localNotification.userInfo = infoDict;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)configureTentLocation{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if ([ud doubleForKey:@"destinationLatitude"] != lat || [ud doubleForKey:@"destinationLongitude"] != lon) {
        [ud setDouble:lat forKey:@"destinationLatitude"];
        [ud setDouble:lon forKey:@"destinationLongitude"];
        NSLog(@"lat :::: %f",lat);
        NSLog(@"long :::: %f",lon);
        NSString *str = [NSString stringWithFormat:@"テントの所在地を %f,%f\nに変更しました",lat,lon];
        UIAlertView *alert =
        [[UIAlertView alloc]
         initWithTitle:@"FindTent"
         message:str
         delegate:nil
         cancelButtonTitle:nil
         otherButtonTitles:@"OK", nil
         ];
        [alert show];
    }
}
 */

@end