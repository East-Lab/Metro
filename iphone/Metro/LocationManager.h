//
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationManagerDelegate <NSObject>

- (void) didCompleteGeocoder:(CLLocationCoordinate2D)coordinate;
- (void) didFailedGeocoder:(NSString *)err;

@end

@interface LocationManager: NSObject<CLLocationManagerDelegate>{
}

@property (nonatomic,strong) id<LocationManagerDelegate> delegate;
@property (nonatomic, retain) CLLocationManager *locationManager;


+ (LocationManager *)sharedManager;
- (void)startLocation;



@end