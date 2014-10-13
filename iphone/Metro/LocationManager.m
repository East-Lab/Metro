//
//
//
#import <Foundation/Foundation.h>
#import "LocationManager.h"

static LocationManager *manager = nil;
//static CLLocationDegrees lon;
//static CLLocationDegrees lat;


@interface LocationManager();


@end

@implementation LocationManager
@synthesize lon;
@synthesize lat;
@synthesize headCoordinate;
@synthesize headDirection;

#pragma mark - singleton

+ (LocationManager *)sharedManager{
    if (manager == nil) {
        manager = [[LocationManager alloc] init];
    }
    return manager;
}

- (void)startLocationSearvice{
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.activityType = CLActivityTypeFitness;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
        NSLog(@"Start updating location.");
    } else {
        NSLog(@"The location services(location) is disabled.");
    }
}

- (void)startHeadingSearvice{
    if ([CLLocationManager headingAvailable]) {
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingHeading];
    }else{
        NSLog(@"The location services(heading) is disabled.");
    }
}

#pragma mark - 位置情報 LocationSearvice
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