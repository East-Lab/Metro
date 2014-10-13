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

- (void)onSuccessRequest:(NSData *)data {
    NSLog(@"data:%@",data);
    NSString *str = [NSString stringWithFormat:@"%@",data];
    NSString *decodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)str,CFSTR(""),kCFStringEncodingUTF8));
    NSLog(@"str:%@",decodedString);
    //NSString *json = [NSString stringWithFormat:@"%@",data];
    //NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    //NSError *error = nil;
    //NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    //if (error != nil) {
    //    NSLog(@"failed to parse Json %ld", (long)error.code);
    //    return;
    //}
    //NSLog(@"name = %@", dic[@"error"]);
    
}

- (void)onfailedRequest {
    NSLog(@"%s",__func__);
}

@end
