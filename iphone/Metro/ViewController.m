//
//  ViewController.m
//  Metro
//
//  Created by 川島 大地 on 2014/10/06.
//  Copyright (c) 2014年 川島 大地. All rights reserved.
//

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
    NSURL *url = [NSURL URLWithString:@"http://gif-animaker.sakura.ne.jp/metro/API/get2Point.php?latA=35.675742&lonA=139.738220&radiusA=200000&latB=35.679672&lonB=139.738541&radiusB=200000"];
    [self.req sendAsynchronousRequest:url];
}

- (void)onSuccessRequest {
    NSLog(@"%s",__func__);
}

- (void)onfailedRequest {
    NSLog(@"%s",__func__);
}

@end
