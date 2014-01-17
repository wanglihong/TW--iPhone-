//
//  UIViewController+Helpers.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-22.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Helpers)

- (void)styleNavigationBarWithFontName:(NSString*)fontName;
- (void)styleNavigationBarButtonItemWithImage:(NSString *)imgName action:(SEL)action isLeft:(BOOL)left;
- (UIViewController *)applicationRootViewController;

@end
