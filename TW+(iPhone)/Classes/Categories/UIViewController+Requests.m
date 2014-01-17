//
//  UIViewController+Requests.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-23.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "UIViewController+Requests.h"

#import "BaseViewController.h"

#import "AppAPIClient.h"

#import "MBProgressHUD.h"

#import "JsonAnalyzer.h"

#import "Constants.h"

@implementation UIViewController (Requests)

- (void)loginWithUserName:(NSString *)userName password:(NSString *)password {
    
    if ([self networkReachable]) {
        
        [[AppAPIClient sharedClient] postPath:@"api/v1/login"
                                   parameters:[self paramsWithUserName:userName password:password]
                                      success:^(AFHTTPRequestOperation *operation, id JSON) {
                                          
                                          [JsonAnalyzer analyzeAccessInfo:JSON];
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          
                                          [[NSUserDefaults standardUserDefaults] setValue:userName forKey:@"username"];
                                          [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"password"];
                                          
                                          [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccessed
                                                                                              object:nil];
                                          
                                      }
                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          
                                      }];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)loadBrandsFromeRemoteHost {
    
    if ([self canLoadRequest]) {
        
        [[AppAPIClient sharedClient] getPath:@"/api/v1/categories"
                                  parameters:nil
                                     success:^(AFHTTPRequestOperation *operation, id JSON) {
                                         
                                         [JsonAnalyzer analyzeBrand:JSON];
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         
                                         [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFinishedLoading
                                                                                             object:nil];
                                         
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"error %@", error);
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         
                                     }];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)loadDocumentsOfBrand:(Brand *)brand {
    
    if ([self canLoadRequest]) {
        
        [[AppAPIClient sharedClient] getPath:@"/api/v1/documents"
                                  parameters:[self paramsWithBrand:brand]
                                     success:^(AFHTTPRequestOperation *operation, id JSON) {
                                         
                                         [JsonAnalyzer analyzeDocument:JSON inBrand:brand];
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         
                                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                                         
                                     }];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (NSDictionary *)paramsWithBrand:(Brand *)brand {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self baseDictionary]];
    [dic setValue:brand.cId forKey:@"category_ids"];
    return dic;
}

- (NSDictionary *)paramsWithUserName:(NSString *)userName password:(NSString *)password {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[self baseDictionary]];
    [dic setValue:userName forKey:@"login"];
    [dic setValue:password forKey:@"pass"];
    return dic;
}

- (NSDictionary *)baseDictionary {
    
    return [NSDictionary dictionaryWithObject:kTWAppID forKey:@"app_id"];
}

- (BOOL)canLoadRequest {
    
    if ([self networkReachable] == NO) {
        NSLog(@"No network");
        return NO;
    }
    
    if ([self accessValid] == NO) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAuthorization object:nil];
        NSLog(@"Access expired");
        return NO;
    }
    
    return YES;
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

@end
