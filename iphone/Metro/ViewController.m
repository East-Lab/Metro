//
//  ViewController.m
//  Metro
//
//

#import "ViewController.h"
#import "RequestUrl.h"
#import <GoogleMaps/GoogleMaps.h>
#import "PBFlatButton.h"

@implementation ViewController{
    GMSMapView *mapView_;
    int zoom;
}

- (void)viewDidLoad {
    [GMSMarker markerImageWithColor:[UIColor blueColor]];

    _req = [RequestUrl new];
    _req.delegate = self;
    
    zoom = 18;
    
    self.ud = [NSUserDefaults standardUserDefaults];
    [self showInitialMap];
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://gif-animaker.sakura.ne.jp/metro/API/get2Point.php?latA=35.675742&lonA=139.738220&radiusA=200000&latB=35.679672&lonB=139.738541&radiusB=200000&escape=0"];
    [self.req sendAsynchronousRequest:url];
}

-(void) updateMap {
    /*
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[LocationManager sharedManager].lat
                                                            longitude:[LocationManager sharedManager].lon
                                                                 zoom:18];
    [mapView_ animateToCameraPosition:camera];
     */
}

- (void)showInitialMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.ud floatForKey:@"lat"]longitude:[self.ud floatForKey:@"lon"] zoom:zoom];
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    [self.view addSubview:mapView_];
    //self.view = mapView_;
    mapView_.myLocationEnabled = YES;
    mapView_.delegate = self;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;
    
    UISearchBar *searchBar;
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44.0f)];
    searchBar.showsCancelButton = YES;
    searchBar.tintColor = [UIColor whiteColor];
    searchBar.delegate = self;
    searchBar.placeholder = @"目的地を入力してください";
    [searchBar sizeToFit];
    [self.view addSubview:searchBar];
    
    [[PBFlatSettings sharedInstance] setBackgroundColor:[UIColor whiteColor]];
    PBFlatButton *upBtn = [[PBFlatButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-52, self.view.frame.size.height-180, 38, 38)];
    [upBtn setTitle:@"+" forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(onTouchZoominBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upBtn];
    
    PBFlatButton *downBtn = [[PBFlatButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-52, self.view.frame.size.height-142, 38, 38)];
    [downBtn setTitle:@"-" forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(onTouchZoomoutBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downBtn];
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

#pragma mark - RequestUrlDelegate method

- (void)onSuccessRequest:(NSData *)data {
    NSError *error = nil;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self place2PointMarker:dic];
}

- (void)onfailedRequest {
    
}

#pragma mapview delegate
-(void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    [self.ud setFloat:position.target.longitude forKey:@"lon"];
    [self.ud setFloat:position.target.latitude forKey:@"lat"];
    [self.ud setFloat:position.zoom forKey:@"zoom"];
}

#pragma mark - search bar delegate method

-(void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar*)searchBar {
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText {
}

#pragma mark - private method
-(void)onTouchZoominBtn {
    if (zoom < 21) {
        zoom = [self.ud floatForKey:@"zoom"] + 1;
    } else {
        zoom = 21;
    }
    NSLog(@"zoom:%d",zoom);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.ud floatForKey:@"lat"]longitude:[self.ud floatForKey:@"lon"] zoom:zoom];
    [mapView_ animateToCameraPosition:camera];
}

-(void)onTouchZoomoutBtn {
    if (zoom > 2) {
        zoom = [self.ud floatForKey:@"zoom"] - 1;
    } else {
        zoom = 2;
    }
    NSLog(@"zoom:%d",zoom);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.ud floatForKey:@"lat"]longitude:[self.ud floatForKey:@"lon"] zoom:zoom];
    [mapView_ animateToCameraPosition:camera];
}


@end