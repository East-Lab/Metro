//
//  ViewController.m
//  Metro
//
//

#import "ViewController.h"
#import "RequestUrl.h"
#import <GoogleMaps/GoogleMaps.h>
#import "InfoWindowView.h"

@implementation ViewController{
    GMSMapView *mapView_;
    int zoom;
    UISearchBar *sb;
    GMSMarker *searchedMarker;
    UIButton *goThereBtn;
    UIAlertView *alert;
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
    sb.layer.shadowOpacity = 0.3f;
    sb.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    [sb sizeToFit];
    for (UIView *subview in sb.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    [self.view addSubview:sb];
    
    UIButton *upBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-52, self.view.frame.size.height-190, 38, 38)];
    [upBtn setTitle:@"+" forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(onTouchZoominBtn) forControlEvents:UIControlEventTouchUpInside];
    upBtn.layer.shadowOpacity = 0.3f;
    upBtn.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    upBtn.backgroundColor = [UIColor whiteColor];
    [upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:upBtn];
    
    UIButton *downBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-52, self.view.frame.size.height-142, 38, 38)];
    [downBtn setTitle:@"-" forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(onTouchZoomoutBtn) forControlEvents:UIControlEventTouchUpInside];
    downBtn.layer.shadowOpacity = 0.3f;
    downBtn.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    downBtn.backgroundColor = [UIColor whiteColor];
    [downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:downBtn];
    
    UIButton *goGroundBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 60, self.view.frame.size.width - 75, 50)];
    [goGroundBtn setTitle:@"とりあえず地下へ" forState:UIControlStateNormal];
    [goGroundBtn addTarget:self action:@selector(onTouchGoGroundBtn) forControlEvents:UIControlEventTouchUpInside];
    goGroundBtn.backgroundColor = [UIColor orangeColor];
    [goGroundBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goGroundBtn.layer.shadowOpacity = 0.3f;
    goGroundBtn.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    [self.view addSubview:goGroundBtn];
}


#pragma mark - RequestUrlDelegate method

- (void)onSuccessRequest:(NSData *)data {
    NSError *error = nil;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    [self place2PointMarker:dic];
}

- (void)onfailedRequest {
    NSLog(@"failed Request.");
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
    
    //return infoView;
    return nil;
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
    
    [goThereBtn removeFromSuperview];
    goThereBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 120, self.view.frame.size.width - 75, 50)];
    [goThereBtn setTitle:@"ここへ行く" forState:UIControlStateNormal];
    [goThereBtn addTarget:self action:@selector(onTouchGoThereBtn) forControlEvents:UIControlEventTouchUpInside];
    goThereBtn.backgroundColor = [UIColor purpleColor];
    [goThereBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    goThereBtn.layer.shadowOpacity = 0.3f;
    goThereBtn.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    [self.view addSubview:goThereBtn];
}

- (void) didFailedGeocoder:(NSString *)err{
    NSLog(@"error : %@", err);
    [self showAlert:err];
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

- (void) showNoWayAlert {
    NSLog(@"%s", __func__);
    alert =
    [[UIAlertView alloc]
     initWithTitle:@"エラー"
     message:@"地下道を通って目的地へ行く道がありません"
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    [alert show];
}

- (void) showAlert:(NSString *)msg {
    alert =
    [[UIAlertView alloc]
     initWithTitle:@"エラー"
     message:msg
     delegate:self
     cancelButtonTitle:nil
     otherButtonTitles:@"OK", nil
     ];
    [alert show];
}

- (void) onTouchGoThereBtn {
    NSLog(@"%s", __func__);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gif-animaker.sakura.ne.jp/metro/API/get2Point.php?latA=%lf&lonA=%lf&radiusA=200000&latB=35.679672&lonB=139.738541&radiusB=200000&escape=0", mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude]];
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gif-animaker.sakura.ne.jp/metro/API/get2Point.php?latA=%lf&lonA=%lf&radiusA=200000&latB=%lf&lonB=%lf&radiusB=200000&escape=0", 35.675888, 139.744858, searchedMarker.position.latitude, searchedMarker.position.longitude]];//国会議事堂
    NSLog(@"url : %@", url);
    [self.req sendAsynchronousRequest:url];
}

- (void) onTouchGoGroundBtn {
    NSLog(@"%s", __func__);
    
}

- (void)place2PointMarker:(NSDictionary *)dic {
    NSString *err_str =  dic[@"error"];
    NSInteger err = [err_str intValue];
    if (err == 0) {
        NSLog(@"count : %ld", [dic[@"result"] count]);
        if ([dic[@"result"] count] == 0) {
            [self performSelectorOnMainThread:@selector(showNoWayAlert) withObject:nil waitUntilDone:NO];
        } else {
            NSString *title =  dic[@"result"][0][@"pointA"][@"title"];
            NSString *station =  dic[@"result"][0][@"pointA"][@"station"];
            float latA =  [dic[@"result"][0][@"pointA"][@"lat"] floatValue];
            float lonA =  [dic[@"result"][0][@"pointA"][@"lon"] floatValue];
            NSLog(@"title = %@", title);
            NSLog(@"station = %@", station);
            
            GMSMarker *currentLocMarker = [[GMSMarker alloc] init];
            currentLocMarker.position = CLLocationCoordinate2DMake(mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude);
            currentLocMarker.title = @"現在地";
            currentLocMarker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
            currentLocMarker.map = mapView_;
            
            GMSMarker *markerA = [[GMSMarker alloc] init];
            markerA.position = CLLocationCoordinate2DMake(latA, lonA);
            markerA.title = title;
            markerA.snippet = station;
            markerA.icon = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
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
            markerB.icon = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
            markerB.map = mapView_;
            
            GMSMutablePath *path = [GMSMutablePath path];
            [path addCoordinate:CLLocationCoordinate2DMake(latA, lonA)];
            [path addCoordinate:CLLocationCoordinate2DMake(latB, lonB)];
            GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
            polyline.strokeWidth = 5.f;
            polyline.strokeColor = [UIColor redColor];
            polyline.map = mapView_;
        }
    } else {
        NSLog(@"%ld", [dic[@"result"] count]);
    }
}
@end