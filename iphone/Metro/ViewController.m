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
    GMSMarker *nearPOImarker;
    GMSMarker *currentLocMarker;
    GMSMarker *markerA;
    GMSMarker *markerB;
    UIButton *goThereBtn;
    UIAlertView *alert;
    GMSPolyline *polyline;
    GMSPolyline *polyline1;
    GMSPolyline *polyline2;
    GMSPolyline *polylineA;
    GMSPolyline *polylineB;
    NSInteger mode;
    UITableView *tb;
    NSDictionary *d;
    GMSMutablePath *p1;
    GMSMutablePath *p2;
    GMSMutablePath *pa;
}

typedef NS_ENUM (NSInteger, modeNum) {
    goDestination,
    goGround
};

- (void)viewDidLoad {
    [GMSMarker markerImageWithColor:[UIColor blueColor]];
    
    mode = goGround;

    _req = [RequestUrl new];
    _req.delegate = self;
    
    zoom = 18;
    
    self.ud = [NSUserDefaults standardUserDefaults];
    [self showInitialMap];
    
    //[LocationManager sharedManager].delegate = self;
    [GoogleMapsAPIManager sharedManager].delegate = self;
    
    
}

- (void)showInitialMap{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.ud floatForKey:@"lat"]longitude:[self.ud floatForKey:@"lon"] zoom:[self.ud floatForKey:@"zoom"]];
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    [self.view addSubview:mapView_];
    //self.view = mapView_;
    mapView_.myLocationEnabled = YES;
    mapView_.delegate = self;
    mapView_.settings.myLocationButton = YES;
    mapView_.settings.compassButton = YES;
    mapView_.settings.indoorPicker = NO;
    
    sb = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 22, self.view.bounds.size.width - 20, 44.0f)];
    sb.showsCancelButton = YES;
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
    goGroundBtn.layer.cornerRadius = 25.0f;
    [goGroundBtn setTitle:@"とりあえず地下へ" forState:UIControlStateNormal];
    [goGroundBtn addTarget:self action:@selector(onTouchGoGroundBtn) forControlEvents:UIControlEventTouchUpInside];
    goGroundBtn.backgroundColor = [UIColor colorWithRed:0.28 green:0.28 blue:0.29 alpha:1.0];
    [goGroundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goGroundBtn.layer.shadowOpacity = 0.3f;
    goGroundBtn.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    [self.view addSubview:goGroundBtn];
}


#pragma mark - RequestUrlDelegate method
- (void)onSuccessRequestPOI:(NSData *)data {
    NSError *error = nil;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //[self placePOIMarker:dic];
    [self performSelectorOnMainThread:@selector(placePOIMarker:) withObject:dic waitUntilDone:NO];
}

- (void)onSuccessRequest2Point:(NSData *)data {
    NSError *error = nil;
    NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    //[self place2PointMarker:dic];
    [self performSelectorOnMainThread:@selector(place2PointMarker:) withObject:dic waitUntilDone:NO];
}

- (void)onSuccessRequestNearPlace:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        d = dic;
        
        tb = [[UITableView alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width-20, self.view.frame.size.height-300) style:UITableViewStylePlain];
        tb.delegate = self;
        tb.dataSource = self;
        [self.view addSubview:tb];
    });
}

- (void)onSuccessRequest2PointRouteA:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSDictionary *di = dic;
        NSString *enc_path = [NSString stringWithFormat:@"%@",di[@"polyline"]];
        p1 = [GMSMutablePath pathFromEncodedPath:enc_path];
        NSURL *urlB = [NSURL URLWithString:[NSString stringWithFormat:@"http://gif-animaker.sakura.ne.jp/metro/API/getRoute.php?latA=%lf&lonA=%lf&latB=%lf&lonB=%lf&escape=true", markerB.position.latitude, markerB.position.longitude, searchedMarker.position.latitude, searchedMarker.position.longitude]];
        [self.req sendAsynchronousRequestFor2PointRouteB:urlB];
        
        pa = [GMSMutablePath path];
        int c = (int)[di[@"res"] count];
        c -= 1;
        NSLog(@"c : %d", c);
        [pa addCoordinate:CLLocationCoordinate2DMake([di[@"res"][c][@"lat"] floatValue], [di[@"res"][c][@"lon"] floatValue])];
        [pa addCoordinate:markerA.position];
    });
}

