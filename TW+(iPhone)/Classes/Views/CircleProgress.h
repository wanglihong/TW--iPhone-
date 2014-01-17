//
//  CircleProgress.h
//  TW+
//
//  Created by Dennis Yang on 13-8-8.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgress : UIView

- (id)initWithFrame:(CGRect)frame bgColor:(UIColor *)bgc pgColor:(UIColor *)pgc width:(CGFloat)wid;

- (void)updateProgress:(float)progress;

@end
