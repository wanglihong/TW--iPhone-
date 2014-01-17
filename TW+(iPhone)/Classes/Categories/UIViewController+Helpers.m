//
//  UIViewController+Helpers.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-22.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "UIViewController+Helpers.h"

#import "Constants.h"

@implementation UIViewController (Helpers)

- (void)styleNavigationBarWithFontName:(NSString*)fontName {
    
    UIImage *backgroundImage = [self imageWithColor:THEME_COLOR_FULL size:CGSizeMake(320, 64)];
    UIImage *shadowImage = [self imageWithColor:[UIColor colorWithWhite:0.9 alpha:0.0] size:CGSizeMake(1, 1)];
    
    NSDictionary *titleTextAttributes = @{UITextAttributeTextColor: [UIColor whiteColor],
                                          UITextAttributeFont:[UIFont fontWithName:fontName size:18.0f],
                                          UITextAttributeTextShadowOffset:[NSValue valueWithCGSize:CGSizeMake(0.0, 0.0)]};
    
    
    // To apply image to all your navigation bars, use the appearance proxy:
    //UINavigationBar* navAppearance = [UINavigationBar appearance];
    // For an individual bar:
    UINavigationBar* navAppearance = self.navigationController.navigationBar;
    [navAppearance setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    [navAppearance setTitleTextAttributes:titleTextAttributes];
    [navAppearance setShadowImage:shadowImage];
}

- (void)styleNavigationBarButtonItemWithImage:(NSString *)imgName action:(SEL)action isLeft:(BOOL)left {

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [backBtn setFrame:CGRectMake(0, 0, 32, 32)];
    [backBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    if (left) {
        self.navigationItem.leftBarButtonItem = item;
    } else {
        self.navigationItem.rightBarButtonItem = item;
    }
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {

    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0, 0, size.width, size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIViewController *)applicationRootViewController {
    
    return [[[UIApplication sharedApplication] keyWindow] rootViewController];
}

@end
