//
//  MainCollectionViewCell.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-21.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIView * bgView;
@property (nonatomic, weak) IBOutlet UIImageView * logoView;
@property (nonatomic, weak) IBOutlet UILabel * titleLabel;
@property (nonatomic, weak) IBOutlet UILabel * numberLabel;
@property (nonatomic, weak) IBOutlet UIView *leftLine;
@property (nonatomic, weak) IBOutlet UIView *bottomLine;

- (void)setNumber:(NSInteger)count;

@end
