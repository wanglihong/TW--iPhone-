//
//  AppAPIClient.m
//  AFNetworkDemo
//
//  Created by Dennis Yang on 13-5-22.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "AppAPIClient.h"
#import "AFJSONRequestOperation.h"
#import "Constants.h"



@implementation AppAPIClient

+ (AppAPIClient *)sharedClient
{
    static AppAPIClient *_instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _instance = [[AppAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kAPIBaseURLString]];
    });
    
    return _instance;
}

- (id)initWithBaseURL:(NSURL *)url
{
    if (self == [super initWithBaseURL:url]) {
        
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self setDefaultHeader:@"Authorization" value:[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]];
        
        if ([[url scheme] isEqualToString:@"https"]) {
            [self setDefaultSSLPinningMode:AFSSLPinningModePublicKey];
        }
        
        // By default, AFJSONRequestOperation accepts only "text/json", "application/json"
        // or "text/javascript" content-types from server, but you are getting "text/html".
        // Fixing on server would be better,
        // but you can also add "text/html" content type as acceptable in your app:
        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    }
    
    return self;
}

@end
