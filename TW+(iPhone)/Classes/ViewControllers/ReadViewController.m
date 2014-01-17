//
//  ReadViewController.m
//  TW+(iPhone)
//
//  Created by Dennis Yang on 13-8-23.
//  Copyright (c) 2013年 Dennis Yang. All rights reserved.
//

#import "ReadViewController.h"




@interface ReadViewController ()

@end




@implementation ReadViewController

@synthesize document;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:self.document.name];
    [self styleNavigationBarWithFontName:@"Avenir-Black"];
    [self styleNavigationBarButtonItemWithImage:@"back.png" action:@selector(back:) isLeft:YES];
    
    NSString *urlString = nil;
    NSURLRequest *request = nil;
    
    // 附件为超链接
    if (self.document.fileUrl.length == 0 && self.document.website.length > 0 ) {
        urlString = self.document.website;
        request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    }
    
    // 附件为本地文件
    else {
        urlString = [NSString stringWithFormat:@"%@/%@.%@", documentPath(), self.document.dId, self.document.fileType];
        request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:urlString]];
    }
    
    [self.contentView setScalesPageToFit:YES];
    [self.contentView loadRequest:request];
    [self.contentView setDelegate:self];
}

- (void)back:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
    [[[(UINavigationController *)self.navigationController.presentingViewController viewControllers] lastObject] performSelector:@selector(close) withObject:nil afterDelay:0.25];
}

@end
