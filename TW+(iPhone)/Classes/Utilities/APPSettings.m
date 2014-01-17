//
//  APPSettings.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-26.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "APPSettings.h"

#define token @"eae3a59beb214068a60ba0edbc9c15db"
#define expir @"1234564151354"

static APPSettings *instance = NULL;

@implementation APPSettings

+ (id)instance
{
    @synchronized(self)
	{
        if (instance == NULL)
		{
            instance = [[self alloc] init];
		}
	}
    return(instance);
}

- (void)baseSetting {

    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    [defaultValues setValue:nil forKey:@"username"];
    [defaultValues setValue:nil forKey:@"password"];
    [defaultValues setValue:nil forKey:@"access_token"];
    [defaultValues setValue:nil forKey:@"expires_on"];
    [defaultValues setObject:[NSMutableArray array] forKey:@"favorite"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

@end
