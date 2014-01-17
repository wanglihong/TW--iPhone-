//
//  UIImageView+Blurred.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-22.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlurredImageCompletionBlock)(NSError *error);

extern NSString *const kBlurredImageErrorDomain;

extern CGFloat   const kBlurredImageDefaultBlurRadius;

enum BlurredImageError {
    BlurredImageErrorFilterNotAvailable = 0,
};

@interface UIImageView (Blurred)

- (void)setImageToBlur: (UIImage *)image
            blurRadius: (CGFloat)blurRadius
       completionBlock: (BlurredImageCompletionBlock) completion;

@end
