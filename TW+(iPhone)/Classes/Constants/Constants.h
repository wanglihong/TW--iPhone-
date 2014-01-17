//
//  Constants.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-21.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#define kTWAppID                        @"51dd11b447961943520001da"
#define kAPIBaseURLString               @"http://tw.umaman.com/"

#define kNotificationFinishedLoading    @"kNotificationFinishedLoading"
#define kNotificationAuthorization      @"kNotificationAuthorization"
#define kNotificationLoginSuccessed     @"kNotificationLoginSuccessed"

#define UMENG_APPKEY                    @"5244e38056240bea42061cce"     // 友盟统计 appkey

#define THEME_COLOR_FULL                [UIColor colorWithRed:47.0/255 green:168.0/255 blue:228.0/255 alpha:1.0f]
#define THEME_COLOR_TRANSLUCENT         [UIColor colorWithRed:47.0/255 green:168.0/255 blue:228.0/255 alpha:0.4]
#define THEME_COLOR_DARK                [UIColor colorWithRed:10.0/255 green:78.0/255 blue:108.0/255 alpha:1.0f]

#define __IPHONE_5__                    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                        CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define __IPHONE_4__                    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                        CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define __IOS_0_7_                      [[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0

#define NO_RESULTS_LABEL_TAG            1001