- (void)onSuccessRequest2PointRouteB:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSDictionary *di = dic;
        NSString *enc_path = [NSString stringWithFormat:@"%@",di[@"polyline"]];
        p2 = [GMSMutablePath pathFromEncodedPath:enc_path];
        
        polyline.map = nil;
        polyline1.map = nil;
        polyline2.map = nil;
        polylineA.map = nil;
        polylineB.map = nil;
        polyline1 = [GMSPolyline polylineWithPath:p1];
        polyline2 = [GMSPolyline polylineWithPath:p2];
        polyline1.strokeWidth = 5.f;
        polyline2.strokeWidth = 5.f;
        polyline1.strokeColor = [UIColor redColor];
        polyline2.strokeColor = [UIColor redColor];
        polyline1.map = mapView_;
        polyline2.map = mapView_;
        
        polylineA = [GMSPolyline polylineWithPath:pa];
        polylineA.strokeWidth = 5.f;
        polylineA.strokeColor = [UIColor redColor];
        polylineA.map = mapView_;
        
        GMSMutablePath *path = [GMSMutablePath path];
        CLLocationCoordinate2D pos;
        pos.latitude = [di[@"res"][0][@"lat"] floatValue];
        pos.longitude = [di[@"res"][0][@"lon"] floatValue];
        [path addCoordinate:pos];
        [path addCoordinate:markerB.position];
        polylineB = [GMSPolyline polylineWithPath:path];
        polylineB.strokeWidth = 5.f;
        polylineB.strokeColor = [UIColor redColor];
        polylineB.map = mapView_;
        
        path = [GMSMutablePath path];
        [path addCoordinate:markerA.position];
        [path addCoordinate:markerB.position];
        polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeWidth = 5.f;
        polyline.strokeColor = [UIColor grayColor];
        polyline.map = mapView_;
        
    });
}

- (void)onSuccessRequestRoute:(NSData *)data {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error = nil;
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        NSDictionary *di = dic;
        NSString *enc_path = [NSString stringWithFormat:@"%@",di[@"polyline"]];
        NSLog(@"%@", enc_path);
        GMSMutablePath *path = [GMSMutablePath pathFromEncodedPath:enc_path];
        
        polyline1.map =nil;
        polyline2.map =nil;
        polylineA.map =nil;
        polylineB.map =nil;
        polyline.map = nil;
        polyline = [GMSPolyline polylineWithPath:path];
        polyline.strokeWidth = 5.f;
        polyline.strokeColor = [UIColor redColor];
        polyline.map = mapView_;
        
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake((mapView_.myLocation.coordinate.latitude + nearPOImarker.position.latitude)/2, (mapView_.myLocation.coordinate.longitude + nearPOImarker.position.longitude)/2);
        CLLocation *A = [[CLLocation alloc] initWithLatitude:nearPOImarker.position.latitude longitude:nearPOImarker.position.longitude];
        CLLocation *B = [[CLLocation alloc] initWithLatitude:mapView_.myLocation.coordinate.latitude longitude:mapView_.myLocation.coordinate.longitude];
        
        CLLocationDistance distance = [A distanceFromLocation:B];
        float z = [GMSCameraPosition zoomAtCoordinate:loc forMeters:distance perPoints:300];
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:loc.latitude longitude:loc.longitude zoom:z];
        [mapView_ animateToCameraPosition:camera];
    });
}

- (void)onFailedRequest:(NSString *)err{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlert:err];
    });
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
    [[GoogleMapsAPIManager sharedManager] getGeoByKeyword:self.searchText];
}

-(void)searchBarCancelButtonClicked:(UISearchBar*)searchBar {
    [searchBar resignFirstResponder];
    [tb removeFromSuperview];
    [tb removeFromSuperview];
    [tb removeFromSuperview];
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText {
    self.searchText = searchText;
    if ([searchText length] != 0) {
        [tb removeFromSuperview];
    } else {
        //[self getNearPlace];
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self getNearPlace];
}

- (void)getNearPlace {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gif-animaker.sakura.ne.jp/metro/API/getAroundPlace.php?lat=%lf&lon=%lf&radius=2000", mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude]];
    NSLog(@"url : %@", url);
    [self.req sendAsynchronousRequestForNearPlace:url]; 
}

#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"hoge");
    //NSLog(@"%@", d[@"result"][0][@"name"]);
    NSLog(@"%lu", (unsigned long)[d[@"result"] count]);
    //return [d[@"result"] count];
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = d[@"result"][indexPath.row][@"name"];
    //NSLog(@"%@", d[@"result"][0][@"name"]);
    //cell.textLabel.text = @"hoge";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [d[@"result"][indexPath.row][@"location"][@"lat"] floatValue];
    coordinate.longitude = [d[@"result"][indexPath.row][@"location"][@"lng"] floatValue];
    NSLog(@"lat:%lf, lon:%lf", coordinate.latitude, coordinate.longitude);
    NSString *title = d[@"result"][indexPath.row][@"name"];
    [self markDestinationPlace:coordinate withTitle:title];
    [tb removeFromSuperview];
}

#pragma mark - GoogleMapsAPIManagerDelegate method
- (void) onSuccessGetGoogleGeoByKeyword:(NSString *)name andLat:(float)lat andLon:(float)lon {
    NSLog(@"%lf",lat);
    NSLog(@"%lf",lon);
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lon);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self markDestinationPlace:coordinate withTitle:name];
    });
}

