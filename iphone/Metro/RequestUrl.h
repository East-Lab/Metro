//
//  RequestUrl.h
//  Metro
//
//

#import <Foundation/Foundation.h>

@protocol RequestUrlDelegate <NSObject>

- (void)onSuccessRequest:(NSData *)data;
- (void)onfailedRequest;

@end

@interface RequestUrl : NSObject

- (void)sendAsynchronousRequest:(NSURL *)url;

@property (nonatomic, assign) id<RequestUrlDelegate> delegate;

@end
