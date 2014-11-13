//
//  RequestUrl.m
//  Metro
//

#import "RequestUrl.h"
#import <UIKit/UIKit.h>

@implementation RequestUrl

@synthesize delegate;

// 非同期通信メソッド
- (void)sendAsynchronousRequestFor2Point:(NSURL *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *resData, NSError *error) {
        application.networkActivityIndicatorVisible = NO;
        if(error) {
            NSLog(@"error: %@", error);
            if (delegate) {
                [delegate onFailedRequest:error.description];
            }
        } else {
            //NSLog(@"resData: %@", resData);
            if (delegate) {
                [delegate onSuccessRequest2Point:resData];
            }
        }
    }];
}

- (void)sendAsynchronousRequestForPOI:(NSURL *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *resData, NSError *error) {
        application.networkActivityIndicatorVisible = NO;
        if(error) {
            NSLog(@"error: %@", error);
            if (delegate) {
                [delegate onFailedRequest:error.description];
            }
        } else {
            //NSLog(@"resData: %@", resData);
            if (delegate) {
                [delegate onSuccessRequestPOI:resData];
            }
        }
    }];
}

- (void)sendAsynchronousRequestForNearPlace:(NSURL *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *resData, NSError *error) {
        application.networkActivityIndicatorVisible = NO;
        if(error) {
            NSLog(@"error: %@", error);
            if (delegate) {
                [delegate onFailedRequest:error.description];
            }
        } else {
            //NSLog(@"resData: %@", resData);
            if (delegate) {
                [delegate onSuccessRequestNearPlace:resData];
            }
        }
    }];
}

- (void)sendAsynchronousRequestForRoute:(NSURL *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *resData, NSError *error) {
        application.networkActivityIndicatorVisible = NO;
        if(error) {
            NSLog(@"error: %@", error);
            if (delegate) {
                [delegate onFailedRequest:error.description];
            }
        } else {
            //NSLog(@"resData: %@", resData);
            if (delegate) {
                [delegate onSuccessRequestRoute:resData];
            }
        }
    }];
}

- (void)sendAsynchronousRequestFor2PointRouteA:(NSURL *)urlA
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlA cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *resData, NSError *error) {
        application.networkActivityIndicatorVisible = NO;
        if(error) {
            NSLog(@"error: %@", error);
            if (delegate) {
                [delegate onFailedRequest:error.description];
            }
        } else {
            if (delegate) {
                [delegate onSuccessRequest2PointRouteA:resData];
            }
        }
    }];
}

- (void)sendAsynchronousRequestFor2PointRouteB:(NSURL *)urlB
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:urlB cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    UIApplication *application = [UIApplication sharedApplication];
    application.networkActivityIndicatorVisible = YES;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *resData, NSError *error) {
        application.networkActivityIndicatorVisible = NO;
        if(error) {
            NSLog(@"error: %@", error);
            if (delegate) {
                [delegate onFailedRequest:error.description];
            }
        } else {
            if (delegate) {
                [delegate onSuccessRequest2PointRouteB:resData];
            }
        }
    }];
}


@end
