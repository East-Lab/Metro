//
//  ViewController.h
//  Metro
//
//

#import <UIKit/UIKit.h>
#import "RequestUrl.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LocationManager.h"

@interface ViewController : UIViewController<RequestUrlDelegate, GMSMapViewDelegate, UISearchBarDelegate, LocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSString *searchText;
@property (nonatomic, retain) RequestUrl *req;
@property (nonatomic, assign) NSUserDefaults *ud;

@end

