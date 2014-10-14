//
//  InfoWindowView.h
//  Metro
//
//  Created by 川島 大地 on 2014/10/15.
//  Copyright (c) 2014年 川島 大地. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoWindowView : UIView

+ (instancetype)view;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *snippet;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
