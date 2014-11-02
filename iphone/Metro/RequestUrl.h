//
//  RequestUrl.h
//  Metro
//
//

#import <Foundation/Foundation.h>

@protocol RequestUrlDelegate <NSObject>

- (void)onSuccessRequest2Point:(NSData *)data;
- (void)onSuccessRequestPOI:(NSData *)data;
- (void)onSuccessRequestNearPlace:(NSData *)data;
- (void)onSuccessRequestRoute:(NSData *)data;
- (void)onFailedRequest:(NSString *)err;

@end

@interface RequestUrl : NSObject

- (void)sendAsynchronousRequestFor2Point:(NSURL *)url;
- (void)sendAsynchronousRequestForPOI:(NSURL *)url;
- (void)sendAsynchronousRequestForNearPlace:(NSURL *)url;
- (void)sendAsynchronousRequestForRoute:(NSURL *)url;

@property (nonatomic, assign) id<RequestUrlDelegate> delegate;

@end
