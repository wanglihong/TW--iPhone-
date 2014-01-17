//
//  UITableView+Animates.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-29.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "UITableView+Animates.h"

@implementation UITableView (Animates)

//- (void)reloadData:(BOOL)animated
//{
//    [self reloadData];
//    
//    if (animated) {
//        
//        CATransition *animation = [CATransition animation];
//        [animation setType:kCATransitionPush];
//        [animation setSubtype:kCATransitionFromBottom];
//        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//        [animation setFillMode:kCAFillModeBoth];
//        [animation setDuration:.5];
//        [[self layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
//        
//    }
//}

- (void)reloadData:(BOOL)animated
{
    [self reloadData];
    
    if (animated)
    {
        [self reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.numberOfSections)] withRowAnimation:UITableViewRowAnimationBottom];
    }
}

@end
