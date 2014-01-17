//
//  MainCollectionViewCell.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-21.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "MainCollectionViewCell.h"

#import "Constants.h"

@implementation MainCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:15.0f];
    
    UIColor* mainColor = THEME_COLOR_FULL;
    
    self.bgView.backgroundColor = [UIColor clearColor];
//    self.bgView.layer.cornerRadius = 3.0f;
    
    self.clipsToBounds = YES;
    
    
    self.numberLabel.backgroundColor = [UIColor whiteColor];
    self.numberLabel.layer.cornerRadius = 10.0f;
    self.numberLabel.textColor = mainColor;
    self.numberLabel.layer.borderWidth = 0.5f;
    self.numberLabel.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:0.6].CGColor;
    
    self.bottomLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    self.leftLine.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
}

- (void)setNumber:(NSInteger)count {

    self.numberLabel.alpha = count > 0 ? 1 : 0 ;
    self.numberLabel.text = [NSString stringWithFormat:@"%d", count];
    
    if (count != 0) {
        
        CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:(M_PI_2)];
        rotationAnimation.duration = 2.0f;
        rotationAnimation.repeatCount = 1;//HUGE_VALF;
        rotationAnimation.autoreverses = YES;
        rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [self.numberLabel.layer addAnimation:rotationAnimation forKey:@"rotateAnimation"];
    }
}

-(void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

-(void) drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.highlighted) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 1, 0, 0, 1);
        CGContextFillRect(context, self.bounds);
    }
}

@end
