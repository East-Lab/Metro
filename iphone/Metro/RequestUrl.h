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
- (void)onSuccessRequest2PointRouteA:(NSData *)data;
- (void)onSuccessRequest2PointRouteB:(NSData *)data;
- (void)onFailedRequest:(NSString *)err;

@end

@interface RequestUrl : NSObject

- (void)sendAsynchronousRequestFor2Point:(NSURL *)url;
- (void)sendAsynchronousRequestForPOI:(NSURL *)url;
- (void)sendAsynchronousRequestForNearPlace:(NSURL *)url;
- (void)sendAsynchronousRequestForRoute:(NSURL *)url;
- (void)sendAsynchronousRequestFor2PointRouteA:(NSURL *)url;
- (void)sendAsynchronousRequestFor2PointRouteB:(NSURL *)url;

@property (nonatomic, assign) id<RequestUrlDelegate> delegate;

@end
