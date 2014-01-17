//
//  MainViewController.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-20.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "BaseViewController.h"

@interface MainViewController : BaseViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;

- (void)loadBrandsFromeRemoteHost;

@end
