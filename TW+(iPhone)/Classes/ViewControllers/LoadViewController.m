//
//  LoadViewController.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-23.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "LoadViewController.h"

#import "MainViewController.h"




@interface LoadViewController ()

@end




@implementation LoadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backgroundImageView.image = [UIImage imageNamed:@"Default-568h.png"];
    backgroundImageView.contentMode = UIViewContentModeBottom;
    [self.view addSubview:backgroundImageView];
    
    [self initReachabilityStatus];
}

- (void)initReachabilityStatus
{
    [[AppAPIClient sharedClient] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"AFNetworkReachabilityStatusNotReachable");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"AFNetworkReachabilityStatusReachableViaWiFi");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"AFNetworkReachabilityStatusReachableViaWWAN");
                break;
                
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"AFNetworkReachabilityStatusUnknown");
                break;
                
            default:
                break;
        }
        
        [self dismiss];
    }];
}

- (void)dismiss
{
    if (self.view.superview) {
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             self.view.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             [self.view removeFromSuperview];
                         }];
        
//        [[self mainViewController] loadBrandsFromeRemoteHost];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadBrandsFromeRemoteHost" object:nil];
    }
}

- (MainViewController *)mainViewController
{
    return (MainViewController *)[(UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController] topViewController];;
}

@end
