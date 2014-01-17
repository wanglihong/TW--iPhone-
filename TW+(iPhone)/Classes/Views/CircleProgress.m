//
//  CircleProgress.m
//  TW+
//
//  Created by Dennis Yang on 13-8-8.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "CircleProgress.h"

@interface CircleProgress ()

@property (strong, nonatomic) UIColor *bgColor;
@property (strong, nonatomic) UIColor *pgColor;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float progress;
@property (strong, nonatomic) UILabel *progressLabel;
@property (strong, nonatomic) UILabel *markLabel;

@end

@implementation CircleProgress

- (id)initWithFrame:(CGRect)frame bgColor:(UIColor *)bgc pgColor:(UIColor *)pgc width:(CGFloat)wid
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.bgColor = bgc;
        self.pgColor = pgc;
        self.width = wid;
        
        self.progressLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.progressLabel.backgroundColor = [UIColor clearColor];
        self.progressLabel.font = [UIFont systemFontOfSize:frame.size.width/2];
        self.progressLabel.textAlignment = NSTextAlignmentCenter;
        self.progressLabel.textColor = pgc;
        [self addSubview:self.progressLabel];
        
        self.markLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width*3/4, frame.size.height/4, frame.size.width/4, frame.size.height/4)];
        self.markLabel.backgroundColor = [UIColor clearColor];
        self.markLabel.textColor = pgc;
        self.markLabel.text = @"%";
        [self addSubview:self.markLabel];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGPoint center = CGPointMake(self.bounds.size.width / 2,self.bounds.size.height / 2);
    float radius = self.bounds.size.width / 2 - self.width/2;
    
    
    // draw circle background
    UIBezierPath *bgCircle = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:radius
                                                        startAngle:(CGFloat) - M_PI_2
                                                          endAngle:(CGFloat)(1.5 * M_PI)
                                                         clockwise:YES];
    [self.bgColor setStroke];
    [bgCircle setLineWidth:self.width];
    [bgCircle stroke];
    
    
    // draw circle
    UIBezierPath *pgCircle = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:radius
                                                        startAngle:(CGFloat) - M_PI_2
                                                          endAngle:(CGFloat)(- M_PI_2 + self.progress * (2 * M_PI))
                                                         clockwise:YES];
    [self.pgColor setStroke];
    [pgCircle setLineWidth:self.width];
    [pgCircle stroke];
    
    if (self.progress == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)updateProgress:(float)progress
{
    self.progress = progress;
    self.progressLabel.text = [NSString stringWithFormat:@"%d", (int)(progress * 100)];
    [self setNeedsDisplay];
}

@end
