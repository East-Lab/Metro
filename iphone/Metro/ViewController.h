//
//  ViewController.h
//  Metro
//
//

#import <UIKit/UIKit.h>
#import "RequestUrl.h"
#import "LocationManager.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController<RequestUrlDelegate, LocationManagerDelegate, GMSMapViewDelegate>

@property (nonatomic, retain) RequestUrl *req;
@property (nonatomic, assign) NSUserDefaults *ud;


@end

