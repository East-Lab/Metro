//
//  RequestUrl.m
//  Metro
//

#import "RequestUrl.h"

@implementation RequestUrl

@synthesize delegate;

// 非同期通信メソッド
- (void)sendAsynchronousRequest:(NSURL *)url
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *resData, NSError *error) {
        if(error) {
            NSLog(@"error: %@", error);
            if (delegate) {
                [delegate onfailedRequest];
            }
        } else {
            //NSLog(@"resData: %@", resData);
            if (delegate) {
                [delegate onSuccessRequest:resData];
            }
        }
    }];
}

@end
