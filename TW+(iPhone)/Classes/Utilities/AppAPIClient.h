//
//  AppAPIClient.h
//  AFNetworkDemo
//
//  Created by Dennis Yang on 13-5-22.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "AFHTTPClient.h"

@interface AppAPIClient : AFHTTPClient

+ (AppAPIClient *)sharedClient;

@end