-(void) onFailedGoogleRequest:(NSString *)err {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlert:err];
    });
}

#pragma mark - LocationManagerDelegate method
- (void) didCompleteGeocoder:(CLLocationCoordinate2D)coordinate {
    [self markDestinationPlace:coordinate withTitle:self.searchText];
}

- (void) didFailedGeocoder:(NSString *)err{
    NSLog(@"error : %@", err);
    [self showAlertWithYesNo:err];
}

#pragma mark - touch btn method
-(void)onTouchZoominBtn {
    if ([self.ud floatForKey:@"zoom"] < 21) {
        zoom = [self.ud floatForKey:@"zoom"] + 1;
    } else {
        zoom = 21;
    }
    NSLog(@"zoom:%d",zoom);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.ud floatForKey:@"lat"]longitude:[self.ud floatForKey:@"lon"] zoom:zoom];
    [mapView_ animateToCameraPosition:camera];
}

-(void) onTouchZoomoutBtn {
    if ([self.ud floatForKey:@"zoom"] > 2) {
        zoom = [self.ud floatForKey:@"zoom"] - 1;
    } else {
        zoom = 2;
    }
    NSLog(@"zoom:%d",zoom);
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[self.ud floatForKey:@"lat"]longitude:[self.ud floatForKey:@"lon"] zoom:zoom];
    [mapView_ animateToCameraPosition:camera];
}

- (void) onTouchGoThereBtn {
    NSLog(@"%s", __func__);
    if (mapView_.myLocation.coordinate.latitude == 0) {
        [self showAlert:@"現在地が取得できませんでした"];
    } else {
        mode = goDestination;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gif-animaker.sakura.ne.jp/metro/API/get2Point.php?latA=%lf&lonA=%lf&radiusA=1000&latB=%lf&lonB=%lf&radiusB=200000&escape=0", mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude, searchedMarker.position.latitude, searchedMarker.position.longitude]];
        NSLog(@"url : %@", url);
        [self.req sendAsynchronousRequestFor2Point:url];
    }
}

- (void) onTouchGoGroundBtn {
    NSLog(@"%s", __func__);
    if (mapView_.myLocation.coordinate.latitude == 0) {
        [self showAlert:@"現在地が取得できませんでした"];
    } else {
        mode = goGround;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gif-animaker.sakura.ne.jp/metro/API/getMetroPOI.php?lat=%lf&lon=%lf&radius=1000", mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude]];
        NSLog(@"url : %@", url);
        [self.req sendAsynchronousRequestForPOI:url];
    }
}

#pragma mark - marker set method
- (void)placePOIMarker:(NSDictionary *)dic {
    NSString *err_str =  dic[@"error"];
    NSInteger err = [err_str intValue];
    if (err == 0) {
        NSLog(@"count : %ld", [dic[@"result"] count]);
        if ([dic[@"result"] count] == 0) {
            [self performSelectorOnMainThread:@selector(showAlertWithYesNo:) withObject:@"1km以内に駅の出入口が見つかりませんでした。範囲を広げて検索しますか？" waitUntilDone:NO];
        } else {
            NSString *title =  dic[@"result"][0][@"title"];
            float lat =  [dic[@"result"][0][@"lat"] floatValue];
            float lon =  [dic[@"result"][0][@"lon"] floatValue];
            NSLog(@"title = %@", title);
            
            [self clearMarker];
            nearPOImarker = [[GMSMarker alloc] init];
            nearPOImarker.map = mapView_;
            nearPOImarker.position = CLLocationCoordinate2DMake(lat, lon);
            nearPOImarker.title = title;
            nearPOImarker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
            nearPOImarker.map = mapView_;
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gif-animaker.sakura.ne.jp/metro/API/getRoute.php?latA=%lf&lonA=%lf&latB=%lf&lonB=%lf&escape=true", mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude, lat, lon]];
            NSLog(@"url : %@", url);
            [self.req sendAsynchronousRequestForRoute:url];
        }
    } else {
        NSLog(@"%ld", [dic[@"result"] count]);
        [self performSelectorOnMainThread:@selector(showAlertWithYesNo:) withObject:@"サーバ-エラー" waitUntilDone:NO];
    }
}

