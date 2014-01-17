//
//  NSError+Helpers.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-27.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "NSError+Helpers.h"

@implementation NSError (Helpers)

- (NSString *)message
{
    NSLog(@"%@", self);
    NSString *description = nil;
    
    NSDictionary *userInfo = [self userInfo];
    NSString *localizedRecoverySuggestion = [userInfo valueForKey:@"NSLocalizedRecoverySuggestion"];
    NSData *JSONData = [localizedRecoverySuggestion dataUsingEncoding:NSUTF8StringEncoding];
    
    id responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData
                                                      options:NSJSONReadingAllowFragments
                                                        error:nil];
    
//    NSInteger code = [[(NSDictionary *)responseJSON valueForKey:@"error_code"] integerValue];
    NSString *msg = [(NSDictionary *)responseJSON valueForKey:@"error_msg"];
    
    switch (self.code) {
//        case 400:
//            description = @"请求的地址不存在";
//            break;
//        case 401:
//            description = @"未授权";
//            break;
//        case 403:
//            description = @"被禁止访问";
//            break;
//        case 404:
//            description = @"请求的资源不存在";
//            break;
        case 500:
            description = @"内部错误";
            break;
        default:
            description = msg;
            break;
    }
    //    NSLog(@"------------>info: %@", error.userInfo);
    return description;
}

@end
