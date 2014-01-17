//
//  FeedViewController.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-21.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "BaseViewController.h"

@interface FeedViewController : BaseViewController

@property (nonatomic, weak) IBOutlet UITableView* feedTableView;

@property (nonatomic, strong) Brand *brand;

@end
