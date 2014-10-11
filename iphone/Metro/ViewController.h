//
//  ViewController.h
//  Metro
//
//  Created by 川島 大地 on 2014/10/06.
//  Copyright (c) 2014年 川島 大地. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestUrl.h"

@interface ViewController : UIViewController<RequestUrlDelegate>

@property (nonatomic, retain) RequestUrl *req;


@end

