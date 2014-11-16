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

@property (strong, nonatomic) CLGeocoder *geocoder;

@property (nonatomic,strong) id<LocationManagerDelegate> delegate;

+ (LocationManager *)sharedManager;
- (void)findLocation:(NSString *)location;
- (void)start;



@end