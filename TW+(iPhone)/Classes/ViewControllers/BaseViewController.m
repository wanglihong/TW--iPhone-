//
//  BaseViewController.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-20.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "BaseViewController.h"

#import "LoginViewController.h"




@interface BaseViewController () <LoginViewControllerDelegate>

@end




@implementation BaseViewController

@synthesize loginViewController = _loginViewController;
@synthesize networkReachable = _networkReachable;
@synthesize accessValid = _accessValid;
@synthesize canLoadRequest = _canLoadRequest;


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)authWithAnimation:(BOOL)animation
{
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    _loginViewController = [loginStoryboard instantiateInitialViewController];
    _loginViewController.view.frame = self.view.bounds;
    _loginViewController.delegate = self;
    [self presentViewController:_loginViewController animated:animation completion:nil];
}

- (BOOL)networkReachable
{
    switch ([AppAPIClient sharedClient].networkReachabilityStatus) {
            
        case AFNetworkReachabilityStatusNotReachable:
            return NO;
            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return YES;
            break;
            
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return YES;
            break;
            
        case AFNetworkReachabilityStatusUnknown:
            return NO;
            break;
            
        default:
            return NO;
            break;
    }
}

- (BOOL)accessValid
{
    NSString *expiresDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"expires_on"];
    if ( expiresDate && ([[NSDate date] timeIntervalSince1970] < [expiresDate doubleValue]) )
        return YES;
    else
        return NO;
}

- (BOOL)canLoadRequest {
    
    if ([self networkReachable] == NO) {
        NSLog(@"No network");
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"错误" andMessage:@"没有网络"];
        [alertView addButtonWithTitle:@"Ok" type:SIAlertViewButtonTypeDefault handler:nil];
        [alertView show];
        return NO;
    }
    
    if ([self accessValid] == NO) {
        NSLog(@"Access expired");
        [self authWithAnimation:YES];
        return NO;
    }
    
    return YES;
}

- (BOOL)isIOS7 {

    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0;
}

- (NSDictionary *)baseDictionary {
    
    return [NSDictionary dictionaryWithObject:kTWAppID forKey:@"app_id"];
}

@end