- (void)place2PointMarker:(NSDictionary *)dic {
    NSString *err_str =  dic[@"error"];
    NSInteger err = [err_str intValue];
    if (err == 0) {
        NSLog(@"count : %ld", [dic[@"result"] count]);
        if ([dic[@"result"] count] == 0) {
            [self performSelectorOnMainThread:@selector(showAlertWithYesNo:) withObject:@"1km以内に駅の出入口が見つかりませんでした。範囲を広げて検索しますか？" waitUntilDone:NO];
        } else {
            NSString *title =  dic[@"result"][0][@"pointA"][@"title"];
            NSString *station =  dic[@"result"][0][@"pointA"][@"station"];
            float latA =  [dic[@"result"][0][@"pointA"][@"lat"] floatValue];
            float lonA =  [dic[@"result"][0][@"pointA"][@"lon"] floatValue];
            NSLog(@"title = %@", title);
            NSLog(@"station = %@", station);
            
            markerA.map = nil;
            markerB.map = nil;
            currentLocMarker.map = nil;
            nearPOImarker.map = nil;
            
            currentLocMarker = [[GMSMarker alloc] init];
            currentLocMarker.position = CLLocationCoordinate2DMake(mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude);
            currentLocMarker.title = @"現在地";
            currentLocMarker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
            currentLocMarker.map = mapView_;
            
            markerA = [[GMSMarker alloc] init];
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
            markerB = [[GMSMarker alloc] init];
            markerB.position = CLLocationCoordinate2DMake(latB, lonB);
            markerB.title = title;
            markerB.snippet = station;
            markerB.icon = [GMSMarker markerImageWithColor:[UIColor yellowColor]];
            markerB.map = mapView_;
            
            
            NSURL *urlA = [NSURL URLWithString:[NSString stringWithFormat:@"http://gif-animaker.sakura.ne.jp/metro/API/getRoute.php?latA=%lf&lonA=%lf&latB=%lf&lonB=%lf&escape=true", mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude, latA, lonA]];
            [self.req sendAsynchronousRequestFor2PointRouteA:urlA];
            
            
        }
    } else if (err == 1) {
        NSLog(@"%ld", [dic[@"result"] count]);
        [self performSelectorOnMainThread:@selector(showAlertWithYesNo:) withObject:@"1km以内に駅の出入口が見つかりませんでした。範囲を広げて検索しますか？" waitUntilDone:NO];
    }
}

- (void) clearMarker {
    markerA.map = nil;
    markerB.map = nil;
    searchedMarker.map = nil;
    currentLocMarker.map = nil;
    nearPOImarker.map = nil;
}

# pragma mark - alert method
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"buttonIndex : %ld", buttonIndex);
    if (buttonIndex == 1) {
        NSURL *url;
        switch (mode) {
            case goGround:
                url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gif-animaker.sakura.ne.jp/metro/API/getMetroPOI.php?lat=%lf&lon=%lf&radius=10000000", mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude]];
                NSLog(@"url : %@", url);
                [self.req sendAsynchronousRequestForPOI:url];
                break;
            case goDestination:
                url = [NSURL URLWithString:[NSString stringWithFormat:@"http://gif-animaker.sakura.ne.jp/metro/API/get2Point.php?latA=%lf&lonA=%lf&radiusA=1000000&latB=%lf&lonB=%lf&radiusB=200000&escape=0", mapView_.myLocation.coordinate.latitude, mapView_.myLocation.coordinate.longitude, searchedMarker.position.latitude, searchedMarker.position.longitude]];
                NSLog(@"url : %@", url);
                [self.req sendAsynchronousRequestFor2Point:url];
                break;
            default:
                break;
        }
    }
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

- (void) showAlertWithYesNo:(NSString *)msg {
    alert =
    [[UIAlertView alloc]
     initWithTitle:@"エラー"
     message:msg
     delegate:self
     cancelButtonTitle:@"いいえ"
     otherButtonTitles:@"はい", nil
     ];
    [alert show];
}

- (void)markDestinationPlace:(CLLocationCoordinate2D) coordinate withTitle:(NSString *)title{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:coordinate.latitude longitude:coordinate.longitude zoom:[self.ud floatForKey:@"zoom"]];
    [mapView_ animateToCameraPosition:camera];
    polyline.map = nil;
    [self clearMarker];
    searchedMarker = [[GMSMarker alloc] init];
    searchedMarker.appearAnimation = YES;
    searchedMarker.position = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
    //searchedMarker.title = self.searchText;
    searchedMarker.title = title;
    //searchedMarker.snippet = station;
    searchedMarker.map = mapView_;
    
    [goThereBtn removeFromSuperview];
    goThereBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 120, self.view.frame.size.width - 75, 50)];
    goThereBtn.layer.cornerRadius = 25.0f;
    [goThereBtn setTitle:@"ここへ行く" forState:UIControlStateNormal];
    [goThereBtn addTarget:self action:@selector(onTouchGoThereBtn) forControlEvents:UIControlEventTouchUpInside];
    goThereBtn.backgroundColor = [UIColor colorWithRed:0.08 green:0.67 blue:0.91 alpha:1.0];
    [goThereBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    goThereBtn.layer.shadowOpacity = 0.3f;
    goThereBtn.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    [self.view addSubview:goThereBtn];
}


@end