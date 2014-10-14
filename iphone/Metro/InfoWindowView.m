//
//  InfoWindowView.m
//  Metro
//
//  Created by 川島 大地 on 2014/10/15.
//  Copyright (c) 2014年 川島 大地. All rights reserved.
//

#import "InfoWindowView.h"

@implementation InfoWindowView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.title.text = @"title";
    self.snippet.text = @"snipet";
}

+ (instancetype)view
{
    NSString *className = NSStringFromClass([self class]);
    return [[[NSBundle mainBundle] loadNibNamed:className owner:nil options:0] firstObject];
}

- (IBAction)onTapBtn:(id)sender {
    NSLog(@"tap");
}

@end
