//
//  ViewController.h
//  Metro
//
//

#import <UIKit/UIKit.h>
#import "RequestUrl.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController<RequestUrlDelegate, GMSMapViewDelegate, UISearchBarDelegate, UITextFieldDelegate>

@property (nonatomic, retain) RequestUrl *req;
@property (nonatomic, assign) NSUserDefaults *ud;

@end

