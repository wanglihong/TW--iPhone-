//
//  RecentViewController.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-12-12.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "BaseViewController.h"

@interface RecentViewController : BaseViewController <UIScrollViewDelegate>
{
    NSUInteger _currentPage;
    NSUInteger _pageLimit;
    BOOL _theEnd;
    
    NSMutableArray *_localDocs;
}

@property (nonatomic, weak) IBOutlet UITableView *recentTableView;

@end
