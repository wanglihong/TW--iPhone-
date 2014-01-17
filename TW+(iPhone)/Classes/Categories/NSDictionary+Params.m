//
//  NSDictionary+Params.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-23.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "NSDictionary+Params.h"

#import "Constants.h"

@implementation NSDictionary (Params)

+ (NSDictionary *)paramsWithBrand:(NSString *)brandId {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary baseDictionary]];
    [dic setValue:brandId forKey:@"category_ids"];
    return dic;
}

+ (NSDictionary *)paramsWithUserName:(NSString *)userName password:(NSString *)password {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary baseDictionary]];
    [dic setValue:userName forKey:@"login"];
    [dic setValue:password forKey:@"pass"];
    return dic;
}

+ (NSDictionary *)baseDictionary {
    
    return [NSDictionary dictionaryWithObject:kTWAppID forKey:@"app_id"];
}

@end
