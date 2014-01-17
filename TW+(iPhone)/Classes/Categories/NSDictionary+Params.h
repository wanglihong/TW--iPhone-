//
//  NSDictionary+Params.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-23.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Params)

+ (NSDictionary *)baseDictionary;
+ (NSDictionary *)paramsWithBrand:(NSString *)brandId;
+ (NSDictionary *)paramsWithUserName:(NSString *)userName password:(NSString *)password;

@end
