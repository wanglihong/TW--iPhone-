//
//  UIViewController+Requests.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-23.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Brand.h"

@interface UIViewController (Requests)

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password;
- (void)loadBrandsFromeRemoteHost;
- (void)loadDocumentsOfBrand:(Brand *)brand;

@end
