//
//  AppDelegate.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-20.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "AppDelegate.h"

#import "StoreManager.h"

#import "APPSettings.h"

#import "MobClick.h"

#import "Constants.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[APPSettings instance] baseSetting];
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:REALTIME channelId:@"iCatholic"];
    [MobClick checkUpdate:@"新版本 " cancelButtonTitle:@"忽略" otherButtonTitles:@"更新"];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[StoreManager instance] saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[StoreManager instance] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[StoreManager instance] saveContext];
}

@end
