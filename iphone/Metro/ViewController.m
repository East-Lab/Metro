//
//  ViewController.m
//  Metro
//
//

#import "ViewController.h"
#import "RequestUrl.h"
#import <GoogleMaps/GoogleMaps.h>
#import "PBFlatButton.h"
#import "InfoWindowView.h"

@implementation ViewController{
    GMSMapView *mapView_;
    int zoom;
    UISearchBar *sb;
    GMSMarker *searchedMarker;
}

- (void)viewDidLoad {
    [GMSMarker markerImageWithColor:[UIColor blueColor]];
     searchedMarker = [[GMSMarker alloc] init];

    _req = [RequestUrl new];
    _req.delegate = self;
    
    zoom = 18;
    
    self.ud = [NSUserDefaults standardUserDefaults];
    [self showInitialMap];
    
    [LocationManager sharedManager].delegate = self;
    
    
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
    mapView_.settings.indoorPicker = NO;
    
    sb = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 22, self.view.bounds.size.width - 20, 44.0f)];
    sb.showsCancelButton = NO;
    sb.delegate = self;
    sb.placeholder = @"目的地を入力してください";
    sb.backgroundImage = [[UIImage alloc] init];
    [sb setBackgroundColor:[UIColor whiteColor]];
    [sb sizeToFit];
    for (UIView *subview in sb.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    [self.view addSubview:sb];
    
    [[PBFlatSettings sharedInstance] setBackgroundColor:[UIColor whiteColor]];
    //[[PBFlatSettings sharedInstance] setMainColor:[UIColor whiteColor]];
    [[PBFlatSettings sharedInstance] setTextFieldPlaceHolderColor:[UIColor blackColor]];
    [[PBFlatSettings sharedInstance] setIconImageColor:[UIColor blackColor]];
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
- (void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    [sb resignFirstResponder];
    [self.ud setFloat:position.target.longitude forKey:@"lon"];
    [self.ud setFloat:position.target.latitude forKey:@"lat"];
    [self.ud setFloat:position.zoom forKey:@"zoom"];
}

- (void) mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [sb resignFirstResponder];
}

- (UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    NSLog(@"hoge");
    InfoWindowView *infoView = [InfoWindowView view];
    infoView.title.text = marker.title;
    infoView.snippet.text = marker.snippet;
    
    //UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    //v.backgroundColor = [UIColor whiteColor];
    //UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    //l.text = marker.title;
    //[v addSubview:l];
    return infoView;
}

#pragma mark - search bar delegate method

-(void)searchBarSearchButtonClicked:(UISearchBar*)searchBar {
    [searchBar resignFirstResponder];
    NSLog(@"searchText : %@", self.searchText);
    [[LocationManager sharedManager] findLocation:self.searchText];
}

-(void)searchBarCancelButtonClicked:(UISearchBar*)searchBar {
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText {
    self.searchText = searchText;
}

#pragma mark - LocationManagerDelegate method
- (void) didCompleteGeocoder:(CLLocationCoordinate2D)coordinate {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:zoom];
    [mapView_ animateToCameraPosition:camera];
    searchedMarker.appearAnimation = YES;
    searchedMarker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    searchedMarker.title = self.searchText;
    //searchedMarker.snippet = station;
    searchedMarker.map = mapView_;
}

- (void) didFailedGeocoder:(NSString *)err{
    NSLog(@"error : %@", err);
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