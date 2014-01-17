//
//  BaseViewController.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-20.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

#import "AppAPIClient.h"

#import "StoreManager.h"

#import "JsonAnalyzer.h"

#import "MBProgressHUD.h"

#import "SIAlertView.h"

#import "NSError+Helpers.h"

#import "NSObject+Helpers.h"

#import "UILabel+Helpers.h"

#import "NSDictionary+Params.h"

#import "UIImageView+WebCache.h"

#import "UIViewController+Helpers.h"



#import "Brand.h"

#import "Document.h"




@class LoginViewController;

@interface BaseViewController : UIViewController
{
    LoginViewController *_loginViewController;
}

@property (nonatomic, strong) LoginViewController *loginViewController;
@property (nonatomic, assign) BOOL networkReachable;
@property (nonatomic, assign) BOOL accessValid;
@property (nonatomic, assign) BOOL canLoadRequest;

- (void)authWithAnimation:(BOOL)animation;
- (BOOL)isIOS7;
- (NSDictionary *)baseDictionary;

@end
