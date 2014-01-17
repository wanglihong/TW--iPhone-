//
//  ReadViewController.h
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-23.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "BaseViewController.h"

@interface ReadViewController : BaseViewController <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *contentView;
@property (nonatomic, strong) Document *document;

@end
