//
//  ViewController.m
//  Metro
//
//

#import "ViewController.h"
#import "RequestUrl.h"
#import <GoogleMaps/GoogleMaps.h>
#import "LocationManager.h"

@implementation ViewController{
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    [LocationManager sharedManager].delegate = self;

    _req = [RequestUrl new];
    _req.delegate = self;
    
    self.ud = [NSUserDefaults standardUserDefaults];
    [self showInitialMap];
    
    
    NSURL *url = [NSURL URLWithString:@"http://gif-animaker.sakura.ne.jp/metro/API/get2Point.php?latA=35.675742&lonA=139.738220&radiusA=200000&latB=35.679672&lonB=139.738541&radiusB=200000&escape=0"];
    [self.req sendAsynchronousRequest:url];
    
    //NSTimer *timer = [NSTimer
    //                  scheduledTimerWithTimeInterval:1.5
    //                  target:self
    //                  selector:@selector(updateMap:)
    //                  userInfo:nil
    //                  repeats:YES
    //                  ];
    //[timer fire];
}

-(void) updateMap
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[LocationManager sharedManager].lat
                                                            longitude:[LocationManager sharedManager].lon
                                                                 zoom:19];
    [mapView_ animateToCameraPosition:camera];
}

- (void)showInitialMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.ud floatForKey:@"lat"]
                                                            longitude:[self.ud floatForKey:@"lon"]
                                                                 zoom:18];
    mapView_.delegate = self;
    mapView_.settings.myLocationButton = YES;
    mapView_.myLocationEnabled = YES;
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = mapView_;
    
    
    UISearchBar *sb = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 44.0f)];
    [self.view addSubview:sb];
}

- (void)place2PointMarker:(NSDictionary *)dic {
    NSString *title =  dic[@"result"][0][@"pointA"][@"title"];
    NSString *station =  dic[@"result"][0][@"pointA"][@"station"];
    float latA =  [dic[@"result"][0][@"pointA"][@"lat"] floatValue];
    float lonA =  [dic[@"result"][0][@"pointA"][@"lon"] floatValue];
    NSLog(@"title = %@", title);
    NSLog(@"station = %@", station);
    GMSMarker *markerA = [[GMSMarker alloc] init];
    markerA.position = CLLocationCoordinate2DMake(latA, lonA);
    markerA.title = title;
    markerA.snippet = station;
    markerA.map = mapView_;
    
    title =  dic[@"result"][0][@"pointB"][@"title"];
    station =  dic[@"result"][0][@"pointB"][@"station"];
    float latB =  [dic[@"result"][0][@"pointB"][@"lat"] floatValue];
    float lonB =  [dic[@"result"][0][@"pointB"][@"lon"] floatValue];
    NSLog(@"title = %@", title);
    NSLog(@"station = %@", station);
    GMSMarker *markerB = [[GMSMarker alloc] init];
    markerB.position = CLLocationCoordinate2DMake(latB, lonB);
    markerB.title = title;
    markerB.snippet = station;
    markerB.map = mapView_;
    
    GMSMutablePath *path = [GMSMutablePath path];
    [path addCoordinate:CLLocationCoordinate2DMake(latA, lonA)];
    [path addCoordinate:CLLocationCoordinate2DMake(latB, lonB)];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 5.f;
    polyline.strokeColor = [UIColor redColor];
    polyline.map = mapView_;
}

- (void)onSuccessRequest:(NSData *)data {
    NSError *error = nil;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self place2PointMarker:dic];
}

- (void)onfailedRequest {
    
}

#pragma mark  - LocationManagerDelegate method
- (void)updateHeadingInformation {
    NSLog(@"%s",__func__);
    [self.ud setFloat:[LocationManager sharedManager].lat forKey:@"lat"];
    [self.ud setFloat:[LocationManager sharedManager].lon forKey:@"lon"];
}

- (void)updateLocationInfomation {
    NSLog(@"%s",__func__);
}

@end

/*
#import "ViewController.h"
#import "RequestUrl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _req = [RequestUrl new];
    _req.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTouchBtn:(id)sender {
    NSLog(@"%s",__func__);
    NSURL *url = [NSURL URLWithString:@"http://gif-animaker.sakura.ne.jp/metro/API/get2Point.php?latA=35.675742&lonA=139.738220&radiusA=200000&latB=35.679672&lonB=139.738541&radiusB=200000&escape=0"];
    [self.req sendAsynchronousRequest:url];
}

- (void)onSuccessRequest:(NSData *)data {
    NSLog(@"data:%@",data);
    NSError *error = nil;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"name = %@", dic[@"result"][0][@"pointA"][@"title"]);
    
}

- (void)onfailedRequest {
    NSLog(@"%s",__func__);
}

@end

*/