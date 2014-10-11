//
//  RequestUrl.h
//  Metro
//
//  Created by 川島 大地 on 2014/10/11.
//  Copyright (c) 2014年 川島 大地. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequestUrlDelegate <NSObject>

- (void)onSuccessRequest;
- (void)onfailedRequest;

@end

@interface RequestUrl : NSObject

- (void)sendAsynchronousRequest:(NSURL *)url;

@property (nonatomic, assign) id<RequestUrlDelegate> delegate;

@end
