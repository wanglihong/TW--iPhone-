//
//  BaseNavigationController.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-30.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "BaseNavigationController.h"




@interface BaseNavigationController ()

@end




@implementation BaseNavigationController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
