//
//  UILabel+Helpers.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-23.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "UILabel+Helpers.h"

@implementation UILabel (Helpers)

- (void)setDynamicFrame {
    
    CGSize size = paragraphSize(self.text, self.font, CGSizeMake(280, 1000));
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y + 6, self.frame.size.width, size.height);
}

CGSize paragraphSize(NSString *text, UIFont *font, CGSize size) {
    
    return [text        sizeWithFont:font
                   constrainedToSize:CGSizeMake(size.width, size.height)
                       lineBreakMode:NSLineBreakByWordWrapping];
}

@end
